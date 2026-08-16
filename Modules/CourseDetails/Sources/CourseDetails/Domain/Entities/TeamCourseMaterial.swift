//
//  File.swift
//  
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation

public struct TeamCourseMaterial: Identifiable, Equatable {
    public let id: String
    public let fileName: String
    public let fileType: String?
    public let pageCount: Int
    public let fileSizeMb: Double
    public let fileUrl: String?
    public let uploadedAt: String?
    
    public init(id: String, fileName: String, fileType: String?, pageCount: Int, fileSizeMb: Double, fileUrl: String?, uploadedAt: String?) {
        self.id = id
        self.fileName = fileName
        self.fileType = fileType
        self.pageCount = pageCount
        self.fileSizeMb = fileSizeMb
        self.fileUrl = fileUrl
        self.uploadedAt = uploadedAt
    }
    
    public var computedFileUrl: String {
        let baseUrl = "https://api-gateway-production-5110.up.railway.app"
        if let url = fileUrl, !url.isEmpty {
            if url.starts(with: "http") { return url }
            return baseUrl + url
        }
        return baseUrl + "/api/v1/organization/materials/\(id)/file"
    }
}
