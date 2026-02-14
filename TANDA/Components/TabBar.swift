import SwiftUI

// MARK: - TabBar
// Bottom navigation bar with 4 tabs: Home, Circles, Transactions, Profile.

enum TabItem: CaseIterable {
    case home
    case circles
    case transactions
    case profile

    var title: String {
        switch self {
        case .home: return "Home"
        case .circles: return "Circles"
        case .transactions: return "Transactions"
        case .profile: return "Profile"
        }
    }

    var iconName: String {
        switch self {
        case .home: return "house"
        case .circles: return "circle.dotted"
        case .transactions: return "dollarsign.circle"
        case .profile: return "person.circle"
        }
    }

    var selectedIconName: String {
        switch self {
        case .home: return "house.fill"
        case .circles: return "circle.dotted"
        case .transactions: return "dollarsign.circle.fill"
        case .profile: return "person.circle.fill"
        }
    }
}

struct TabBar: View {
    @Binding var selectedTab: TabItem
    let currentUser: User?

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()

                // Liquid glass pill container
                HStack(spacing: 0) {
                    ForEach(TabItem.allCases, id: \.self) { tab in
                        TabBarButton(
                            tab: tab,
                            isSelected: selectedTab == tab,
                            currentUser: currentUser,
                            action: {
                                selectedTab = tab
                            }
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                .background(LiquidGlassBackground())
                .padding(.horizontal, 25)
                .padding(.bottom, max(geometry.safeAreaInsets.bottom - 8, 16))
            }
        }
        .frame(height: 83)
    }
}

// MARK: - Liquid Glass Background

struct LiquidGlassBackground: View {
    var body: some View {
        ZStack {
            // Base blur material
            RoundedRectangle(cornerRadius: 50)
                .fill(.ultraThinMaterial)

            // Liquid glass effect layers
            RoundedRectangle(cornerRadius: 50)
                .fill(Color.black.opacity(0.04))
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.5),
                                    Color.white.opacity(0.3)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .blendMode(.overlay)
                )

            // Subtle inner glow
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color.white.opacity(0.2), lineWidth: 0.5)
                .blendMode(.overlay)
        }
    }
}

struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let currentUser: User?
    let action: () -> Void

    // iOS standard colors
    private let selectedColor = Color(red: 0/255, green: 136/255, blue: 255/255) // #0088FF
    private let unselectedColor = Color(red: 64/255, green: 64/255, blue: 64/255) // #404040
    private let selectedBackground = Color(red: 237/255, green: 237/255, blue: 237/255) // #EDEDED

    var body: some View {
        Button(action: action) {
            VStack(spacing: 1) {
                // Icon (iOS standard 17pt)
                if tab == .profile, let user = currentUser {
                    // Profile avatar
                    ZStack {
                        SwiftUI.Circle()
                            .fill(user.avatarColor)
                            .frame(width: 28, height: 28)

                        if user.avatarURL != nil {
                            // TODO: AsyncImage
                            SwiftUI.Circle()
                                .fill(user.avatarColor)
                                .frame(width: 28, height: 28)
                        } else {
                            Text(user.initials)
                                .font(.system(size:11, weight: .medium))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: 28)
                } else {
                    Image(systemName: isSelected ? tab.selectedIconName : tab.iconName)
                        .font(.system(size: 17, weight: isSelected ? .semibold : .regular))
                        .foregroundStyle(isSelected ? selectedColor : unselectedColor)
                        .frame(height: 28)
                }

                // Label (iOS standard 10pt)
                Text(tab.title)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .medium))
                    .kerning(-0.1)
                    .foregroundStyle(isSelected ? selectedColor : unselectedColor)
                    .frame(height: 12)
            }
            .padding(.top, 6)
            .padding(.bottom, 7)
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity)
            .background(
                isSelected ?
                    RoundedRectangle(cornerRadius: 100)
                        .fill(selectedBackground)
                    : nil
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview("Tab Bar") {
    ZStack(alignment: .bottom) {
        // Background content to show blur effect
        ScrollView {
            VStack(spacing: 16) {
                ForEach(0..<10) { i in
                    RoundedRectangle(cornerRadius: 12)
                        .fill(TANDAColors.Purple.p500.opacity(0.3))
                        .frame(height: 100)
                        .overlay(
                            Text("Content \(i + 1)")
                                .font(TANDATypography.Heading.m)
                        )
                }
            }
            .padding()
        }

        // Tab bar with liquid glass
        TabBar(
            selectedTab: .constant(.circles),
            currentUser: User(name: "Sarah Kim")
        )
    }
    .frame(width: 393, height: 852)
}
