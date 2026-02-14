import SwiftUI

// MARK: - PostActions
// Like and comment action buttons for a post.

struct PostActions: View {
    let likes: [User]
    let isLiked: Bool
    let onLikeTap: () -> Void
    let onCommentTap: () -> Void

    var body: some View {
        HStack(spacing: TANDASpacing.sm + 4) {  // 12px
            // Likes section
            if !likes.isEmpty {
                HStack(spacing: 4) {
                    // Heart icon
                    Button(action: onLikeTap) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundStyle(isLiked ? TANDAColors.Feedback.red : TANDAColors.Brand.black1)
                    }
                    .buttonStyle(.plain)

                    // Avatar stack
                    AvatarStack(users: likes)
                }
            } else {
                // Just heart icon when no likes
                Button(action: onLikeTap) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(isLiked ? TANDAColors.Feedback.red : TANDAColors.Brand.black1)
                }
                .buttonStyle(.plain)
            }

            // Comment button
            Button(action: onCommentTap) {
                Image(systemName: "message")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(TANDAColors.Brand.black1)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview("Post Actions") {
    let users = [
        User(name: "Alice Johnson"),
        User(name: "Bob Smith"),
        User(name: "Charlie Brown"),
        User(name: "Diana Prince"),
        User(name: "Eve Taylor")
    ]

    VStack(spacing: 24) {
        PostActions(
            likes: Array(users.prefix(18)),
            isLiked: false,
            onLikeTap: {},
            onCommentTap: {}
        )

        PostActions(
            likes: Array(users.prefix(3)),
            isLiked: true,
            onLikeTap: {},
            onCommentTap: {}
        )

        PostActions(
            likes: [],
            isLiked: false,
            onLikeTap: {},
            onCommentTap: {}
        )
    }
    .padding()
    .background(TANDAColors.Neutral.n0)
}
