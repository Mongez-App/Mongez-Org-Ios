//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common
import PhotosUI
import UniformTypeIdentifiers

public struct AddCourseSheetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TeamCoursesViewModel
    
    @State private var courseName = ""
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(86400 * 30) // Default 30 days
    
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    @State private var showFileImporter = false
    @State private var selectedFileURL: URL?
    
    public init(viewModel: TeamCoursesViewModel) {
        self.viewModel = viewModel
    }
    
    private var initials: String {
        let words = courseName.split(separator: " ")
        if words.count >= 2 {
            return String(words[0].prefix(1) + words[1].prefix(1)).uppercased()
        } else if let first = words.first {
            return String(first.prefix(2)).uppercased()
        }
        return "TC"
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(AppTheme.Colors.gray200)
                .frame(width: 40, height: 4)
                .padding(.top, AppTheme.Spacing.small)
            
            Text("Add New Course")
                .font(AppTheme.textStyle(size: 18, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)
                .padding(.vertical, AppTheme.Spacing.medium)
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                    InputFieldView(title: "Course Name", placeholder: "e.g. Operating Systems", text: $courseName)
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                        Text("Start Date")
                            .font(AppTheme.textStyle(size: 14, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.black100)
                        
                        DatePicker("", selection: $startDate, displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(.compact)
                            .padding(.horizontal, AppTheme.Spacing.small)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                            )
                            .overlay(
                                Image(systemName: "calendar")
                                    .foregroundColor(AppTheme.Colors.purple200)
                                    .padding(.trailing, AppTheme.Spacing.small)
                                , alignment: .trailing
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                        Text("End Date")
                            .font(AppTheme.textStyle(size: 14, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.black100)
                        
                        DatePicker("", selection: $endDate, displayedComponents: .date)
                            .labelsHidden()
                            .datePickerStyle(.compact)
                            .padding(.horizontal, AppTheme.Spacing.small)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                            )
                            .overlay(
                                Image(systemName: "calendar")
                                    .foregroundColor(AppTheme.Colors.purple200)
                                    .padding(.trailing, AppTheme.Spacing.small)
                                , alignment: .trailing
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                        Text("Thumbnail")
                            .font(AppTheme.textStyle(size: 14, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.black100)
                        
                        HStack(spacing: AppTheme.Spacing.small) {
                            if let selectedImage = selectedImage {
                                Image(uiImage: selectedImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.small))
                            } else {
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.15))
                                    .frame(width: 80, height: 80)
                                    .overlay(
                                        Text(initials)
                                            .font(AppTheme.textStyle(size: 24, weight: .bold))
                                            .foregroundColor(AppTheme.Colors.purple200)
                                    )
                            }
                            
                            PhotosPicker(selection: $selectedPhotoItem, matching: .images, photoLibrary: .shared()) {
                                UploadBoxView(title: "Upload cover image", subtitle: "PNG or JPG, up to 5 MB", icon: "photo", iconColor: AppTheme.Colors.orange100)
                            }
                        }
                    }
                    .onChange(of: selectedPhotoItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    self.selectedImage = uiImage
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
                        Text("Course Material ")
                            .font(AppTheme.textStyle(size: 14, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.black100)
                        + Text("(PDFs, slides, notes)")
                            .font(AppTheme.textStyle(size: 12))
                            .foregroundColor(AppTheme.Colors.gray300)
                        
                        Button(action: { showFileImporter = true }) {
                            UploadBoxView(title: "Upload material", subtitle: "Tap to browse files", icon: "plus", iconColor: AppTheme.Colors.purple200)
                        }
                        
                        if let selectedFileURL = selectedFileURL {
                            HStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(AppTheme.Colors.red100)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Text("PDF").font(AppTheme.textStyle(size: 12, weight: .bold)).foregroundColor(AppTheme.Colors.white100)
                                    )
                                
                                VStack(alignment: .leading) {
                                    Text(selectedFileURL.lastPathComponent)
                                        .font(AppTheme.textStyle(size: 14, weight: .semibold))
                                        .lineLimit(1)
                                        .foregroundColor(AppTheme.Colors.black100)
                                }
                                
                                Spacer()
                                Button(action: { self.selectedFileURL = nil }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(AppTheme.Colors.gray300)
                                }
                            }
                            .padding(AppTheme.Spacing.small)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .fill(AppTheme.Colors.white100)
                                    .appShadow(opacity: 0.05, radius: 5)
                            )
                        }
                    }
                }
                .padding(AppTheme.Spacing.small)
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .font(AppTheme.textStyle(size: 12))
                    .foregroundColor(AppTheme.Colors.red100)
                    .padding(.horizontal, AppTheme.Spacing.small)
            }
            
            Button(action: {
                Task {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let success = await viewModel.createCourse(
                        name: courseName,
                        startDate: formatter.string(from: startDate),
                        endDate: formatter.string(from: endDate),
                        thumbnail: selectedImage,
                        materialUrl: selectedFileURL
                    )
                    
                    if success {
                        dismiss()
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
                    Text("Add course")
                        .font(AppTheme.textStyle(size: 16, weight: .semibold))
                        .foregroundColor(AppTheme.Colors.white100)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(RoundedRectangle(cornerRadius: AppTheme.radius.small).fill(AppTheme.Colors.purple200))
                }
            }
            .padding(AppTheme.Spacing.small)
            .disabled(courseName.isEmpty || viewModel.isLoading)
            .background(AppTheme.Colors.white100.ignoresSafeArea())
        }
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.pdf]) { result in
            switch result {
            case .success(let url):
                // Ensure we have access to the file URL
                let gotAccess = url.startAccessingSecurityScopedResource()
                if !gotAccess { return }
                self.selectedFileURL = url
            case .failure:
                break
            }
        }
    }
}
