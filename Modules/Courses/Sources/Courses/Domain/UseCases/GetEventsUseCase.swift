//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
public struct GetEventsUseCase {
    private let repository: EventsRepository
    public init(repository: EventsRepository) { self.repository = repository }

    public func execute(teamId: String, organizationId: String) async throws -> [TeamEvent] {
        return try await repository.getEvents(teamId: teamId, organizationId: organizationId)
    }
}
