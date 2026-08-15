import Foundation
import FirebaseAuth

public protocol OrganizationAuthNetworkService {
    func login(token: String) async throws -> AuthResponse
    func register(token: String, request: RegisterOrganizationRequest) async throws -> AuthResponse
}

public class OrganizationAuthNetworkServiceImpl: OrganizationAuthNetworkService {
    private let baseURL = "https://api-gateway-production-5110.up.railway.app/api/v1"
    
    public init() {}
    
    public func login(token: String) async throws -> AuthResponse {
        guard let url = URL(string: "\(baseURL)/organization/auth/login") else {
            throw AuthError.invalidData
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.networkError("Invalid response")
        }
        
        if httpResponse.statusCode == 401 {
            throw AuthError.networkError("Unauthorized token")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw AuthError.networkError("Server error: \(httpResponse.statusCode)")
        }
        
        let decoder = JSONDecoder()
        do {
            let authResponse = try decoder.decode(AuthResponse.self, from: data)
            return authResponse
        } catch {
            throw AuthError.invalidData
        }
    }
    
    public func register(token: String, request: RegisterOrganizationRequest) async throws -> AuthResponse {
        guard let url = URL(string: "\(baseURL)/organization/auth/register") else {
            throw AuthError.invalidData
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        urlRequest.httpBody = try? encoder.encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthError.networkError("Invalid response")
        }
        
        if httpResponse.statusCode == 401 {
            throw AuthError.networkError("Unauthorized token")
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw AuthError.networkError("Server error: \(httpResponse.statusCode)")
        }
        
        let decoder = JSONDecoder()
        do {
            let authResponse = try decoder.decode(AuthResponse.self, from: data)
            return authResponse
        } catch {
            throw AuthError.invalidData
        }
    }
}
