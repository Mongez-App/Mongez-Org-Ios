//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
public struct CreateEventUseCase {
    private let repository: EventsRepository
    public init(repository: EventsRepository) { self.repository = repository }

    public func execute(teamId: String, organizationId: String, courseId: String, eventType: String, eventDate: String) async throws -> String {
        return try await repository.createEvent(teamId: teamId, organizationId: organizationId, courseId: courseId, eventType: eventType, eventDate: eventDate)
    }
}
