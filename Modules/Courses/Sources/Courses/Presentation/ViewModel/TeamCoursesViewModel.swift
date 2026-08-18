//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import Combine
import SwiftUI
import Common

@MainActor
public class TeamCoursesViewModel: ObservableObject {
    @Published public var courses: [TeamCourse] = []
    @Published public var pendingMembers: [TeamMember] = []
    @Published public var teamMembers: [TeamMember] = []
    @Published public var isLoading: Bool = false
    @Published public var isMembersLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    private let teamId: String
    private let organizationId: String
    private let getCoursesUseCase: GetTeamCoursesUseCase
    private let createTeamCourseUseCase: CreateTeamCourseUseCase
    private let uploadTeamCourseMaterialUseCase: UploadTeamCourseMaterialUseCase
    private let cloudinaryService: CloudinaryServiceProtocol
    private let getTeamMembersUseCase: GetTeamMembersUseCase
    private let acceptMemberUseCase: AcceptMemberUseCase
    private let declineMemberUseCase: DeclineMemberUseCase
    
    nonisolated public init(
        teamId: String,
        organizationId: String,
        getCoursesUseCase: GetTeamCoursesUseCase,
        createTeamCourseUseCase: CreateTeamCourseUseCase,
        uploadTeamCourseMaterialUseCase: UploadTeamCourseMaterialUseCase,
        cloudinaryService: CloudinaryServiceProtocol,
        getTeamMembersUseCase: GetTeamMembersUseCase,
        acceptMemberUseCase: AcceptMemberUseCase,
        declineMemberUseCase: DeclineMemberUseCase
    ) {
        self.teamId = teamId
        self.organizationId = organizationId
        self.getCoursesUseCase = getCoursesUseCase
        self.createTeamCourseUseCase = createTeamCourseUseCase
        self.uploadTeamCourseMaterialUseCase = uploadTeamCourseMaterialUseCase
        self.cloudinaryService = cloudinaryService
        self.getTeamMembersUseCase = getTeamMembersUseCase
        self.acceptMemberUseCase = acceptMemberUseCase
        self.declineMemberUseCase = declineMemberUseCase
    }
    
    public func fetchCourses() async {
        self.isLoading = true
        self.errorMessage = nil
        do {
            let fetchedCourses = try await getCoursesUseCase.execute(teamId: teamId, organizationId: organizationId)
            self.courses = fetchedCourses.map { course in
                let components = course.title.components(separatedBy: "|")
                if components.count == 3 {
                    // Format: orgId|courseName|cloudinaryUrl
                    let cleanTitle = components[1]
                    let thumbnailUrl = components[2]
                    return TeamCourse(id: course.id, title: cleanTitle, progress: course.progress, thumbnailUrl: thumbnailUrl)
                } else if course.title.hasPrefix("\(organizationId)_") {
                    // Fallback for old format: orgId_courseName
                    let cleanTitle = String(course.title.dropFirst("\(organizationId)_".count))
                    return TeamCourse(id: course.id, title: cleanTitle, progress: course.progress, thumbnailUrl: course.thumbnailUrl)
                }
                return course
            }
        } catch {
            self.errorMessage = error.localizedDescription
            print("Fetch Courses Error: \(error)")
        }
        self.isLoading = false
    }
    
    public func createCourse(name: String, startDate: String, endDate: String, thumbnail: UIImage?, materialUrl: URL?) async -> Bool {
        self.isLoading = true
        self.errorMessage = nil
        do {
            var thumbnailUrl = "mock-url"
            if let thumbnail = thumbnail, let jpegData = thumbnail.jpegData(compressionQuality: 0.8) {
                thumbnailUrl = try await cloudinaryService.uploadImage(imageData: jpegData)
            }
            
            let injectedName = "\(organizationId)|\(name)|\(thumbnailUrl)"
            let courseId = try await createTeamCourseUseCase.execute(
                teamId: teamId,
                organizationId: organizationId,
                name: injectedName,
                startDate: startDate,
                endDate: endDate,
                thumbnailUrl: thumbnailUrl,
                materialIds: []
            )
            
            if let materialUrl = materialUrl {
                let gotAccess = materialUrl.startAccessingSecurityScopedResource()
                if let fileData = try? Data(contentsOf: materialUrl) {
                    // Upload material to Cloudinary
                    _ = try await cloudinaryService.uploadPDF(fileData: fileData, fileName: materialUrl.lastPathComponent)
                    // Upload material to backend for the created course
                    _ = try await uploadTeamCourseMaterialUseCase.execute(courseId: courseId, fileData: fileData, fileName: materialUrl.lastPathComponent)
                }
                if gotAccess {
                    materialUrl.stopAccessingSecurityScopedResource()
                }
            }
            self.isLoading = false
            await fetchCourses()
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            return false
        }
    }
    
    // MARK: - Members
    
    public func fetchMembers() async {
        self.isMembersLoading = true
        do {
            let result = try await getTeamMembersUseCase.execute(teamId: teamId)
            self.pendingMembers = result.pending
            self.teamMembers = result.active
        } catch {
            print("Fetch Members Error: \(error)")
        }
        self.isMembersLoading = false
    }
    
    public func acceptMember(memberId: String) async {
        // Optimistic UI update
        if let index = pendingMembers.firstIndex(where: { $0.id == memberId }) {
            var member = pendingMembers.remove(at: index)
            // Just append to teamMembers to feel responsive
            teamMembers.append(member)
        }
        
        do {
            try await acceptMemberUseCase.execute(memberId: memberId)
            // Re-fetch to ensure sync with server
            await fetchMembers()
        } catch {
            print("Accept Member Error: \(error)")
            // Revert on failure by refetching
            await fetchMembers()
        }
    }
    
    public func declineMember(memberId: String) async {
        // Optimistic UI update
        pendingMembers.removeAll(where: { $0.id == memberId })
        
        do {
            try await declineMemberUseCase.execute(memberId: memberId)
        } catch {
            print("Decline Member Error: \(error)")
            // Revert on failure
            await fetchMembers()
        }
    }
}
