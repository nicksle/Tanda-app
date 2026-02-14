import SwiftUI

// MARK: - EmailVerificationView
// Full screen OTP verification for new account email confirmation.

struct EmailVerificationView: View {
    @State private var otpCode = ""
    @State private var resendCountdown = 60
    @State private var isVerifying = false
    @State private var showCelebration = false
    @State private var emailIconOffset: CGFloat = 0
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        SheetLayout(
            type: .immersive,
            title: "Verify Email",
            showRightAction: true,
            rightAction: { dismiss() }
        ) {
            VStack(alignment: .leading, spacing: 0) {
                Spacer()

                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [TANDAColors.Purple.p500, TANDAColors.Purple.p400],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 72, height: 72)

                    Image(systemName: "envelope.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.white)
                }
                .offset(y: emailIconOffset)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                        emailIconOffset = -8
                    }
                }
                .padding(.bottom, TANDASpacing.xl)

                Text("Please verify your email address")
                    .font(TANDATypography.Display.l)
                    .foregroundStyle(TANDAColors.Text.primary)
                    .padding(.bottom, TANDASpacing.sm)

                Text("We've sent an email to \(appState.authEmail). Please enter the 6 digit code below.")
                    .font(TANDATypography.Paragraph.m)
                    .foregroundStyle(TANDAColors.Text.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.bottom, TANDASpacing.xl)

                OTPInput(code: $otpCode)

                Spacer()
            }
            .padding(.horizontal, TANDASpacing.md)
        } footer: {
            PrimaryButtonDock {
                PrimaryButton(
                    "Verify",
                    kind: .primary,
                    isLoading: isVerifying,
                    isDisabled: otpCode.count < 6,
                    isFullWidth: true
                ) {
                    isVerifying = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isVerifying = false
                        showCelebration = true
                    }
                }

                PrimaryButton(
                    "Need Help?",
                    kind: .secondary,
                    isFullWidth: true
                ) {
                    // TODO: Show help/support options
                }

                PrimaryButton(
                    resendCountdown > 0 ? "Resend Code (\(resendCountdown)s)" : "Resend Code",
                    kind: .tertiary,
                    isDisabled: resendCountdown > 0,
                    isFullWidth: true
                ) {
                    resendCountdown = 60
                }
            }
        }
        .onReceive(timer) { _ in
            if resendCountdown > 0 { resendCountdown -= 1 }
        }
        .fullScreenCover(isPresented: $showCelebration) {
            CelebrationView()
        }
    }
}

#Preview("Email Verification") {
    EmailVerificationView()
        .environmentObject({ let s = AppState(); s.authEmail = "test@example.com"; return s }())
}
