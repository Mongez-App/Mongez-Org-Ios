//
//  File.swift
//
//
//  Created by Mazen Amr on 16/08/2026.
//

import Foundation
import SwiftUI
import Common

public struct ProfileView: View {
    @StateObject private var viewModel: ProfileViewModel

    public init(viewModel: ProfileViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack(spacing: AppTheme.Spacing.small) {
                    ZStack(alignment: .bottomTrailing) {
                        Group {
                            if let photoUrl = viewModel.photoUrl, !photoUrl.isEmpty, let url = URL(string: photoUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    default:
                                        avatarPlaceholder
                                    }
                                }
                            } else {
                                avatarPlaceholder
                            }
                        }

                        Button {
                            viewModel.openEditProfile()
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(AppTheme.Colors.purple200)
                                    .frame(width: 28, height: 28)

                                Image(systemName: "pencil")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .offset(x: 2, y: 2)
                    }

                    Text(viewModel.organizationName)
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                }
                .padding(.top, AppTheme.Spacing.xLarge)
                .padding(.bottom, AppTheme.Spacing.xLarge)

                VStack(spacing: 0) {
                    settingsRow(icon: "moon.stars.fill", iconColor: AppTheme.Colors.purple200, title: "Preferences") {
                        Menu {
                            ForEach(AppearanceMode.allCases) { mode in
                                Button(mode.rawValue) { viewModel.appearanceMode = mode }
                            }
                        } label: {
                            dropdownPill(text: viewModel.appearanceMode.rawValue)
                        }
                    }

                    divider

                    settingsRow(icon: "globe", iconColor: AppTheme.Colors.purple200, title: "Language") {
                        Menu {
                            ForEach(AppLanguage.allCases) { lang in
                                Button(lang.rawValue) { viewModel.language = lang }
                            }
                        } label: {
                            dropdownPill(text: viewModel.language.rawValue)
                        }
                    }

                    divider

                    Button(action: { viewModel.showLogoutConfirmation = true }) {
                        HStack(spacing: AppTheme.Spacing.small) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.red100, opacity: 0.12))
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .font(.system(size: 16))
                                        .foregroundColor(AppTheme.Colors.red100)
                                )

                            Text("Logout")
                                .font(AppTheme.textStyle(size: 15, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.red100)

                            Spacer()
                        }
                        .padding(.vertical, AppTheme.Spacing.small)
                    }

                    divider
                }
                .padding(.horizontal, AppTheme.Spacing.medium)

                Spacer()
            }

            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.purple200))
            }

            if viewModel.showLogoutConfirmation {
                LogoutConfirmationView(
                    onLogout: { viewModel.confirmLogout() },
                    onCancel: { viewModel.showLogoutConfirmation = false }
                )
            }
        }
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .onAppear {
            Task {
                await viewModel.loadProfile()
            }
        }
        .sheet(isPresented: $viewModel.isEditProfilePresented) {
            EditOrganizationProfileSheet(
                currentName: viewModel.organizationName,
                currentPhotoUrl: viewModel.photoUrl,
                isSaving: viewModel.isSavingProfile,
                onSave: { name, photoData in
                    Task {
                        await viewModel.saveEditProfile(name: name, photoData: photoData)
                    }
                },
                onCancel: {
                    viewModel.cancelEditProfile()
                }
            )
        }
    }

    private var avatarPlaceholder: some View {
        Circle()
            .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.15))
            .frame(width: 100, height: 100)
            .overlay(
                Circle()
                    .stroke(AppTheme.Colors.purple200.opacity(0.4), lineWidth: 1.5)
            )
            .overlay(
                Text(viewModel.initials)
                    .font(AppTheme.textStyle(size: 22, weight: .bold))
                    .foregroundColor(AppTheme.Colors.purple200)
            )
    }

    private var divider: some View {
        Rectangle()
            .fill(AppTheme.Colors.gray200)
            .frame(height: 1)
    }

    private func dropdownPill(text: String) -> some View {
        HStack(spacing: 4) {
            Text(text)
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
            Image(systemName: "chevron.down")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(AppTheme.Colors.gray300)
        }
        .padding(.horizontal, AppTheme.Spacing.xSmall)
        .padding(.vertical, AppTheme.Spacing.xxxSmall)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(AppTheme.Colors.gray200, lineWidth: 1)
        )
    }

    @ViewBuilder
    private func settingsRow<Trailing: View>(
        icon: String,
        iconColor: Color,
        title: String,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        HStack(spacing: AppTheme.Spacing.small) {
            RoundedRectangle(cornerRadius: 10)
                .fill(AppTheme.Colors.changeOpacity(color: iconColor, opacity: 0.12))
                .frame(width: 36, height: 36)
                .overlay(
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(iconColor)
                )

            Text(title)
                .font(AppTheme.textStyle(size: 15, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)

            Spacer()

            trailing()
        }
        .padding(.vertical, AppTheme.Spacing.small)
    }
}
