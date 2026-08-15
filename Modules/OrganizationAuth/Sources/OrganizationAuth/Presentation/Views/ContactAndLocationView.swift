import SwiftUI
import MapKit
import Common

public struct ContactAndLocationView: View {
    @ObservedObject var viewModel: AuthViewModel
    @StateObject private var locationManager = LocationManager()
    @State private var isShowingPicker = false

    public init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.medium) {
                    StepProgressIndicator(
                        currentStep: viewModel.currentStep,
                        totalSteps: viewModel.totalSteps
                    )
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.small)

                    Text("Contact & Location")
                        .font(AppTheme.textStyle(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)

                    CustomTextField(
                        title: "Contact Email",
                        placeholder: "Enter contact email",
                        text: $viewModel.contactEmail,
                        icon: "envelope",
                        keyboardType: .emailAddress,
                        textContentType: .emailAddress,
                        autocapitalization: .never
                    )

                    CustomTextField(
                        title: "Phone Number",
                        placeholder: "Enter phone number",
                        text: $viewModel.phone,
                        icon: "phone",
                        keyboardType: .phonePad,
                        textContentType: .telephoneNumber
                    )

                    CustomTextField(
                        title: "Website URL (Optional)",
                        placeholder: "Enter website URL",
                        text: $viewModel.website,
                        icon: "globe",
                        keyboardType: .URL,
                        textContentType: .URL,
                        autocapitalization: .never
                    )

                    CustomTextField(
                        title: "Address",
                        placeholder: "Enter full address",
                        text: $viewModel.address,
                        icon: "mappin.and.ellipse"
                    )

                    locationMap

                    CustomTextField(
                        title: "Registration Number (Optional)",
                        placeholder: "Enter registration number",
                        text: $viewModel.registrationNumber,
                        icon: "doc.text"
                    )

                    documentsField

                    if let error = viewModel.errorMessage {
                        errorBanner(error)
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.large)
                .padding(.bottom, AppTheme.Spacing.large)
            }

            bottomButtons
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        .onReceive(locationManager.$userLocation) { location in
            guard let location, viewModel.selectedCoordinate == nil else { return }

            withAnimation(.easeInOut(duration: 0.3)) {
                viewModel.mapRegion = MKCoordinateRegion(
                    center: location,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                )
                viewModel.selectedCoordinate = location
            }
        }
        .onReceive(locationManager.$errorMessage) { _ in }
        .fullScreenCover(isPresented: $isShowingPicker) {
            LocationPickerView(
                initialRegion: viewModel.mapRegion,
                userLocation: locationManager.userLocation
            ) { coordinate in
                viewModel.selectedCoordinate = coordinate
                viewModel.mapRegion = MKCoordinateRegion(
                    center: coordinate,
                    span: viewModel.mapRegion.span
                )
            }
        }
    }

    private var locationMap: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text("Select Location")
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)

            ZStack {
                if let coordinate = viewModel.selectedCoordinate {
                    Map(
                        coordinateRegion: mapRegionBinding,
                        annotationItems: [MapLocation(coordinate: coordinate)]
                    ) { location in
                        MapMarker(coordinate: location.coordinate, tint: AppTheme.Colors.red100)
                    }
                } else {
                    Map(coordinateRegion: mapRegionBinding)

                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(AppTheme.Colors.red100)
                        .allowsHitTesting(false)
                }
            }
            .frame(height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(alignment: .bottom) {
                HStack(spacing: AppTheme.Spacing.xxSmall) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.system(size: 11, weight: .semibold))

                    Text("Tap to open map")
                        .font(AppTheme.textStyle(size: 12, weight: .semibold))
                }
                .foregroundColor(AppTheme.Colors.white100)
                .padding(.horizontal, AppTheme.Spacing.xSmall)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(AppTheme.Colors.black100.opacity(0.6))
                )
                .padding(.bottom, AppTheme.Spacing.xSmall)
                .allowsHitTesting(false)
            }
            .contentShape(RoundedRectangle(cornerRadius: 15))
            .onTapGesture {
                isShowingPicker = true
            }
        }
    }

    private struct MapLocation: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

    private var mapRegionBinding: Binding<MKCoordinateRegion> {
        Binding(
            get: { viewModel.mapRegion },
            set: { newRegion in
                viewModel.mapRegion = newRegion
                viewModel.selectedCoordinate = newRegion.center
            }
        )
    }

    private var documentsField: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xxSmall) {
            Text("Documents (Optional)")
                .font(AppTheme.textStyle(size: 13, weight: .semibold))
                .foregroundColor(AppTheme.Colors.black100)

            ForEach(Array(viewModel.documentURLs.enumerated()), id: \.offset) { index, url in
                HStack {
                    Text(url)
                        .font(AppTheme.textStyle(size: 15))
                        .foregroundColor(AppTheme.Colors.black100)
                        .lineLimit(1)

                    Spacer()

                    Button {
                        viewModel.removeDocument(at: index)
                    } label: {
                        Image(systemName: "trash")
                            .font(.system(size: 14))
                            .foregroundColor(AppTheme.Colors.gray300)
                    }
                }
                .frame(height: 48)
                .padding(.horizontal, AppTheme.Spacing.xSmall)
                .background(
                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                        .stroke(AppTheme.Colors.gray200, lineWidth: 1)
                )
            }

            CustomTextField(
                title: "",
                placeholder: "Paste document URL",
                text: $viewModel.documentURL,
                icon: "link",
                keyboardType: .URL,
                autocapitalization: .never
            )

            Button {
                viewModel.addDocument()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(AppTheme.Colors.purple200)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle().fill(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.1))
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.top, AppTheme.Spacing.xxSmall)
        }
    }

    private var bottomButtons: some View {
        HStack(spacing: AppTheme.Spacing.small) {
            Button {
                viewModel.previousStep()
            } label: {
                Text("Back")
                    .font(AppTheme.textStyle(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(AppTheme.Colors.changeOpacity(color: AppTheme.Colors.purple200, opacity: 0.1))
                    .foregroundColor(AppTheme.Colors.purple200)
                    .cornerRadius(AppTheme.radius.meduim)
            }
            .disabled(viewModel.isLoading)

            Button {
                viewModel.submitRegistration()
            } label: {
                HStack(spacing: AppTheme.Spacing.xxSmall) {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.white100))
                    } else {
                        Text("Submit")
                    }
                }
                .font(AppTheme.textStyle(size: 16, weight: .bold))
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(AppTheme.Colors.purple200)
                .foregroundColor(AppTheme.Colors.white100)
                .cornerRadius(AppTheme.radius.meduim)
            }
            .disabled(viewModel.isLoading)
        }
        .padding(.horizontal, AppTheme.Spacing.large)
        .padding(.bottom, AppTheme.Spacing.large)
    }

    private func errorBanner(_ message: String) -> some View {
        HStack(spacing: AppTheme.Spacing.xxSmall) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(AppTheme.Colors.red100)

            Text(message)
                .font(AppTheme.textStyle(size: 13))
                .foregroundColor(AppTheme.Colors.red100)
        }
        .padding(AppTheme.Spacing.xSmall)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.radius.small)
                .fill(AppTheme.Colors.red100.opacity(0.1))
        )
    }
}

#Preview {
    ContactAndLocationView(viewModel: AuthViewModel(useCase: AuthUseCaseImpl(repository: OrganizationAuthRepositoryImpl(networkService: OrganizationAuthNetworkServiceImpl()))))
}
