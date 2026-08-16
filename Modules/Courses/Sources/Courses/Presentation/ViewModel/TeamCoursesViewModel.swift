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
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    private let teamId: String
    private let organizationId: String
    private let getCoursesUseCase: GetTeamCoursesUseCase
    private let createTeamCourseUseCase: CreateTeamCourseUseCase
    private let uploadTeamCourseMaterialUseCase: UploadTeamCourseMaterialUseCase
    private let cloudinaryService: CloudinaryServiceProtocol
    
    nonisolated public init(
        teamId: String,
        organizationId: String,
        getCoursesUseCase: GetTeamCoursesUseCase,
        createTeamCourseUseCase: CreateTeamCourseUseCase,
        uploadTeamCourseMaterialUseCase: UploadTeamCourseMaterialUseCase,
        cloudinaryService: CloudinaryServiceProtocol
    ) {
        self.teamId = teamId
        self.organizationId = organizationId
        self.getCoursesUseCase = getCoursesUseCase
        self.createTeamCourseUseCase = createTeamCourseUseCase
        self.uploadTeamCourseMaterialUseCase = uploadTeamCourseMaterialUseCase
        self.cloudinaryService = cloudinaryService
    }
    
    public func fetchCourses() async {
        self.isLoading = true
        self.errorMessage = nil
        do {
            self.courses = try await getCoursesUseCase.execute(teamId: teamId, organizationId: organizationId)
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
            
            let courseId = try await createTeamCourseUseCase.execute(
                teamId: teamId,
                organizationId: organizationId,
                name: name,
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
}
