//
//  File.swift
//
//
//  Created by Ahmed Tarek on 16/08/2026.
//

import Foundation

public struct TeamListResponse {
    let teams: [Team]
    let total: Int
}

public struct Team {
    let id: String
    let name: String
    let photoUrl: String?
    let progress: Int
    let events: [String]
}

public struct NewTeam {
    let id: String
    let name: String
    let photoUrl: String?
    let ownerId: String
    let progress: Int
    let events: [String]
    let createdAt: String
}
