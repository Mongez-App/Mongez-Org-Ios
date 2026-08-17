//
//  File.swift
//
//
//  Created by Ahmed Tarek on 16/08/2026.
//

import Foundation
import Common

public enum ProfileEndpoints: EndPoint {
    case getProfile
    case updateProfile(name: String, photoUrl: String?)
    case uploadProfilePhoto(payload: Data, boundary: String)

    public var idToken: String? {
        UserDefaults.standard.string(forKey: "main_token")
    }

    public var baseURL: String {
        "https://api-gateway-production-5110.up.railway.app/api/v1"
    }

    public var path: String {
        switch self {
        case .getProfile:
            return "/organization/getProfile"
        case .updateProfile:
            return "/organization/updateProfile"
        case .uploadProfilePhoto:
            return "/organization/uploadProfilePhoto"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .getProfile:
            return .get
        case .updateProfile, .uploadProfilePhoto:
            return .post
        }
    }

    public var headers: [String : String]? {
        switch self {
        case .uploadProfilePhoto(_, let boundary):
            return [
                "Content-Type": "multipart/form-data; boundary=\(boundary)",
                "Authorization": "Bearer \(idToken ?? "")"
            ]
        default:
            return [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Authorization": "Bearer \(idToken ?? "")"
            ]
        }
    }

    public var body: Data? {
        switch self {
        case .getProfile:
            return nil
        case .updateProfile(let name, let photoUrl):
            var bodyDict: [String: Any] = ["name": name]
            if let photoUrl {
                bodyDict["photoUrl"] = photoUrl
            }
            return try? JSONSerialization.data(withJSONObject: bodyDict)
        case .uploadProfilePhoto(let payload, _):
            return payload
        }
    }
}
