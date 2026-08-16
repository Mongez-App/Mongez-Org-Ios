//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
public struct GetTeamCourseMaterialsResponseDTO: Decodable {
    public let courseId: String
    public let materials: [TeamCourseMaterialDTO]
    public let total: Int
}
