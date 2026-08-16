//
//  TeamMember.swift
//  Courses
//

import Foundation
import SwiftUI
import Common

public enum TeamMemberStatus: String, Codable {
    case pending
    case active
    case declined
}

public struct TeamMember: Identifiable, Equatable {
    public let id: String
    public let teamId: String?
    public let uid: String?
    public let name: String
    public let email: String?
    public let avatarInitials: String
    public let avatarColor: String?
    public let status: TeamMemberStatus
    public let requestedAt: Date?
    public let joinedAt: Date?

    public var avatarSwiftUIColor: Color {
        guard let hex = avatarColor else { return AppTheme.Colors.purple200 }
        return AppTheme.Colors.from(hex: hex)
    }

    public init(id: String, teamId: String? = nil, uid: String? = nil, name: String, email: String? = nil, avatarInitials: String, avatarColor: String? = nil, status: TeamMemberStatus, requestedAt: Date? = nil, joinedAt: Date? = nil) {
        self.id = id
        self.teamId = teamId
        self.uid = uid
        self.name = name
        self.email = email
        self.avatarInitials = avatarInitials
        self.avatarColor = avatarColor
        self.status = status
        self.requestedAt = requestedAt
        self.joinedAt = joinedAt
    }
}
