import SwiftUI

// MARK: - CelebrationView
// Success screen shown after email verification.

struct CelebrationView: View {
    @State private var animate = false
    @State private var showContent = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        SheetLayout(type: .immersive, showFooter: true) {
            VStack(spacing: 0) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(TANDAColors.Brand.primary.opacity(0.2))
                        .frame(width: 124, height: 124)
                        .scaleEffect(animate ? 1.0 : 0.8)

                    Circle()
                        .fill(TANDAColors.Brand.primary)
                        .frame(width: 100, height: 100)
                        .scaleEffect(animate ? 1.0 : 0.5)

                    Image(systemName: "checkmark")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(.white)
                        .scaleEffect(animate ? 1.0 : 0.0)
                }
                .padding(.bottom, TANDASpacing.xl)

                Text("You're In!")
                    .font(TANDATypography.Display.m)
                    .foregroundStyle(TANDAColors.Neutral.n900)
                    .opacity(showContent ? 1.0 : 0.0)
                    .offset(y: showContent ? 0 : 20)
                    .padding(.bottom, TANDASpacing.sm)

                Text("Your account is ready. Let's set up your profile.")
                    .font(TANDATypography.Paragraph.m)
                    .foregroundStyle(TANDAColors.Text.secondary)
                    .multilineTextAlignment(.center)
                    .opacity(showContent ? 1.0 : 0.0)
                    .offset(y: showContent ? 0 : 20)
                    .padding(.horizontal, TANDASpacing.xl)

                Spacer()
            }
        } footer: {
            PrimaryButtonDock {
                PrimaryButton("Continue", kind: .primary, isFullWidth: true) {
                    appState.startOnboarding()
                }
            }
            .opacity(showContent ? 1.0 : 0.0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                animate = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                withAnimation(.easeOut(duration: 0.4)) {
                    showContent = true
                }
            }
        }
    }
}

#Preview("Celebration") {
    CelebrationView()
        .environmentObject(AppState())
}
