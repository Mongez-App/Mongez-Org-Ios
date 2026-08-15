//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
public struct GetTeamCoursesUseCase {
    private let repository: TeamCoursesRepository
    public init(repository: TeamCoursesRepository) { self.repository = repository }
    
    public func execute(teamId: String, organizationId: String) async throws -> [TeamCourse] {
        return try await repository.getTeamCourses(teamId: teamId, organizationId: organizationId)
    }
}
