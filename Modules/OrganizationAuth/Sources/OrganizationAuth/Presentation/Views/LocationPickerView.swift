import SwiftUI
import MapKit
import Common

public struct LocationPickerView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var region: MKCoordinateRegion

    private let userLocation: CLLocationCoordinate2D?
    private let onConfirm: (CLLocationCoordinate2D) -> Void

    public init(
        initialRegion: MKCoordinateRegion,
        userLocation: CLLocationCoordinate2D?,
        onConfirm: @escaping (CLLocationCoordinate2D) -> Void
    ) {
        _region = State(initialValue: initialRegion)
        self.userLocation = userLocation
        self.onConfirm = onConfirm
    }

    public var body: some View {
        ZStack {
            AppTheme.Colors.white100.ignoresSafeArea()

            VStack(spacing: 0) {
                topBar

                ZStack {
                    Map(coordinateRegion: $region)
                        .ignoresSafeArea(edges: .horizontal)

                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.Colors.red100)
                        .shadow(color: AppTheme.Colors.black100.opacity(0.3), radius: 4, y: 2)
                        .allowsHitTesting(false)
                }
                .overlay(alignment: .bottomLeading) {
                    if let userLocation {
                        currentLocationButton(userLocation)
                    }
                }

                confirmBar
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(AppTheme.Colors.black100)
                    .frame(width: 40, height: 40)
                    .background(Circle().fill(AppTheme.Colors.gray100))
            }

            Spacer()

            Text("Select Location")
                .font(AppTheme.textStyle(size: 17, weight: .bold))
                .foregroundColor(AppTheme.Colors.black100)

            Spacer()

            Color.clear
                .frame(width: 40, height: 40)
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.vertical, AppTheme.Spacing.xSmall)
        .background(AppTheme.Colors.white100)
    }

    private func currentLocationButton(_ location: CLLocationCoordinate2D) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                region = MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
            }
        } label: {
            HStack(spacing: AppTheme.Spacing.xxSmall) {
                Image(systemName: "location.fill")
                    .font(.system(size: 14, weight: .semibold))

                Text("Current Location")
                    .font(AppTheme.textStyle(size: 14, weight: .semibold))
            }
            .foregroundColor(AppTheme.Colors.white100)
            .padding(.horizontal, AppTheme.Spacing.small)
            .padding(.vertical, 10)
            .background(Capsule().fill(AppTheme.Colors.purple200))
            .shadow(color: AppTheme.Colors.black100.opacity(0.15), radius: 4, y: 2)
        }
        .padding(.leading, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.medium)
    }

    private var confirmBar: some View {
        VStack(spacing: AppTheme.Spacing.xxSmall) {
            Button {
                onConfirm(region.center)
                dismiss()
            } label: {
                Text("Confirm Location")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppTheme.Colors.purple200)
                    .foregroundColor(AppTheme.Colors.white100)
                    .cornerRadius(AppTheme.radius.meduim)
            }
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.top, AppTheme.Spacing.small)
        .padding(.bottom, AppTheme.Spacing.large)
        .background(AppTheme.Colors.white100)
    }
}

struct LocationPickerView_Previews: PreviewProvider {
    static var previews: some View {
    LocationPickerView(
        initialRegion: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 30.0444, longitude: 31.2357),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ),
        userLocation: nil
    ) { _ in }
}
}
