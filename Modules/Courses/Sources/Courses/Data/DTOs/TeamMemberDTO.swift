//
//  TeamMemberDTO.swift
//  Courses
//

import Foundation

public struct GetTeamMembersResponseDTO: Decodable {
    public let teamId: String
    public let pendingMembers: [TeamMemberDTO]
    public let teamMembers: [TeamMemberDTO]
    public let pendingTotal: Int?
    public let teamTotal: Int?
}

public struct TeamMemberDTO: Decodable {
    public let id: String
    public let teamId: String?
    public let uid: String?
    public let name: String
    public let email: String?
    public let avatarInitials: String?
    public let avatarColor: String?
    public let status: String
    public let requestedAt: String?
    public let joinedAt: String?

    public func toDomain() -> TeamMember {
        // Parse dates if necessary
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let fallbackFormatter = ISO8601DateFormatter()
        
        var reqDate: Date? = nil
        if let reqStr = requestedAt {
            reqDate = formatter.date(from: reqStr) ?? fallbackFormatter.date(from: reqStr)
        }
        
        var joinDate: Date? = nil
        if let joinStr = joinedAt {
            joinDate = formatter.date(from: joinStr) ?? fallbackFormatter.date(from: joinStr)
        }
        
        let memberStatus = TeamMemberStatus(rawValue: status) ?? .pending
        
        return TeamMember(
            id: id,
            teamId: teamId,
            uid: uid,
            name: name,
            email: email,
            avatarInitials: avatarInitials ?? "??",
            avatarColor: avatarColor,
            status: memberStatus,
            requestedAt: reqDate,
            joinedAt: joinDate
        )
    }
}

public struct MemberActionRequestDTO: Encodable {
    public let memberId: String
    
    public init(memberId: String) {
        self.memberId = memberId
    }
}
