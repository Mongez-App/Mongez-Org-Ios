//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
public struct TeamCourseMaterialDTO: Decodable {
    public let id: String
    public let fileName: String
    public let fileType: String?
    public let pageCount: Int
    public let fileSizeMb: Double
    public let fileUrl: String?
    public let uploadedAt: String?
    
    func toDomain() -> TeamCourseMaterial {
        return TeamCourseMaterial(
            id: id,
            fileName: fileName,
            fileType: fileType,
            pageCount: pageCount,
            fileSizeMb: fileSizeMb,
            fileUrl: fileUrl,
            uploadedAt: uploadedAt
        )
    }
}
