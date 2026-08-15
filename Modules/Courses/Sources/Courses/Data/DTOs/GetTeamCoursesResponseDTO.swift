//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
public struct GetTeamCoursesResponseDTO: Decodable {
    public let teamId: String
    public let courses: [TeamCourseDTO]
    public let total: Int
}
