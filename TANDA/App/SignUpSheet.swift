import SwiftUI
import AuthenticationServices

// MARK: - SignUpSheet
// Half sheet presenting account creation options.

struct SignUpSheet: View {
    @State private var email = ""
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState

    var onNewAccount: ((String) -> Void)? = nil
    var onExistingAccount: ((String) -> Void)? = nil

    private var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }

    var body: some View {
        SheetLayout(
            type: .half,
            title: "Sign Up or Log In",
            showLeftAction: false,
            showRightAction: false,
            showFooter: false
        ) {
            VStack(spacing: 0) {
                Input(
                    text: $email,
                    label: "Email",
                    placeholder: "name@example.com"
                )
                .padding(.bottom, 16)

                PrimaryButton(
                    isLoading ? "Checking..." : "Continue",
                    kind: .primary,
                    isLoading: isLoading,
                    isDisabled: !isValidEmail,
                    isFullWidth: true
                ) {
                    handleContinue()
                }
                .padding(.bottom, 20)

                Divider(label: "or continue with")
                    .padding(.bottom, 20)

                SignInWithAppleButton(.continue) { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    switch result {
                    case .success:
                        dismiss()
                        appState.completeOnboarding()
                    case .failure(let error):
                        print("Apple sign in failed: \(error)")
                    }
                }
                .signInWithAppleButtonStyle(.white)
                .frame(height: 56)
                .clipShape(Capsule())
                .padding(.bottom, 12)

                AuthButton(provider: .google) {
                    dismiss()
                    appState.completeOnboarding()
                }
            }
            .padding(.horizontal, 24)
        } footer: {
            EmptyView()
        }
    }

    private func handleContinue() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            if let onNewAccount = onNewAccount {
                onNewAccount(email)
            } else {
                dismiss()
                appState.completeOnboarding()
            }
        }
    }
}

#Preview("SignUpSheet") {
    Color.black.ignoresSafeArea()
        .sheet(isPresented: .constant(true)) {
            SignUpSheet()
                .environmentObject(AppState())
                .presentationDetents([.medium])
        }
}
