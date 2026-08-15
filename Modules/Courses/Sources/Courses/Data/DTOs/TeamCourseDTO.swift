//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation

public struct TeamCourseDTO: Decodable {
    public let id: String
    public let name: String
    public let progress: Double
    
    func toDomain() -> TeamCourse {
        return TeamCourse(id: id, title: name, progress: progress)
    }
}
