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
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    
    private let teamId: String
    private let organizationId: String
    private let getCoursesUseCase: GetTeamCoursesUseCase
    private let createTeamCourseUseCase: CreateTeamCourseUseCase
    
    nonisolated public init(
        teamId: String,
        organizationId: String,
        getCoursesUseCase: GetTeamCoursesUseCase,
        createTeamCourseUseCase: CreateTeamCourseUseCase
    ) {
        self.teamId = teamId
        self.organizationId = organizationId
        self.getCoursesUseCase = getCoursesUseCase
        self.createTeamCourseUseCase = createTeamCourseUseCase
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
}
