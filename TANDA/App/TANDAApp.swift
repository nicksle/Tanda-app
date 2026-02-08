import SwiftUI

// MARK: - App Entry Point

@main
struct TANDAApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appState)
                .preferredColorScheme(.light) // Demo in light mode
        }
    }
}

// MARK: - App State

class AppState: ObservableObject {

    enum AppScreen {
        case onboardingSplash  // New carousel splash
        case onboarding        // Account setup flow
        case home
    }

    @Published var currentScreen: AppScreen = .onboardingSplash
    @Published var isOnboardingComplete: Bool = false

    func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isOnboardingComplete = true
            currentScreen = .home
        }
    }

    func resetToSplash() {
        withAnimation {
            currentScreen = .onboardingSplash
            isOnboardingComplete = false
        }
    }
}

// MARK: - Root View

struct RootView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        Group {
            switch appState.currentScreen {
            case .onboardingSplash:
                OnboardingSplash()
                    .transition(AnyTransition.opacity)
            case .onboarding:
                OnboardingFlow()
                    .transition(.move(edge: .trailing))
            case .home:
                HomeScreen()
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: appState.currentScreen)
    }
}

// MARK: - Placeholder Screens
// These will be replaced in Sprint 2-4.
// For now they verify the navigation flow works.

struct SplashScreen: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: TANDASpacing.xl) {
            Spacer()
            
            // Logo placeholder
            ZStack {
                Circle()
                    .fill(TANDAColors.Purple.p500.opacity(0.15))
                    .frame(width: 120, height: 120)
                
                Text("T")
                    .font(TANDATypography.Display.xxl)
                    .foregroundStyle(TANDAColors.Purple.p500)
            }
            
            VStack(spacing: TANDASpacing.sm) {
                Text("TANDA")
                    .font(TANDATypography.Display.xl)
                    .foregroundStyle(TANDAColors.Neutral.n900)
                
                Text("Save together")
                    .font(TANDATypography.Paragraph.l)
                    .foregroundStyle(TANDAColors.Neutral.n500)
            }
            
            Spacer()
            
            VStack(spacing: TANDASpacing.sm) {
                TANDAButton("Get Started", kind: .primary, isFullWidth: true) {
                    withAnimation {
                        appState.currentScreen = .onboarding
                    }
                }
                
                TANDAButton("I already have an account", kind: .tertiary) {
                    // For demo, skip to home
                    appState.completeOnboarding()
                }
            }
            .padding(.horizontal, TANDASpacing.lg)
            .padding(.bottom, 34)
        }
    }
}

// Temporary placeholder — will be built in Sprint 2
struct OnboardingFlow: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        PageView(footerHeight: 130) {
            VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                Text("Create Account")
                    .font(TANDATypography.Display.m)
                Text("Join your first savings circle")
                    .font(TANDATypography.Paragraph.m)
                    .foregroundStyle(TANDAColors.Neutral.n500)
            }
        } body: {
            VStack(spacing: TANDASpacing.lg) {
                TANDAInput(
                    text: .constant(""),
                    label: "Full Name",
                    placeholder: "Enter your name"
                )
                TANDAInput(
                    text: .constant(""),
                    label: "Email",
                    placeholder: "name@example.com"
                )
                TANDAInput(
                    text: .constant(""),
                    type: .password,
                    label: "Password",
                    placeholder: "Create a password"
                )
            }
            .padding(.top, TANDASpacing.md)
        } foot: {
            TANDAButton("Continue", kind: .primary, isFullWidth: true) {
                appState.completeOnboarding()
            }
        }
    }
}

// Temporary placeholder — will be built in Sprint 3
struct HomeScreen: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationStack {
            PageView {
                VStack(alignment: .leading, spacing: TANDASpacing.xs) {
                    Text("Hey, Sarah 👋")
                        .font(TANDATypography.Display.m)
                    Text("You've saved $\(Int(MockData.totalSaved)) so far")
                        .font(TANDATypography.Paragraph.m)
                        .foregroundStyle(TANDAColors.Neutral.n500)
                }
            } body: {
                VStack(spacing: TANDASpacing.lg) {
                    // Quick stats
                    HStack(spacing: TANDASpacing.sm) {
                        StatCard(
                            label: "Active Circles",
                            value: "\(MockData.activeCircleCount)",
                            color: TANDAColors.Purple.p500
                        )
                        StatCard(
                            label: "Next Payout",
                            value: "$\(Int(MockData.nextPayoutAmount))",
                            color: TANDAColors.Feedback.green
                        )
                    }
                    
                    // Circles
                    VStack(alignment: .leading, spacing: TANDASpacing.sm + 4) {
                        Text("Your Circles")
                            .font(TANDATypography.Heading.m)
                        
                        ForEach(MockData.circles) { circle in
                            CircleRow(circle: circle)
                        }
                    }
                    
                    // Recent activity
                    VStack(alignment: .leading, spacing: TANDASpacing.sm + 4) {
                        Text("Recent Activity")
                            .font(TANDATypography.Heading.m)
                        
                        ForEach(MockData.recentTransactions) { tx in
                            TransactionRow(transaction: tx)
                        }
                    }
                }
                .padding(.top, TANDASpacing.md)
            }
        }
    }
}

// MARK: - Temp Home Components (will move to Components/ in Sprint 3)

struct StatCard: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.xs) {
            Text(label)
                .font(TANDATypography.Label.s)
                .foregroundStyle(TANDAColors.Neutral.n500)
            Text(value)
                .font(TANDATypography.Heading.l)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(TANDASpacing.md)
        .background(TANDAColors.Neutral.n50)
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
    }
}

struct CircleRow: View {
    let circle: MockCircle
    
    var body: some View {
        HStack(spacing: TANDASpacing.sm + 4) {
            Text(circle.emoji)
                .font(.system(size: 28))
                .frame(width: 48, height: 48)
                .background(TANDAColors.Neutral.n100)
                .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
            
            VStack(alignment: .leading, spacing: 2) {
                Text(circle.name)
                    .font(TANDATypography.Heading.s)
                Text("\(circle.memberCount) members · \(circle.frequency)")
                    .font(TANDATypography.Paragraph.s)
                    .foregroundStyle(TANDAColors.Neutral.n500)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("$\(Int(circle.totalPool))")
                    .font(TANDATypography.Label.m)
                Text("pool")
                    .font(TANDATypography.Label.xs)
                    .foregroundStyle(TANDAColors.Neutral.n400)
            }
        }
        .padding(TANDASpacing.sm + 4)
        .background(TANDAColors.Neutral.n0)
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

struct TransactionRow: View {
    let transaction: MockTransaction
    
    var body: some View {
        HStack(spacing: TANDASpacing.sm + 4) {
            Text(transaction.circleEmoji)
                .font(.system(size: 20))
                .frame(width: 40, height: 40)
                .background(TANDAColors.Neutral.n100)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(TANDATypography.Label.m)
                Text(transaction.subtitle)
                    .font(TANDATypography.Paragraph.s)
                    .foregroundStyle(TANDAColors.Neutral.n500)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                Text("\(transaction.isCredit ? "+" : "-")$\(Int(transaction.amount))")
                    .font(TANDATypography.Label.m)
                    .foregroundStyle(transaction.isCredit ? TANDAColors.Feedback.green : TANDAColors.Neutral.n900)
                Text(transaction.date)
                    .font(TANDATypography.Label.xs)
                    .foregroundStyle(TANDAColors.Neutral.n400)
            }
        }
        .padding(.vertical, TANDASpacing.sm)
    }
}
