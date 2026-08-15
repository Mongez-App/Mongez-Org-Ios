import Foundation

public struct AuthResponse: Codable, Equatable {
    public let message: String
    public let data: OrganizationData

    public init(message: String, data: OrganizationData) {
        self.message = message
        self.data = data
    }
}

public struct OrganizationData: Codable, Equatable {
    public let uid: String
    public let email: String
    public let name: String
    public let avatar: String?
    public let description: String?
    public let establishedAt: String?
    public let noOfStudents: Int
    public let noOfCourses: Int
    public let noOfTeams: Int

    enum CodingKeys: String, CodingKey {
        case uid
        case email
        case name
        case avatar
        case description
        case establishedAt = "established_at"
        case noOfStudents = "no_of_students"
        case noOfCourses = "no_of_courses"
        case noOfTeams = "no_of_teams"
    }

    public init(
        uid: String,
        email: String,
        name: String,
        avatar: String? = nil,
        description: String? = nil,
        establishedAt: String? = nil,
        noOfStudents: Int = 0,
        noOfCourses: Int = 0,
        noOfTeams: Int = 0
    ) {
        self.uid = uid
        self.email = email
        self.name = name
        self.avatar = avatar
        self.description = description
        self.establishedAt = establishedAt
        self.noOfStudents = noOfStudents
        self.noOfCourses = noOfCourses
        self.noOfTeams = noOfTeams
    }

    public var toOrganization: Organization {
        Organization(
            id: uid,
            email: email,
            name: name,
            avatar: avatar,
            description: description,
            establishedAt: establishedAt,
            noOfStudents: noOfStudents,
            noOfCourses: noOfCourses,
            noOfTeams: noOfTeams
        )
    }
}

public extension AuthResponse {
    var organization: Organization {
        data.toOrganization
    }
}
