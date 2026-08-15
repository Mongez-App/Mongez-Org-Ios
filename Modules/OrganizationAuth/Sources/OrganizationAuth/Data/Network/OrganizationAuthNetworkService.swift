import Foundation

public protocol OrganizationAuthNetworkService {
    func login(idToken: String, request: LoginRequest) async throws -> AuthResponse
    func register(idToken: String, request: RegisterRequest) async throws -> AuthResponse
}

public final class OrganizationAuthNetworkServiceImpl: OrganizationAuthNetworkService {
    private let baseURL: String
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    public init(
        baseURL: String = "https://api-gateway-production-5110.up.railway.app/api/v1",
        session: URLSession = .shared
    ) {
        self.baseURL = baseURL
        self.session = session
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }

    public func login(idToken: String, request: LoginRequest) async throws -> AuthResponse {
        try await performPost(
            path: "/organization/auth/login",
            idToken: idToken,
            body: request,
            expectedStatusCodes: 200...299
        )
    }

    public func register(idToken: String, request: RegisterRequest) async throws -> AuthResponse {
        try await performPost(
            path: "/organization/auth/register",
            idToken: idToken,
            body: request,
            expectedStatusCodes: 200...299
        )
    }

    private func performPost<T: Encodable>(
        path: String,
        idToken: String,
        body: T,
        expectedStatusCodes: ClosedRange<Int>
    ) async throws -> AuthResponse {
        guard let url = URL(string: "\(baseURL)\(path)") else {
            throw AuthError.networkError("Invalid endpoint URL.")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(idToken)", forHTTPHeaderField: "Authorization")

        do {
            request.httpBody = try encoder.encode(body)
        } catch {
            throw AuthError.invalidData
        }

        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await session.data(for: request)
        } catch {
            throw AuthError.networkError(error.localizedDescription)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.networkError("Invalid server response.")
        }

        guard expectedStatusCodes.contains(httpResponse.statusCode) else {
            throw buildError(statusCode: httpResponse.statusCode, data: data)
        }

        do {
            return try decoder.decode(AuthResponse.self, from: data)
        } catch {
            throw AuthError.decodingError(error.localizedDescription)
        }
    }

    private struct ServerErrorBody: Decodable {
        let message: String?
        let error: String?

        var resolved: String {
            message ?? error ?? "Something went wrong. Please try again."
        }
    }

    private func buildError(statusCode: Int, data: Data) -> AuthError {
        if let body = try? decoder.decode(ServerErrorBody.self, from: data) {
            return AuthError.networkError(body.resolved)
        }
        let fallback = HTTPURLResponse.localizedString(forStatusCode: statusCode)
        return AuthError.networkError("Request failed with status \(statusCode): \(fallback)")
    }
}
