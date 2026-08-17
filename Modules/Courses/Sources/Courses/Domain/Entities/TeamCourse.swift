//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation

public struct TeamCourse: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let progress: Double
    public let thumbnailUrl: String?
    
    public var initials: String {
        let words = title.split(separator: " ")
        if words.count >= 2 {
            return String(words[0].prefix(1) + words[1].prefix(1)).uppercased()
        } else if let first = words.first {
            return String(first.prefix(2)).uppercased()
        }
        return "TC"
    }
    
    public init(id: String, title: String, progress: Double, thumbnailUrl: String? = nil) {
        self.id = id
        self.title = title
        self.progress = progress
        self.thumbnailUrl = thumbnailUrl
    }
}
