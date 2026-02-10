import SwiftUI

// MARK: - AuthButton
// Social authentication button for Google sign-in.
// Apple uses the native SignInWithAppleButton instead.

struct AuthButton: View {
    enum Provider {
        case google
    }

    let provider: Provider
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                providerIcon
                    .frame(width: 20, height: 20)

                Text("Continue with \(providerName)")
                    .font(TANDATypography.Label.l)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(TANDAColors.Neutral.n800)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(TANDAColors.Neutral.n700, lineWidth: 1)
            )
        }
    }

    private var providerName: String {
        switch provider {
        case .google: return "Google"
        }
    }

    @ViewBuilder
    private var providerIcon: some View {
        switch provider {
        case .google:
            // Placeholder using SF Symbol
            // TODO: Replace with actual Google logo from assets
            Image(systemName: "g.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Preview

#Preview("Google Auth Button") {
    VStack(spacing: TANDASpacing.md) {
        AuthButton(provider: .google) {
            print("Google sign in tapped")
        }
    }
    .padding(TANDASpacing.lg)
    .background(TANDAColors.Neutral.n900)
}
