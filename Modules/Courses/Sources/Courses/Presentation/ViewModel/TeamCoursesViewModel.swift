//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import Combine
import SwiftUI

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
    private let getTeamMembersUseCase: GetTeamMembersUseCase
    private let acceptMemberUseCase: AcceptMemberUseCase
    private let declineMemberUseCase: DeclineMemberUseCase
    
    nonisolated public init(
        teamId: String,
        organizationId: String,
        getCoursesUseCase: GetTeamCoursesUseCase,
        createTeamCourseUseCase: CreateTeamCourseUseCase,
        getTeamMembersUseCase: GetTeamMembersUseCase,
        acceptMemberUseCase: AcceptMemberUseCase,
        declineMemberUseCase: DeclineMemberUseCase
    ) {
        self.teamId = teamId
        self.organizationId = organizationId
        self.getCoursesUseCase = getCoursesUseCase
        self.createTeamCourseUseCase = createTeamCourseUseCase
        self.getTeamMembersUseCase = getTeamMembersUseCase
        self.acceptMemberUseCase = acceptMemberUseCase
        self.declineMemberUseCase = declineMemberUseCase
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
    
    public func createCourse(name: String, startDate: String, endDate: String) async -> Bool {
        self.isLoading = true
        self.errorMessage = nil
        do {
            _ = try await createTeamCourseUseCase.execute(
                teamId: teamId,
                organizationId: organizationId,
                name: name,
                startDate: startDate,
                endDate: endDate,
                thumbnailUrl: "mock-url",
                materialIds: []
            )
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
