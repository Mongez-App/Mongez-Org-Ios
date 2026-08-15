import Foundation

public final class OrganizationAuthRepositoryImpl: OrganizationAuthRepository {
    private let networkService: OrganizationAuthNetworkService
    private let keychain = KeychainManager.shared

    public init(networkService: OrganizationAuthNetworkService) {
        self.networkService = networkService
    }

    public func login(idToken: String, request: LoginRequest) async throws -> AuthResponse {
        let response = try await networkService.login(idToken: idToken, request: request)
        persistSession(response: response)
        return response
    }

    public func register(idToken: String, request: RegisterRequest) async throws -> AuthResponse {
        let response = try await networkService.register(idToken: idToken, request: request)
        persistSession(response: response)
        return response
    }

    private func persistSession(response: AuthResponse) {
        let uid = response.data.uid
        keychain.saveToken(uid)
        UserDefaults.standard.set(uid, forKey: "current_user_id")
    }
}
