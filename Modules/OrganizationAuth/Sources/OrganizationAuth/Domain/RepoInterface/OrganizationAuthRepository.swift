import Foundation

public protocol OrganizationAuthRepository {
    func login(idToken: String, name: String) async throws -> AuthResponse
    func register(idToken: String, name: String) async throws -> AuthResponse
}

public enum AuthError: Error, LocalizedError {
    case networkError(String)
    case invalidCredentials
    case invalidData
    case decodingError(String)
    case unknown

    public var errorDescription: String? {
        switch self {
        case .networkError(let message):
            return message
        case .invalidCredentials:
            return "Invalid email or password."
        case .invalidData:
            return "Please fill all required fields correctly."
        case .decodingError(let message):
            return "Unable to process the server response. \(message)"
        case .unknown:
            return "An unknown error occurred. Please try again."
        }
    }
}
