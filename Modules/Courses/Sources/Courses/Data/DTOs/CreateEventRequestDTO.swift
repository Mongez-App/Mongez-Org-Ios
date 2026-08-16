//
//  File.swift
//
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation

public struct CreateEventRequestDTO: Encodable {
    public let teamId: String
    public let courseId: String
    public let eventType: String
    public let eventDate: String
}
