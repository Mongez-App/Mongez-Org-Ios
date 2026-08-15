import Foundation

public struct Organization: Codable, Identifiable, Equatable {
    public let id: String
    public let email: String
    public let name: String
    public let avatar: String?
    public let description: String?
    public let establishedAt: String?
    public let noOfStudents: Int
    public let noOfCourses: Int
    public let noOfTeams: Int

    public init(
        id: String,
        email: String,
        name: String,
        avatar: String? = nil,
        description: String? = nil,
        establishedAt: String? = nil,
        noOfStudents: Int = 0,
        noOfCourses: Int = 0,
        noOfTeams: Int = 0
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.avatar = avatar
        self.description = description
        self.establishedAt = establishedAt
        self.noOfStudents = noOfStudents
        self.noOfCourses = noOfCourses
        self.noOfTeams = noOfTeams
    }
}
