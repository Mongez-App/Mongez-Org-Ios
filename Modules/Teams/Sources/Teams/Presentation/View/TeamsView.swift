import SwiftUI
import Common

public struct TeamsView: View {
    @StateObject var viewModel: TeamsViewModel
    @State private var searchText: String = ""
    @State private var showingAddTeamSheet = false
    @State private var showSuccessAlert = false
    
    // Pass a closure for navigation when a team is clicked
    var onTeamTap: (String, String) -> Void

    public init(viewModel: TeamsViewModel, onTeamTap: @escaping (String, String) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onTeamTap = onTeamTap
    }
    
    private var filteredTeams: [Team] {
        if searchText.isEmpty {
            return viewModel.teams
        } else {
            return viewModel.teams.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    public var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("Teams")
                        .font(AppTheme.textStyle(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                    
                    Spacer()
                    
                    Button(action: { showingAddTeamSheet = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(AppTheme.Colors.purple200)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(AppTheme.Colors.white100)
                                    .appShadow(opacity: 0.7, radius: 2.5)
                            )
                    }
                }
                .padding(.horizontal, AppTheme.Spacing.medium)
                .padding(.top, AppTheme.Spacing.small)
                .padding(.bottom, AppTheme.Spacing.medium)
                
                // Search Bar
                HStack(spacing: AppTheme.Spacing.xSmall) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundColor(AppTheme.Colors.gray300)
                    TextField("Search teams...", text: $searchText)
                        .font(AppTheme.textStyle(size: 16))
                }
                .padding(.vertical, 16)
                .padding(.horizontal, AppTheme.Spacing.medium)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(AppTheme.Colors.gray100, lineWidth: 1.2)
                )
                .padding(.horizontal, AppTheme.Spacing.medium)
                .padding(.bottom, AppTheme.Spacing.large)
                
                // Content
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.purple200))
                        .scaleEffect(1.5)
                    Spacer()
                } else if viewModel.teams.isEmpty {
                    VStack {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(AppTheme.Colors.purple200.opacity(0.25))
                                .frame(width: 130, height: 130)
                            
                            Image("group")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 72, height: 72)
                                .foregroundColor(AppTheme.Colors.purple200)
                        }
                        .padding(.bottom, AppTheme.Spacing.medium)
                        
                        Text("No Teams Yet")
                            .font(AppTheme.textStyle(size: 20, weight: .bold))
                            .foregroundColor(AppTheme.Colors.black100)
                        
                        Text("You haven't added any teams yet")
                            .font(AppTheme.textStyle(size: 14))
                            .foregroundColor(AppTheme.Colors.gray300)
                            .padding(.bottom, AppTheme.Spacing.large)
                        
                        Button(action: { showingAddTeamSheet = true }) {
                            Text("Add Your First Team")
                                .font(AppTheme.textStyle(size: 16, weight: .semibold))
                                .foregroundColor(AppTheme.Colors.white100)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                        .fill(AppTheme.Colors.purple200)
                                )
                        }
                        .padding(.horizontal, AppTheme.Spacing.xLarge)
                        Spacer()
                    }
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: AppTheme.Spacing.large) {
                            ForEach(filteredTeams, id: \.id) { team in
                                TeamCardView(team: team) {
                                    onTeamTap(team.id, team.name)
                                }
                            }
                        }
                        .padding(.horizontal, AppTheme.Spacing.medium)
                        .padding(.top, AppTheme.Spacing.small)
                        .padding(.bottom, AppTheme.Spacing.xxLarge)
                    }
                }
            }
            
            // Custom Success Alert Overlay
            if showSuccessAlert {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                
                VStack(spacing: AppTheme.Spacing.large) {
                    Text("Confirmation")
                        .font(AppTheme.textStyle(size: 20, weight: .bold))
                        .foregroundColor(AppTheme.Colors.black100)
                    
                    Text("Your New Team Has Been Added\nSuccessfully")
                        .font(AppTheme.textStyle(size: 14))
                        .foregroundColor(AppTheme.Colors.gray300)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        withAnimation {
                            showSuccessAlert = false
                        }
                    }) {
                        Text("OK")
                            .font(AppTheme.textStyle(size: 16, weight: .semibold))
                            .foregroundColor(AppTheme.Colors.white100)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: AppTheme.radius.small)
                                    .fill(AppTheme.Colors.purple200)
                            )
                    }
                }
                .padding(AppTheme.Spacing.xLarge)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(AppTheme.Colors.white100)
                        .appShadow(opacity: 0.1, radius: 10)
                )
                .padding(.horizontal, AppTheme.Spacing.large)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .task {
            await viewModel.fetchTeams()
        }
        .sheet(isPresented: $showingAddTeamSheet) {
            AddTeamSheetView(viewModel: viewModel) {
                withAnimation {
                    showSuccessAlert = true
                }
            }
        }
    }
}
