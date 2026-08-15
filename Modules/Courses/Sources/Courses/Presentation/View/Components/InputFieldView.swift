//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common

public struct InputFieldView: View {
    public let title: String
    public let placeholder: String
    @Binding public var text: String
    public let icon: String?
    
    public init(title: String, placeholder: String, text: Binding<String>, icon: String? = nil) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.icon = icon
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text(title)
                .font(AppTheme.textStyle(size: 14, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)
            
            HStack {
                TextField(placeholder, text: $text)
                    .font(AppTheme.textStyle(size: 14))
                
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(AppTheme.Colors.purple200)
                }
            }
            .padding(AppTheme.Spacing.small)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                    .stroke(AppTheme.Colors.gray200, lineWidth: 1)
            )
        }
    }
}
