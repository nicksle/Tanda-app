import SwiftUI

// MARK: - TabContainerView
// Main tab navigation container with 4 tabs: Home, Circles, Transactions, Profile.

struct TabContainerView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: TabItem = .home  // Start on home tab

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            SocialFeedView()
                .tabItem {
                    Image(systemName: selectedTab == .home ? "house.fill" : "house")
                    Text("Home")
                }
                .tag(TabItem.home)

            // Circles Tab
            CirclesView()
                .tabItem {
                    Image(systemName: "circle.dotted")
                    Text("Circles")
                }
                .tag(TabItem.circles)

            // Transactions Tab
            PlaceholderTabView(title: "Transactions", icon: "dollarsign.circle.fill")
                .tabItem {
                    Image(systemName: selectedTab == .transactions ? "dollarsign.circle.fill" : "dollarsign.circle")
                    Text("Transactions")
                }
                .tag(TabItem.transactions)

            // Profile Tab
            PlaceholderTabView(title: "Profile", icon: "person.circle.fill")
                .tabItem {
                    Image(systemName: selectedTab == .profile ? "person.circle.fill" : "person.circle")
                    Text("Profile")
                }
                .tag(TabItem.profile)
        }
    }
}

// MARK: - Placeholder Tab View
// Temporary placeholder for non-implemented tabs.

struct PlaceholderTabView: View {
    let title: String
    let icon: String

    var body: some View {
        VStack(spacing: TANDASpacing.xl) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundStyle(TANDAColors.Purple.p500.opacity(0.3))

            Text(title)
                .font(TANDATypography.Display.m)
                .foregroundStyle(TANDAColors.Text.secondary)

            Text("Coming soon")
                .font(TANDATypography.Paragraph.l)
                .foregroundStyle(TANDAColors.Text.tertiary)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TANDAColors.Neutral.n50)
    }
}

#Preview("Tab Container") {
    TabContainerView()
        .environmentObject(AppState())
}
