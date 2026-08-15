//
//  File.swift
//
//
//  Created by Ahmed Tarek on 21/07/2026.
//

import Foundation

public enum AppTab: Int, CaseIterable {
    case dashboard
    case teams
    case profile
    
    public var iconName: String {
        switch self {
        case .dashboard:
            return "home"
        case .teams:
            return "roadmap"
        case .profile:
            return "profile"
        }
    }
}
