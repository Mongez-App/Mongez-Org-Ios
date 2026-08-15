import Foundation

public struct LoginRequest: Codable {
    public let email: String
    public let password: String
    
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

public struct RegisterOrganizationRequest: Codable {
    // Step 1: Account
    public var email: String = ""
    public var password: String = ""
    
    // Step 2: Basic Info
    public var organizationName: String = "" // Added organization name as part of basic info
    public var industryField: String = ""
    public var description: String = ""
    
    // Step 3: Services & Audience
    public var targetAudience: String = ""
    public var servicesProvided: [String] = []
    public var numberOfMembers: String = ""
    
    // Step 4: Contact & Location
    public var contactEmail: String = ""
    public var phoneNumber: String = ""
    public var websiteURL: String = ""
    public var address: String = ""
    public var registrationNumber: String = ""
    public var documentURL: String = ""
    
    public init() {}
}
