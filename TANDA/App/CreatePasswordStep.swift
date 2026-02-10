import SwiftUI

// MARK: - CreatePasswordStep
// Step 1 of onboarding: Create password with strength indicator.

struct CreatePasswordStep: View {
    @Binding var password: String
    @Binding var confirmPassword: String

    var isValid: Bool {
        password.count >= 8 && password == confirmPassword
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Create a Password")
                .font(TANDATypography.Heading.l)
                .foregroundStyle(.white)
                .padding(.bottom, TANDASpacing.xs)

            Text("Choose a strong password to keep your account secure.")
                .font(TANDATypography.Paragraph.m)
                .foregroundStyle(TANDAColors.Text.secondary)
                .padding(.bottom, TANDASpacing.lg)

            Input(
                text: $password,
                type: .password,
                label: "Password",
                placeholder: "Create a password"
            )
            .padding(.bottom, TANDASpacing.sm)

            PasswordStrengthBar(password: password)
                .padding(.bottom, TANDASpacing.lg)

            Input(
                text: $confirmPassword,
                type: .password,
                label: "Confirm Password",
                placeholder: "Re-enter your password",
                error: passwordMismatchError
            )
        }
        .padding(.horizontal, TANDASpacing.lg)
    }

    private var passwordMismatchError: String? {
        guard !confirmPassword.isEmpty else { return nil }
        guard password != confirmPassword else { return nil }
        return "Passwords don't match"
    }
}

#Preview("Create Password Step") {
    struct PreviewWrapper: View {
        @State private var password = ""
        @State private var confirmPassword = ""
        var body: some View {
            VStack {
                CreatePasswordStep(password: $password, confirmPassword: $confirmPassword)
                Spacer()
            }
            .padding(.top, TANDASpacing.lg)
            .background(TANDAColors.Neutral.n900)
        }
    }
    return PreviewWrapper()
}
