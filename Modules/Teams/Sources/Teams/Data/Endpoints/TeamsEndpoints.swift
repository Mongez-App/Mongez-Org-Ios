//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 16/08/2026.
//

import Foundation
import Common

public enum TeamsEndpoints : EndPoint {
    case getTeams
    case createTeam(request: CreateTeamRequestDTO)
    
    public var idToken: String? {
        UserDefaults.standard.string(forKey: "main_token")
    }
    
    public var baseURL: String {
        "https://api-gateway-production-5110.up.railway.app/api/v1"
    }
    
    public var path: String {
        switch self {
        case .getTeams:
            return "/organization/getTeams"
        case .createTeam:
            return "/organization/createTeam"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getTeams:
            return .get
        case .createTeam:
            return .post
        }
    }
    
    public var headers: [String : String]? {
        [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer \(idToken ?? "")"
        ]
    }
    
    public var body: Data? {
        switch self {
        case .getTeams:
            return nil
        case .createTeam(let request):
            return try? JSONEncoder().encode(request)
        }
    }
}

