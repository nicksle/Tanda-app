import SwiftUI

// MARK: - AvatarStack
// Displays overlapping user avatars with a "+ X more" indicator.
// Used to show who liked a post.

struct AvatarStack: View {
    let users: [User]
    let maxDisplay: Int = 3
    let size: CGFloat = 20
    let borderWidth: CGFloat = 1.25
    let overlap: CGFloat = -4

    private var displayUsers: [User] {
        Array(users.prefix(maxDisplay))
    }

    private var remainingCount: Int {
        max(0, users.count - maxDisplay)
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(displayUsers.enumerated()), id: \.element.id) { index, user in
                ZStack {
                    SwiftUI.Circle()
                        .fill(user.avatarColor)
                        .frame(width: size, height: size)

                    if let avatarURL = user.avatarURL {
                        // TODO: AsyncImage when we have real URLs
                        SwiftUI.Circle()
                            .fill(user.avatarColor)
                            .frame(width: size, height: size)
                    } else {
                        // Show initials in very small text
                        Text(user.initials)
                            .font(.system(size: 8, weight: .medium))
                            .foregroundStyle(.white)
                    }
                }
                .overlay(
                    SwiftUI.Circle()
                        .strokeBorder(TANDAColors.Neutral.n0, lineWidth: borderWidth)
                )
                .offset(x: CGFloat(index) * overlap)
                .zIndex(Double(maxDisplay - index))
            }

            if remainingCount > 0 {
                HStack(spacing: 0) {
                    Text("+ \(remainingCount) more")
                        .font(TANDATypography.Paragraph.s)
                        .foregroundStyle(TANDAColors.Brand.black1)
                        .padding(.horizontal, 8)
                }
                .frame(height: size)
                .background(TANDAColors.Brand.white3)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(TANDAColors.Neutral.n0, lineWidth: borderWidth)
                )
                .offset(x: CGFloat(displayUsers.count) * overlap)
                .padding(.trailing, 4)
            }
        }
    }
}

#Preview("Avatar Stack") {
    let users = [
        User(name: "Alice Johnson"),
        User(name: "Bob Smith"),
        User(name: "Charlie Brown"),
        User(name: "Diana Prince"),
        User(name: "Eve Taylor"),
        User(name: "Frank Wilson"),
        User(name: "Grace Lee"),
        User(name: "Henry Davis"),
        User(name: "Ivy Martinez"),
        User(name: "Jack Robinson"),
        User(name: "Kate Anderson"),
        User(name: "Leo Thomas"),
        User(name: "Mia Jackson"),
        User(name: "Noah White"),
        User(name: "Olivia Harris")
    ]

    VStack(spacing: 24) {
        AvatarStack(users: Array(users.prefix(1)))
        AvatarStack(users: Array(users.prefix(3)))
        AvatarStack(users: Array(users.prefix(5)))
        AvatarStack(users: Array(users.prefix(18)))
    }
    .padding()
}
