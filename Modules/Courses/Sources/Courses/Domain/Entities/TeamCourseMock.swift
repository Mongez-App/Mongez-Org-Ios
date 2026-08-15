//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation

public struct TeamCourseMock: Identifiable {
    public let id = UUID()
    public let title: String
    public let initials: String
    public let progress: Double
    
    public init(title: String, initials: String, progress: Double) {
        self.title = title
        self.initials = initials
        self.progress = progress
    }
}
