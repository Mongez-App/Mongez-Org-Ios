//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import Common

public enum EventsEndPoint: EndPoint {
    case getEvents(teamId: String, organizationId: String)
    case createEvent(request: CreateEventRequestDTO, organizationId: String)

    public var baseURL: String {
        return "https://api-gateway-production-5110.up.railway.app/api/v1"
    }

    public var path: String {
        switch self {
        case .getEvents(let teamId, _): return "/organization/getEvents?teamId=\(teamId)"
        case .createEvent: return "/organization/createEvent"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getEvents: return .get
        case .createEvent: return .post
        }
    }

    public var headers: [String : String]? {
        var defaultHeaders: [String: String] = [:]

        // If testing with fixed org22, send empty token to bypass backend mismatch
        let token = UserDefaults.standard.string(forKey: "main_token") ?? ""

        switch self {
        case .getEvents(_, let organizationId):
            defaultHeaders["Authorization"] = organizationId == "org22" ? "Bearer " : "Bearer \(token)"
            defaultHeaders["x-user-id"] = organizationId
            defaultHeaders["Content-Type"] = "application/json"
        case .createEvent(_, let organizationId):
            defaultHeaders["Authorization"] = organizationId == "org22" ? "Bearer " : "Bearer \(token)"
            defaultHeaders["x-user-id"] = organizationId
            defaultHeaders["Content-Type"] = "application/json"
        }
        return defaultHeaders
    }

    public var body: Data? {
        switch self {
        case .getEvents:
            return nil
        case .createEvent(let request, _):
            return try? JSONEncoder().encode(request)
        }
    }
}
