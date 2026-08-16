//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
public struct GetEventsResponseDTO: Decodable {
    public let teamId: String?
    public let events: [EventDTO]?
    public let total: Int?
}
