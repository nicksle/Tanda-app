import SwiftUI

// MARK: - PostInputBar
// "What's on your mind?" post creation input bar.
// Appears at top of social feed.

struct PostInputBar: View {
    let currentUser: User
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: TANDASpacing.sm + 4) {  // 12px
                // User avatar
                ZStack {
                    SwiftUI.Circle()
                        .fill(currentUser.avatarColor)
                        .frame(width: 32, height: 32)

                    if let avatarURL = currentUser.avatarURL {
                        // TODO: AsyncImage when we have real URLs
                        SwiftUI.Circle()
                            .fill(currentUser.avatarColor)
                            .frame(width: 32, height: 32)
                    } else {
                        Text(currentUser.initials)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(.white)
                    }
                }

                // Placeholder text
                Text("What's on your mind?")
                    .font(TANDATypography.Paragraph.s)
                    .foregroundStyle(TANDAColors.Text.tertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Camera icon
                Image(systemName: "photo")
                    .font(.system(size: 17.333, weight: .regular))
                    .foregroundStyle(TANDAColors.Brand.accentPurple)
            }
            .padding(.horizontal, TANDASpacing.md)
            .padding(.vertical, TANDASpacing.md)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
            .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Post Input Bar") {
    VStack(spacing: 0) {
        PostInputBar(
            currentUser: User(name: "Sarah Kim"),
            onTap: { print("Tapped input bar") }
        )
        Spacer()
    }
    .background(TANDAColors.Neutral.n50)
}
