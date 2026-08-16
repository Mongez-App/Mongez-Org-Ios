//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct MaterialRowView: View {
    public let material: TeamCourseMaterial
    public var onDelete: (() -> Void)?
    
    @State private var isPreviewPresented = false
    
    public init(material: TeamCourseMaterial, onDelete: (() -> Void)? = nil) {
        self.material = material
        self.onDelete = onDelete
    }
    
    public var body: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Button(action: {
                if !material.computedFileUrl.isEmpty {
                    isPreviewPresented = true
                }
            }) {
                HStack(spacing: AppTheme.Spacing.small) {
                    Text("PDF")
                        .font(AppTheme.textStyle(size: 14, weight: .bold))
                        .foregroundColor(AppTheme.Colors.white100)
                        .frame(width: 48, height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                .fill(AppTheme.Colors.red100)
                        )
                    
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xxxSmall) {
                        Text(material.fileName)
                            .font(AppTheme.textStyle(size: 16, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.black100)
                            .lineLimit(1)
                        
                        Text("\(material.pageCount) Pages • \(String(format: "%.1f", material.fileSizeMb)) MB")
                            .font(AppTheme.textStyle(size: 14))
                            .foregroundColor(AppTheme.Colors.gray300)
                    }
                    Spacer(minLength: AppTheme.Spacing.small)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            
        }
        .padding(AppTheme.Spacing.small)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                .fill(AppTheme.Colors.white100)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.radius.meduim)
                        .stroke(AppTheme.Colors.gray100, lineWidth: 1.5)
                )
        )
        .fullScreenCover(isPresented: $isPreviewPresented) {
            if let url = URL(string: material.computedFileUrl) {
                NavigationView {
                    let token = UserDefaults.standard.string(forKey: "main_token") ?? ""
                    let headers = ["Authorization": "Bearer \(token)"]
                    WebView(url: url, headers: headers)
                        .navigationTitle(material.fileName)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button("Done") {
                                    isPreviewPresented = false
                                }
                            }
                        }
                }
            }
        }
    }
}
