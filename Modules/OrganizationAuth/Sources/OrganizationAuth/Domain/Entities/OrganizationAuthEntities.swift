import Foundation

public struct OrganizationUser: Codable, Identifiable {
    public let id: String
    public let email: String
    public let token: String?
    
    public init(id: String, email: String, token: String? = nil) {
        self.id = id
        self.email = email
        self.token = token
    }
}

public struct OrganizationProfile: Codable, Identifiable {
    public let id: String
    public let organizationName: String
    public let industryField: String
    public let description: String?
    
    // Services & Audience
    public let targetAudience: String
    public let servicesProvided: [String]
    public let numberOfMembers: String
    
    // Contact & Location
    public let contactEmail: String
    public let phoneNumber: String
    public let websiteURL: String?
    public let address: String
    public let registrationNumber: String?
    
    public init(id: String, organizationName: String, industryField: String, description: String?, targetAudience: String, servicesProvided: [String], numberOfMembers: String, contactEmail: String, phoneNumber: String, websiteURL: String?, address: String, registrationNumber: String?) {
        self.id = id
        self.organizationName = organizationName
        self.industryField = industryField
        self.description = description
        self.targetAudience = targetAudience
        self.servicesProvided = servicesProvided
        self.numberOfMembers = numberOfMembers
        self.contactEmail = contactEmail
        self.phoneNumber = phoneNumber
        self.websiteURL = websiteURL
        self.address = address
        self.registrationNumber = registrationNumber
    }
}

public struct AuthResponse: Codable {
    public let token: String
    public let user: OrganizationUser
    public let profile: OrganizationProfile?
    
    public init(token: String, user: OrganizationUser, profile: OrganizationProfile?) {
        self.token = token
        self.user = user
        self.profile = profile
    }
}
