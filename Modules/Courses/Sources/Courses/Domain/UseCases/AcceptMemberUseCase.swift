//
//  AcceptMemberUseCase.swift
//  Courses
//

import Foundation

public struct AcceptMemberUseCase {
    private let repository: TeamCoursesRepository

    public init(repository: TeamCoursesRepository) {
        self.repository = repository
    }

    public func execute(memberId: String) async throws {
        try await repository.acceptMember(memberId: memberId)
    }
}
