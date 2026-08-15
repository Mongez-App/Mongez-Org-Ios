//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation

public struct CreateTeamCourseRequestDTO: Encodable {
    public let teamId: String
    public let name: String
    public let startDate: String
    public let endDate: String
    public let thumbnailUrl: String
    public let materialIds: [String]
}
