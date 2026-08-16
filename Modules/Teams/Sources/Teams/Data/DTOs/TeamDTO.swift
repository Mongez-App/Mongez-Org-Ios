//
//  File.swift
//  
//
//  Created by Ahmed Tarek on 16/08/2026.
//

import Foundation

public struct TeamListResponseDTO: Decodable {
    let teams: [TeamDTO]
    let total: Int
    
    public static func mapToTeamListResponse(dto: TeamListResponseDTO) -> TeamListResponse {
        let teamList = dto.teams.map { TeamDTO.mapToTeam(dto: $0) }
        
        return TeamListResponse(
            teams: teamList,
            total: dto.total
        )
    }
    
    public static func mapToNewTeam(dto: TeamDTO) -> NewTeam {
        return NewTeam (
            id: dto.id,
            name: dto.name,
            photoUrl: dto.photoUrl,
            ownerId: dto.ownerId ?? "",
            progress: dto.progress,
            events: dto.events,
            createdAt: dto.createdAt ?? ""
        )
    }
    
}

public struct TeamDTO: Decodable {
    let id: String
    let name: String
    let photoUrl: String?
    let progress: Int
    let events: [String]
    
    let ownerId: String?
    let createdAt: String?
    
    public static func mapToTeam(dto: TeamDTO) -> Team {
        return Team(
            id: dto.id,
            name: dto.name,
            photoUrl: dto.photoUrl,
            progress: dto.progress,
            events: dto.events
        )
    }
}
