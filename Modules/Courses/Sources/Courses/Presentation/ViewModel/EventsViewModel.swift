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
public class EventsViewModel: ObservableObject {
    @Published public var events: [TeamEvent] = []
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil

    private let teamId: String
    private let organizationId: String
    private let getEventsUseCase: GetEventsUseCase
    private let createEventUseCase: CreateEventUseCase

    nonisolated public init(
        teamId: String,
        organizationId: String,
        getEventsUseCase: GetEventsUseCase,
        createEventUseCase: CreateEventUseCase
    ) {
        self.teamId = teamId
        self.organizationId = organizationId
        self.getEventsUseCase = getEventsUseCase
        self.createEventUseCase = createEventUseCase
    }

    public func fetchEvents() async {
        self.isLoading = true
        self.errorMessage = nil
        do {
            self.events = try await getEventsUseCase.execute(teamId: teamId, organizationId: organizationId)
        } catch {
            self.errorMessage = error.localizedDescription
            print("Fetch Events Error: \(error)")
        }
        self.isLoading = false
    }

    public func createEvent(courseId: String, eventType: EventType, eventDate: String) async -> Bool {
        self.isLoading = true
        self.errorMessage = nil
        do {
            _ = try await createEventUseCase.execute(
                teamId: teamId,
                organizationId: organizationId,
                courseId: courseId,
                eventType: eventType.rawValue,
                eventDate: eventDate
            )
            self.isLoading = false
            await fetchEvents()
            return true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            return false
        }
    }
}
