//
//  GetTeamMembersUseCase.swift
//  Courses
//

import Foundation

public struct GetTeamMembersUseCase {
    private let repository: TeamCoursesRepository

    public init(repository: TeamCoursesRepository) {
        self.repository = repository
    }

    public func execute(teamId: String) async throws -> (pending: [TeamMember], active: [TeamMember]) {
        return try await repository.getTeamMembers(teamId: teamId)
    }
}
