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

        // Step 1: Firebase sign in
        let user: FirebaseAuth.User
        do {
            user = try await Auth.auth().signIn(
                withEmail: request.email,
                password: request.password
            ).user
        } catch let error as NSError {
            switch AuthErrorCode.Code(rawValue: error.code) {
            case .wrongPassword,
                 .userNotFound,
                 .invalidEmail,
                 .invalidCredential:
                throw AuthError.invalidCredentials
            default:
                throw AuthError.networkError(error.localizedDescription)
            }
        }

        // Step 2: Get token
        let idToken = try await user.getIDTokenResult(forcingRefresh: true).token

        // Step 3: Backend login — لو فشل نعمل register تلقائي
        do {
            let response = try await repository.login(idToken: idToken, request: request)
            return response
        } catch {
            // Backend مش لاقيه — نعمله register بالبيانات الموجودة
            let registerRequest = RegisterRequest(
                organizationName: user.displayName ?? request.email,
                email: request.email,
                password: request.password
            )
            return try await repository.register(idToken: idToken, request: registerRequest)
        }
    }

    public func register(request: RegisterRequest) async throws -> AuthResponse {
        guard !request.name.isEmpty,
              !request.email.isEmpty,
              !request.password.isEmpty else {
            throw AuthError.invalidData
        }

        var user: FirebaseAuth.User
        do {
            let result = try await Auth.auth().createUser(
                withEmail: request.email,
                password: request.password
            )
            user = result.user
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = request.name
            try await changeRequest.commitChanges()
        } catch let error as NSError
            where AuthErrorCode.Code(rawValue: error.code) == .emailAlreadyInUse {
            do {
                user = try await Auth.auth().signIn(
                    withEmail: request.email,
                    password: request.password
                ).user
            } catch {
                throw AuthError.networkError("An account with this email already exists.")
            }
        } catch let error as NSError {
            switch AuthErrorCode.Code(rawValue: error.code) {
            case .invalidEmail:
                throw AuthError.networkError("Invalid email address.")
            default:
                throw AuthError.networkError(error.localizedDescription)
            }
        }
        let idToken = try await user.getIDTokenResult(forcingRefresh: true).token
        return try await repository.register(idToken: idToken, request: request)
    }
}
