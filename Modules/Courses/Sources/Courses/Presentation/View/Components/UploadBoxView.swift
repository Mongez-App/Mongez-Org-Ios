//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common

public struct UploadBoxView: View {
    public let title: String
    public let subtitle: String
    public let icon: String
    public let iconColor: Color
    
    public init(title: String, subtitle: String, icon: String, iconColor: Color) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
    }
    
    public var body: some View {
        VStack(spacing: AppTheme.Spacing.xxSmall) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(iconColor)
                .padding(.bottom, AppTheme.Spacing.xxxSmall)
            
            Text(title)
                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
            
            Text(subtitle)
                .font(AppTheme.textStyle(size: 12))
                .foregroundColor(AppTheme.Colors.gray300)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.Spacing.large)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [6]))
                .foregroundColor(AppTheme.Colors.gray200)
                .background(AppTheme.Colors.white100)
        )
    }
}
