//
//  File.swift
//  
//
//  Created by Mazen Amr on 15/08/2026.
//

import Foundation
import SwiftUI
import Common

public struct TeamCourseCardView: View {
    let course: TeamCourse
    
    public init(course: TeamCourse) {
        self.course = course
    }
    
    public var body: some View {
        HStack(spacing: AppTheme.Spacing.medium) {
            Group {
                if let thumbnailUrl = course.thumbnailUrl, 
                   thumbnailUrl != "mock-url", 
                   let url = URL(string: thumbnailUrl.trimmingCharacters(in: .whitespacesAndNewlines)) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                        case .failure:
                            Text(course.initials)
                                .font(AppTheme.textStyle(size: 34, weight: .bold))
                                .foregroundColor(AppTheme.Colors.purple200)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Text(course.initials)
                        .font(AppTheme.textStyle(size: 34, weight: .bold))
                        .foregroundColor(AppTheme.Colors.purple200)
                }
            }
            .frame(width: 110, height: 110)
            .background(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.15))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            VStack(alignment: .leading, spacing: 0) {
                Text(course.title)
                    .font(AppTheme.textStyle(size: 20, weight: .bold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
    
                Spacer(minLength: 16)
                
                VStack(spacing: AppTheme.Spacing.xxxSmall) {
                    HStack {
                        Text("Progress")
                            .font(AppTheme.textStyle(size: 14))
                            .foregroundColor(AppTheme.Colors.gray300)
                        Spacer()
                        Text("\(Int(course.progress * 100))%")
                            .font(AppTheme.textStyle(size: 14, weight: .bold))
                            .foregroundColor(AppTheme.Colors.purple200)
                    }
                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(AppTheme.Colors.gray100)
                                .frame(height: 8)
                            
                            Capsule()
                                .fill(AppTheme.Colors.purple200)
                                .frame(width: geo.size.width * course.progress, height: 8)
                        }
                    }
                    .frame(height: 8)
                }
            }
            .frame(height: 110)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(AppTheme.Colors.white100)
                .appShadow(opacity: 0.5, radius: 7.5)
        )
    }
}
