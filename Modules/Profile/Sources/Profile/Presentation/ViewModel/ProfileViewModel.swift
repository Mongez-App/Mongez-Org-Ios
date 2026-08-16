//
//  File.swift
//
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
import SwiftUI

public enum AppearanceMode: String, CaseIterable, Identifiable {
    case system = "System"
    case light = "Light"
    case dark = "Dark"

    public var id: String { rawValue }
}

public enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "EN"
    case arabic = "AR"

    public var id: String { rawValue }
}

@MainActor
public class ProfileViewModel: ObservableObject {
    @Published public var organizationName: String = "Organization Name"
    @Published public var organizationEmail: String = "myorganization@gmail.com"
    @Published public var appearanceMode: AppearanceMode = .system
    @Published public var language: AppLanguage = .english
    @Published public var showLogoutConfirmation: Bool = false

    public init() {}

    public var initials: String {
        let words = organizationName.split(separator: " ")
        if words.count >= 2 {
            return String(words[0].prefix(1) + words[1].prefix(1)).uppercased()
        } else if let first = words.first {
            return String(first.prefix(2)).uppercased()
        }
        return "OR"
    }

    public func confirmLogout() {
        UserDefaults.standard.removeObject(forKey: "current_user_id")
        UserDefaults.standard.removeObject(forKey: "main_token")
        showLogoutConfirmation = false
        NotificationCenter.default.post(name: NSNotification.Name("UserDidLogoutNotification"), object: nil)
    }
}
