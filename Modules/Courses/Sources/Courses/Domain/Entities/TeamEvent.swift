//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation

public struct TeamEvent: Identifiable, Equatable {
    public let id: String
    public let courseId: String?
    public let courseName: String
    public let eventType: EventType
    public let eventDate: Date
    public let daysLeft: Int?

    public init(id: String, courseId: String? = nil, courseName: String, eventType: EventType, eventDate: Date, daysLeft: Int? = nil) {
        self.id = id
        self.courseId = courseId
        self.courseName = courseName
        self.eventType = eventType
        self.eventDate = eventDate
        self.daysLeft = daysLeft
    }

    public var daysLeftText: String {
        let days = daysLeft ?? computedDaysLeft

        switch days {
        case ..<0: return "Past"
        case 0: return "Today"
        case 1: return "Tomorrow"
        default: return "\(days) days left"
        }
    }

    private var computedDaysLeft: Int {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfEvent = calendar.startOfDay(for: eventDate)
        return calendar.dateComponents([.day], from: startOfToday, to: startOfEvent).day ?? 0
    }
}
