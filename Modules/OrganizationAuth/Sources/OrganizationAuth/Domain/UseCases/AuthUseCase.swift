import Foundation

public protocol AuthUseCase {
    func login(request: LoginRequest) async throws -> AuthResponse
    func register(request: RegisterRequest) async throws -> AuthResponse
}

public final class AuthUseCaseImpl: AuthUseCase {
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

    public func register(request: RegisterRequest) async throws -> AuthResponse {
        guard !request.organizationName.isEmpty,
              !request.email.isEmpty,
              !request.password.isEmpty else {
            throw AuthError.invalidData
        }
        return try await repository.register(request: request)
    }
}
