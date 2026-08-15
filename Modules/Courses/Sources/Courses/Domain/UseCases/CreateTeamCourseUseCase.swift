//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
public struct CreateTeamCourseUseCase {
    private let repository: TeamCoursesRepository
    public init(repository: TeamCoursesRepository) { self.repository = repository }
    
    public func execute(teamId: String, organizationId: String, name: String, startDate: String, endDate: String, thumbnailUrl: String, materialIds: [String]) async throws -> String {
        return try await repository.createTeamCourse(teamId: teamId, organizationId: organizationId, name: name, startDate: startDate, endDate: endDate, thumbnailUrl: thumbnailUrl, materialIds: materialIds)
    }
}
