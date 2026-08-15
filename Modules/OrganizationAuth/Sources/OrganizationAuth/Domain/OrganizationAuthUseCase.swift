import Foundation

public protocol OrganizationAuthUseCase {
    func login(request: LoginRequest) async throws -> AuthResponse
    func register(request: RegisterOrganizationRequest) async throws -> AuthResponse
}

public class OrganizationAuthUseCaseImpl: OrganizationAuthUseCase {
    private let repository: OrganizationAuthRepository
    
    public init(repository: OrganizationAuthRepository) {
        self.repository = repository
    }
    
    public func login(request: LoginRequest) async throws -> AuthResponse {
        guard !request.email.isEmpty, !request.password.isEmpty else {
            throw AuthError.invalidData
        }
        return try await repository.login(request: request)
    }
    
    public func register(request: RegisterOrganizationRequest) async throws -> AuthResponse {
        guard !request.email.isEmpty, !request.password.isEmpty else {
            throw AuthError.invalidData
        }
        return try await repository.register(request: request)
    }
}
