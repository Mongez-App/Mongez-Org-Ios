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
    @Published public var organizationName: String = ""
    @Published public var photoUrl: String?
    @Published public var appearanceMode: AppearanceMode = .system
    @Published public var language: AppLanguage = .english
    @Published public var showLogoutConfirmation: Bool = false

    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String?
    @Published public var isEditProfilePresented: Bool = false
    @Published public var isSavingProfile: Bool = false

    private let getProfileUseCase: GetProfileUseCase
    private let updateProfileUseCase: UpdateProfileUseCase
    private let uploadProfilePhotoUseCase: UploadProfilePhotoUseCase

    nonisolated public init(
        getProfileUseCase: GetProfileUseCase,
        updateProfileUseCase: UpdateProfileUseCase,
        uploadProfilePhotoUseCase: UploadProfilePhotoUseCase
    ) {
        self.getProfileUseCase = getProfileUseCase
        self.updateProfileUseCase = updateProfileUseCase
        self.uploadProfilePhotoUseCase = uploadProfilePhotoUseCase
    }

    public var initials: String {
        let words = organizationName.split(separator: " ")
        if words.count >= 2 {
            return String(words[0].prefix(1) + words[1].prefix(1)).uppercased()
        } else if let first = words.first {
            return String(first.prefix(2)).uppercased()
        }
        return "OR"
    }

    public func loadProfile() async {
        isLoading = true
        errorMessage = nil
        do {
            let profile = try await getProfileUseCase.execute()
            organizationName = profile.name
            photoUrl = profile.photoUrl
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to load organization profile: \(error)")
        }
        isLoading = false
    }

    public func openEditProfile() {
        isEditProfilePresented = true
    }

    public func cancelEditProfile() {
        isEditProfilePresented = false
    }

    public func saveEditProfile(name: String, photoData: Data?) async {
        isEditProfilePresented = false
        isSavingProfile = true
        errorMessage = nil
        do {
            var newPhotoUrl = photoUrl
            if let photoData {
                newPhotoUrl = try await uploadProfilePhotoUseCase.execute(fileData: photoData, fileName: "organization_photo.jpg")
            }
            let updated = try await updateProfileUseCase.execute(name: name, photoUrl: newPhotoUrl)
            organizationName = updated.name
            photoUrl = updated.photoUrl
        } catch {
            errorMessage = error.localizedDescription
            print("Failed to save organization profile: \(error)")
        }
        isSavingProfile = false
    }

    public func confirmLogout() {
        UserDefaults.standard.removeObject(forKey: "current_user_id")
        UserDefaults.standard.removeObject(forKey: "main_token")
        showLogoutConfirmation = false
        NotificationCenter.default.post(name: NSNotification.Name("UserDidLogoutNotification"), object: nil)
    }
}
