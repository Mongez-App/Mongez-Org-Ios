//
//  File.swift
//  
//
//  Created by Mazen Amr on 20/07/2026.
//

import Foundation
import SwiftUI
import Common

public struct CourseMaterialsView: View {
    public let materials: [TeamCourseMaterial]
    public let courseType: String
    public let isLoading: Bool
    public let onUploadAction: () -> Void
    public var onDeleteMaterial: ((String) -> Void)?
    
    public init(materials: [TeamCourseMaterial], courseType: String, isLoading: Bool = false, onUploadAction: @escaping () -> Void = {}, onDeleteMaterial: ((String) -> Void)? = nil) {
        self.materials = materials 
        self.courseType = courseType
        self.isLoading = isLoading
        self.onUploadAction = onUploadAction
        self.onDeleteMaterial = onDeleteMaterial
    }
    
    public var body: some View {
        VStack {
            if courseType == "URL_COURSE" {
                if !isLoading {
                    VStack(spacing: AppTheme.Spacing.small) {
                        Spacer()
                        
                        Image(systemName: "globe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(AppTheme.Colors.gray300)
                            .padding(.bottom, AppTheme.Spacing.small)
                        
                        Text("Study materials for online courses are managed externally.")
                            .font(AppTheme.textStyle(size: 16, weight: .medium))
                            .foregroundColor(AppTheme.Colors.gray300)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, AppTheme.Spacing.large)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    Spacer()
                }
                
            } else if materials.isEmpty {
                if !isLoading {
                    VStack(spacing: AppTheme.Spacing.medium) {
                        Spacer()
                        
                        Circle()
                            .fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.15))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Image(systemName: "doc.text.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 48)
                                    .foregroundColor(AppTheme.Colors.purple200)
                            )
                        
                        VStack(spacing: AppTheme.Spacing.xxSmall) {
                            Text("No Materials Yet")
                                .font(AppTheme.textStyle(size: 20, weight: .bold))
                                .foregroundColor(AppTheme.Colors.black100)
                            
                            Text("You haven't uploaded any materials yet for this\ncourse")
                                .font(AppTheme.textStyle(size: 14))
                                .foregroundColor(AppTheme.Colors.gray300)
                                .multilineTextAlignment(.center)
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                } else {
                    Spacer()
                }
                
                UploadMaterialButtonView(action: onUploadAction)
                    .padding(AppTheme.Spacing.small)
                
            } else {
                ScrollView {
                    LazyVStack(spacing: AppTheme.Spacing.small) {
                        ForEach(materials) { material in
                            MaterialRowView(material: material) {
                                onDeleteMaterial?(material.id)
                            }
                        }
                    }
                    .padding(AppTheme.Spacing.small)
                    .padding(.top, AppTheme.Spacing.xSmall)
                }
                
                UploadMaterialButtonView(action: onUploadAction)
                    .padding(AppTheme.Spacing.small)
            }
        }
    }
}
