import Foundation
import FirebaseAuth

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

        do {
            let user = try await Auth.auth().signIn(withEmail: request.email, password: request.password).user
            let idToken = try await user.getIDToken()
            return try await repository.login(idToken: idToken, request: request)
        } catch let error as NSError
            where AuthErrorCode.Code(rawValue: error.code) == .wrongPassword
                || AuthErrorCode.Code(rawValue: error.code) == .userNotFound
                || AuthErrorCode.Code(rawValue: error.code) == .invalidEmail {
            throw AuthError.invalidCredentials
        } catch {
            throw AuthError.networkError(error.localizedDescription)
        }
    }

    public func register(request: RegisterRequest) async throws -> AuthResponse {
        guard !request.organizationName.isEmpty,
              !request.email.isEmpty,
              !request.password.isEmpty else {
            throw AuthError.invalidData
        }

        do {
            let user = try await Auth.auth().createUser(withEmail: request.email, password: request.password).user

            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = request.organizationName
            try await changeRequest.commitChanges()

            let idToken = try await user.getIDToken()
            return try await repository.register(idToken: idToken, request: request)
        } catch let error as NSError
            where AuthErrorCode.Code(rawValue: error.code) == .emailAlreadyInUse
                || AuthErrorCode.Code(rawValue: error.code) == .invalidEmail {
            throw AuthError.networkError("An account with this email already exists.")
        } catch {
            throw AuthError.networkError(error.localizedDescription)
        }
    }
}
