//
//  File.swift
//
//
//  Created by Mazen Amr on 16/08/2026.
//

import SwiftUI
import PhotosUI
import Common

public struct EditOrganizationProfileSheet: View {
    @Environment(\.dismiss) private var dismiss

    let currentName: String
    let currentPhotoUrl: String?
    let isSaving: Bool
    let onSave: (String, Data?) -> Void
    let onCancel: () -> Void

    @State private var nameText: String
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedPhotoData: Data?

    public init(
        currentName: String,
        currentPhotoUrl: String?,
        isSaving: Bool,
        onSave: @escaping (String, Data?) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.currentName = currentName
        self.currentPhotoUrl = currentPhotoUrl
        self.isSaving = isSaving
        self.onSave = onSave
        self.onCancel = onCancel
        _nameText = State(initialValue: currentName)
    }

    public var body: some View {
        VStack(spacing: AppTheme.Spacing.large) {
            Capsule()
                .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.15))
                .frame(width: 48, height: 5)
                .padding(.top, AppTheme.Spacing.small)

            Text("Edit Organization Profile")
                .font(AppTheme.textStyle(size: 20, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            photoSection

            nameSection

            Spacer(minLength: 0)

            actionButtons
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.large)
        .background(AppTheme.Colors.white100)
        .clipShape(RoundedRectangle(cornerRadius: 36, style: .continuous))
        .presentationDetents([.height(460), .large])
        .presentationDragIndicator(.hidden)
        .onChange(of: selectedPhotoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    selectedPhotoData = data
                }
            }
        }
    }

    private var photoSection: some View {
        PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if let selectedPhotoData, let uiImage = UIImage(data: selectedPhotoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 96, height: 96)
                            .clipShape(Circle())
                    } else if let currentPhotoUrl, !currentPhotoUrl.isEmpty, let url = URL(string: currentPhotoUrl) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 96, height: 96)
                                    .clipShape(Circle())
                            default:
                                initialsCircle
                            }
                        }
                    } else {
                        initialsCircle
                    }
                }

                ZStack {
                    Circle()
                        .fill(AppTheme.Colors.purple200)
                        .frame(width: 30, height: 30)

                    Image(systemName: "camera.fill")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.white)
                }
                .offset(x: 2, y: 2)
            }
        }
        .buttonStyle(.plain)
    }

    private var initialsCircle: some View {
        ZStack {
            Circle()
                .fill(AppTheme.Colors.purple200.opacity(0.15))
                .frame(width: 96, height: 96)

            Text(currentName.prefix(2).uppercased())
                .font(AppTheme.textStyle(size: 96 * 0.28, weight: .medium))
                .foregroundColor(AppTheme.Colors.purple200.opacity(0.8))
        }
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text("Organization Name")
                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.black100, opacity: 0.6))

            TextField("Enter organization name", text: $nameText)
                .font(AppTheme.textStyle(size: 16, weight: .regular))
                .foregroundColor(AppTheme.Colors.black100)
                .padding(.horizontal, AppTheme.Spacing.medium)
                .padding(.vertical, AppTheme.Spacing.small)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray200, opacity: 0.12))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.25), lineWidth: 1)
                )
        }
    }

    private var actionButtons: some View {
        HStack(spacing: AppTheme.Spacing.medium) {
            Button {
                onCancel()
                dismiss()
            } label: {
                Text("Cancel")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.medium)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.gray200, opacity: 0.2))
                    )
            }
            .disabled(isSaving)

            Button {
                onSave(nameText.trimmingCharacters(in: .whitespaces), selectedPhotoData)
                dismiss()
            } label: {
                if isSaving {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.medium)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppTheme.Colors.purple200)
                        )
                } else {
                    Text("Save")
                        .font(AppTheme.textStyle(size: 16, weight: .bold))
                        .foregroundColor(AppTheme.Colors.white100)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.medium)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppTheme.Colors.purple200)
                        )
                }
            }
            .disabled(nameText.trimmingCharacters(in: .whitespaces).isEmpty || isSaving)
            .opacity(nameText.trimmingCharacters(in: .whitespaces).isEmpty ? 0.5 : 1)
        }
    }
}
