import Foundation

public struct LoginRequest: Codable, Equatable {
    public let email: String
    public let password: String

    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct RegisterRequest: Codable, Equatable {
    public let organizationName: String
    public let email: String
    public let password: String
    public let industryField: String
    public let description: String
    public let targetAudience: String
    public let servicesProvided: [String]
    public let contactEmail: String
    public let phoneNumber: String
    public let websiteURL: String
    public let address: String
    public let registrationNumber: String
    public let documentURL: String

    public init(
        organizationName: String = "",
        email: String = "",
        password: String = "",
        industryField: String = "",
        description: String = "",
        targetAudience: String = "",
        servicesProvided: [String] = [],
        contactEmail: String = "",
        phoneNumber: String = "",
        websiteURL: String = "",
        address: String = "",
        registrationNumber: String = "",
        documentURL: String = ""
    ) {
        self.organizationName = organizationName
        self.email = email
        self.password = password
        self.industryField = industryField
        self.description = description
        self.targetAudience = targetAudience
        self.servicesProvided = servicesProvided
        self.contactEmail = contactEmail
        self.phoneNumber = phoneNumber
        self.websiteURL = websiteURL
        self.address = address
        self.registrationNumber = registrationNumber
        self.documentURL = documentURL
    }
}
