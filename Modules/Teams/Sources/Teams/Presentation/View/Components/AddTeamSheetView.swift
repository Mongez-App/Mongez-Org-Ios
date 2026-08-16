import SwiftUI
import Common
import PhotosUI

public struct AddTeamSheetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TeamsViewModel
    
    @State private var teamName = ""
    @State private var inviteCode = ""
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    // Callback to trigger success alert in parent
    var onSuccess: () -> Void
    
    public init(viewModel: TeamsViewModel, onSuccess: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onSuccess = onSuccess
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(AppTheme.Colors.gray200)
                .frame(width: 40, height: 4)
                .padding(.top, AppTheme.Spacing.small)
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: AppTheme.Spacing.large) {
                    
                    // Photo Picker Area
                    PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                        VStack(spacing: AppTheme.Spacing.xxSmall) {
                            ZStack(alignment: .bottomTrailing) {
                                if let selectedImage = selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .strokeBorder(AppTheme.Colors.purple200.opacity(0.85), lineWidth: 1)
                                        .background(Circle().fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.05)))
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Image(systemName: "photo")
                                                .font(.system(size: 24))
                                                .foregroundColor(AppTheme.Colors.gray300)
                                        )
                                }
                                
                                Circle()
                                    .fill(AppTheme.Colors.purple200)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Image(systemName: "plus")
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(AppTheme.Colors.white100)
                                    )
                                    .offset(x: 4, y: 4)
                            }
                            
                            Text("Add Photo")
                                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.purple200)
                            
                            Text("Choose a photo for your New Team")
                                .font(AppTheme.textStyle(size: 12))
                                .foregroundColor(AppTheme.Colors.gray300)
                        }
                    }
                    .padding(.top, AppTheme.Spacing.large)
                    
                    // Text Fields
                    VStack(spacing: AppTheme.Spacing.small) {
                        TextField("Enter Your New Team Name Here", text: $teamName)
                            .font(AppTheme.textStyle(size: 14))
                            .padding(.horizontal, AppTheme.Spacing.medium)
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                            )
                        
                        TextField("Enter Your Team's Invite Code", text: $inviteCode)
                            .font(AppTheme.textStyle(size: 14))
                            .padding(.horizontal, AppTheme.Spacing.medium)
                            .frame(height: 48)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, AppTheme.Spacing.xLarge)
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .font(AppTheme.textStyle(size: 12))
                            .foregroundColor(AppTheme.Colors.red100)
                            .padding(.horizontal, AppTheme.Spacing.small)
                    }
                    
                    // Submit Button
                    Button(action: {
                        Task {
                            // Dummy logic for uploading photo and getting URL could go here.
                            // Passing empty or mock URL for now as requested.
                            let photoUrl = selectedImage != nil ? "https://example.com/photo.png" : ""
                            
                            let success = await viewModel.createTeam(
                                name: teamName,
                                photoUrl: photoUrl,
                                inviteCode: inviteCode
                            )
                            
                            if success {
                                dismiss()
                                onSuccess()
                            }
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.white100))
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(RoundedRectangle(cornerRadius: AppTheme.radius.small).fill(AppTheme.Colors.purple200.opacity(0.5)))
                        } else {
                            Text("Add Team")
                                .font(AppTheme.textStyle(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.white100)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(RoundedRectangle(cornerRadius: AppTheme.radius.small).fill(AppTheme.Colors.purple200))
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.xLarge)
                    .padding(.top, AppTheme.Spacing.small)
                    .disabled(teamName.isEmpty || inviteCode.isEmpty || viewModel.isLoading)
                }
            }
        }
        .background(AppTheme.Colors.white100.ignoresSafeArea())
        .onChange(of: selectedPhotoItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        self.selectedImage = uiImage
                    }
                }
            }
        }
    }
}
