//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation

public struct EventDTO: Decodable {
    public let id: String
    public let courseId: String
    public let courseName: String?
    public let eventType: String
    public let eventDate: String

    func toDomain() -> TeamEvent? {
        guard let date = EventDTO.parseDate(eventDate) else { return nil }
        return TeamEvent(
            id: id,
            courseId: courseId,
            courseName: courseName ?? "",
            eventType: EventType(rawValue: eventType) ?? .assignment,
            eventDate: date
        )
    }

    private static func parseDate(_ string: String) -> Date? {
        if let date = ISO8601DateFormatter().date(from: string) {
            return date
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.date(from: string)
    }
}
