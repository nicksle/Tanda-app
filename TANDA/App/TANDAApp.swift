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
        case loadingHome       // Skeleton loading after onboarding
        case home
    }

    @Published var currentScreen: AppScreen = .home  // .onboardingSplash for production
    @Published var isOnboardingComplete: Bool = false
    @Published var authEmail: String = ""
    @Published var isExistingAccount: Bool = false
    @Published var surveyResponses: [String: [String]] = [:]
    @Published var surveySkipped: Bool = false

    // KYC Verification State
    @Published var isKYCVerified: Bool = false

    // Circles Intro State
    @Published var hasSeenCirclesIntro: Bool = false

    // Tab Navigation State
    @Published var selectedTab: TabItem = .home

    // Social Feed State
    @Published var currentUser: User = MockData.feedUsers[4]  // Sarah Kim
    @Published var posts: [Post] = MockData.samplePosts

    func completeOnboarding() {
        // Fade to loading screen
        withAnimation(.easeOut(duration: 0.3)) {
            currentScreen = .loadingHome
            isOnboardingComplete = true
        }

        // After 2 seconds, fade to home
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeInOut(duration: 0.6)) {
                self.currentScreen = .home
            }
        }
    }

    func startOnboarding() {
        withAnimation(.easeInOut(duration: 0.4)) {
            currentScreen = .onboarding
        }
    }

    func resetToSplash() {
        withAnimation {
            currentScreen = .onboardingSplash
            isOnboardingComplete = false
            authEmail = ""
            isExistingAccount = false
        }
    }

    // MARK: - KYC Verification

    func completeKYCVerification() {
        isKYCVerified = true
        // In production, this would trigger backend verification process
        print("KYC verification submitted for user: \(currentUser.name)")
    }

    // MARK: - Circles Intro

    func completeCirclesIntro() {
        hasSeenCirclesIntro = true
        print("Circles intro completed for user: \(currentUser.name)")
    }

    // MARK: - Social Feed Actions

    func addPost(content: String, imageURL: String?) {
        let newPost = Post(
            user: currentUser,
            content: content,
            imageURL: imageURL
        )
        posts.insert(newPost, at: 0)  // Add to top of feed
    }

    func toggleLike(on post: Post) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }

        var updatedPost = posts[index]

        if let likeIndex = updatedPost.likes.firstIndex(where: { $0.id == currentUser.id }) {
            // Unlike: remove current user from likes
            updatedPost.likes.remove(at: likeIndex)
        } else {
            // Like: add current user to likes
            updatedPost.likes.append(currentUser)
        }

        posts[index] = updatedPost
    }

    func addComment(to post: Post, text: String) {
        guard let index = posts.firstIndex(where: { $0.id == post.id }) else { return }

        var updatedPost = posts[index]
        let newComment = Comment(user: currentUser, text: text)
        updatedPost.comments.append(newComment)

        posts[index] = updatedPost
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
                OnboardingContainerView()
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .opacity
                        )
                    )
            case .loadingHome:
                SkeletonLoadingView()
                    .transition(AnyTransition.opacity)
            case .home:
                TabContainerView()
                    .transition(AnyTransition.opacity)
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
                SwiftUI.Circle()
                    .fill(TANDAColors.Purple.p500.opacity(0.15))
                    .frame(width: 120, height: 120)
                
                Text("T")
                    .font(TANDATypography.Display.xxl)
                    .foregroundStyle(TANDAColors.Purple.p500)
            }
            
            VStack(spacing: TANDASpacing.sm) {
                Text("TANDA")
                    .font(TANDATypography.Display.xl)
                    .foregroundStyle(TANDAColors.Text.primary)

                Text("Save together")
                    .font(TANDATypography.Paragraph.l)
                    .foregroundStyle(TANDAColors.Text.secondary)
            }
            
            Spacer()
            
            VStack(spacing: TANDASpacing.sm) {
                PrimaryButton("Get Started", kind: .primary, isFullWidth: true) {
                    withAnimation {
                        appState.currentScreen = .onboarding
                    }
                }
                
                PrimaryButton("I already have an account", kind: .tertiary) {
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
                    .foregroundStyle(TANDAColors.Text.secondary)
            }
        } body: {
            VStack(spacing: TANDASpacing.lg) {
                Input(
                    text: .constant(""),
                    label: "Full Name",
                    placeholder: "Enter your name"
                )
                Input(
                    text: .constant(""),
                    label: "Email",
                    placeholder: "name@example.com"
                )
                Input(
                    text: .constant(""),
                    type: .password,
                    label: "Password",
                    placeholder: "Create a password"
                )
            }
            .padding(.top, TANDASpacing.md)
        } foot: {
            PrimaryButton("Continue", kind: .primary, isFullWidth: true) {
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
                        .foregroundStyle(TANDAColors.Text.secondary)
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
                            PreviewTransactionRow(transaction: tx)
                        }
                    }
                }
                .padding(.top, TANDASpacing.md)
            }
        }
    }
}

// MARK: - Preview Components

struct StatCard: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.xs) {
            Text(label)
                .font(TANDATypography.Label.s)
                .foregroundStyle(TANDAColors.Text.secondary)
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
                    .foregroundStyle(TANDAColors.Text.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("$\(Int(circle.totalPool))")
                    .font(TANDATypography.Label.m)
                Text("pool")
                    .font(TANDATypography.Label.xs)
                    .foregroundStyle(TANDAColors.Text.tertiary)
            }
        }
        .padding(TANDASpacing.sm + 4)
        .background(TANDAColors.Neutral.n0)
        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

struct PreviewTransactionRow: View {
    let transaction: MockTransaction

    var body: some View {
        HStack(spacing: TANDASpacing.sm + 4) {
            Text(transaction.circleEmoji)
                .font(.system(size: 20))
                .frame(width: 40, height: 40)
                .background(TANDAColors.Neutral.n100)
                .clipShape(SwiftUI.Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.title)
                    .font(TANDATypography.Label.m)
                Text(transaction.subtitle)
                    .font(TANDATypography.Paragraph.s)
                    .foregroundStyle(TANDAColors.Text.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(transaction.isCredit ? "+" : "-")$\(Int(transaction.amount))")
                    .font(TANDATypography.Label.m)
                    .foregroundStyle(transaction.isCredit ? TANDAColors.Feedback.green : TANDAColors.Neutral.n900)
                Text(transaction.date)
                    .font(TANDATypography.Label.xs)
                    .foregroundStyle(TANDAColors.Text.tertiary)
            }
        }
        .padding(.vertical, TANDASpacing.sm)
    }
}
