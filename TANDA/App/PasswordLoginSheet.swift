import SwiftUI

// MARK: - PasswordLoginSheet
// Half sheet for existing users to enter their password.

struct PasswordLoginSheet: View {
    @State private var password = ""
    @State private var loginError: String? = nil
    @State private var isLoading = false
    @State private var attemptCount = 0
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    var body: some View {
        SheetLayout(
            type: .half,
            title: "Welcome Back",
            showLeftAction: true,
            leftAction: { dismiss() },
            showRightAction: false,
            showFooter: false
        ) {
            VStack(spacing: 0) {
                Text(appState.authEmail)
                    .font(TANDATypography.Paragraph.m)
                    .foregroundStyle(TANDAColors.Text.secondary)
                    .padding(.bottom, TANDASpacing.lg)

                Input(
                    text: $password,
                    type: .password,
                    label: "Password",
                    placeholder: "Enter your password",
                    error: loginError
                )
                .padding(.bottom, TANDASpacing.sm)

                HStack {
                    Spacer()
                    Button("Forgot password?") { }
                        .font(TANDATypography.Label.s)
                        .foregroundStyle(TANDAColors.Brand.primary)
                }
                .padding(.bottom, TANDASpacing.lg)

                PrimaryButton(
                    "Sign In",
                    kind: .primary,
                    isLoading: isLoading,
                    isDisabled: password.isEmpty,
                    isFullWidth: true
                ) {
                    handleSignIn()
                }
            }
            .padding(.horizontal, TANDASpacing.lg)
        } footer: {
            EmptyView()
        }
    }

    private func handleSignIn() {
        isLoading = true
        loginError = nil
        attemptCount += 1

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            if attemptCount == 1 {
                loginError = "Incorrect password. Please try again."
            } else {
                dismiss()
                appState.completeOnboarding()
            }
        }
    }
}

#Preview("Password Login") {
    Color.black.ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            PasswordLoginSheet()
                .environmentObject({ let s = AppState(); s.authEmail = "test@example.com"; return s }())
                .presentationDetents([.medium])
        }
}
