//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import Common

public class EventsRepositoryImpl: EventsRepository {
    public init() {}

    public func getEvents(teamId: String, organizationId: String) async throws -> [TeamEvent] {
        let endpoint = EventsEndPoint.getEvents(teamId: teamId, organizationId: organizationId)
        let response = try await NetworkManger.shared.request(endpoint: endpoint, responseType: GetEventsResponseDTO.self)
        return response.events?.compactMap { $0.toDomain() } ?? []
    }

    public func createEvent(teamId: String, organizationId: String, courseId: String, eventType: String, eventDate: String) async throws -> String {
        let requestDTO = CreateEventRequestDTO(teamId: teamId, courseId: courseId, eventType: eventType, eventDate: eventDate)
        let endpoint = EventsEndPoint.createEvent(request: requestDTO, organizationId: organizationId)
        let response = try await NetworkManger.shared.request(endpoint: endpoint, responseType: CreateEventResponseDTO.self)
        return response.id
    }
}
