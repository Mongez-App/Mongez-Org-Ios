//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation

public protocol EventsRepository {
    func getEvents(teamId: String, organizationId: String) async throws -> [TeamEvent]
    func createEvent(teamId: String, organizationId: String, courseId: String, eventType: String, eventDate: String) async throws -> String
}
