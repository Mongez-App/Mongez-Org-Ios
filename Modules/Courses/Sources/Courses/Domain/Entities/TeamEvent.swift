//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation

public struct TeamEvent: Identifiable, Equatable {
    public let id: String
    public let courseId: String
    public let courseName: String
    public let eventType: EventType
    public let eventDate: Date

    public init(id: String, courseId: String, courseName: String, eventType: EventType, eventDate: Date) {
        self.id = id
        self.courseId = courseId
        self.courseName = courseName
        self.eventType = eventType
        self.eventDate = eventDate
    }

    public var daysLeftText: String {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfEvent = calendar.startOfDay(for: eventDate)
        let days = calendar.dateComponents([.day], from: startOfToday, to: startOfEvent).day ?? 0

        switch days {
        case ..<0: return "Past"
        case 0: return "Today"
        case 1: return "Tomorrow"
        default: return "\(days) days left"
        }
    }
}
