import Foundation
import FirebaseAuth

public class OrganizationAuthRepositoryImpl: OrganizationAuthRepository {
    private let networkService: OrganizationAuthNetworkService
    
    public init(networkService: OrganizationAuthNetworkService) {
        self.networkService = networkService
    }
    
    public func login(request: LoginRequest) async throws -> AuthResponse {
        // Step 1: Firebase Auth
        _ = try await Auth.auth().signIn(withEmail: request.email, password: request.password)
        
        // Step 2: Get JWT Token
        let token = try await getCurrentUserToken()
        
        // Step 3: Backend API login
        return try await networkService.login(token: token)
    }
    
    public func register(request: RegisterOrganizationRequest) async throws -> AuthResponse {
        // Step 1: Firebase Auth Create User
        _ = try await Auth.auth().createUser(withEmail: request.email, password: request.password)
        
        // Step 2: Get JWT Token
        let token = try await getCurrentUserToken()
        
        // Step 3: Backend API register
        return try await networkService.register(token: token, request: request)
    }
    
    public func getCurrentUserToken() async throws -> String {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.networkError("User is not authenticated in Firebase.")
        }
        return try await user.getIDToken()
    }
}
