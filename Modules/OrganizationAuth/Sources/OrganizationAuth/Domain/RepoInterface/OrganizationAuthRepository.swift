import Foundation

public protocol OrganizationAuthRepository {
    func login(request: LoginRequest) async throws -> AuthResponse
    func register(request: RegisterOrganizationRequest) async throws -> AuthResponse
    func getCurrentUserToken() async throws -> String
}

public enum AuthError: Error, LocalizedError {
    case networkError(String)
    case invalidCredentials
    case invalidData
    case unknown
    
    public var errorDescription: String? {
        switch self {
        case .networkError(let message): return message
        case .invalidCredentials: return "Invalid email or password."
        case .invalidData: return "Invalid data provided."
        case .unknown: return "An unknown error occurred."
        }
    }
}
