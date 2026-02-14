import SwiftUI

// MARK: - PostCard
// Complete post component combining header, content, actions, and comments.

struct PostCard: View {
    let post: Post
    let currentUser: User
    let onLikeTap: () -> Void
    let onCommentTap: () -> Void

    private var isLiked: Bool {
        post.likes.contains(where: { $0.id == currentUser.id })
    }

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.sm + 4) {  // 12px
            // Header: User info, time, visibility
            PostHeader(post: post)

            // Content: Text + optional image
            PostContent(
                content: post.content,
                imageURL: post.imageURL
            )

            // Actions: Like + Comment buttons
            PostActions(
                likes: post.likes,
                isLiked: isLiked,
                onLikeTap: onLikeTap,
                onCommentTap: onCommentTap
            )

            // Comments section
            if !post.comments.isEmpty || true {  // Always show to allow adding comments
                CommentSection(
                    comments: post.comments,
                    onAddCommentTap: onCommentTap
                )
            }
        }
        .padding(.horizontal, TANDASpacing.lg)  // 24px
        .padding(.vertical, TANDASpacing.md)  // 16px
        .background(TANDAColors.Neutral.n0)
    }
}

#Preview("Post Card") {
    let users = [
        User(name: "Nick Le"),
        User(name: "Trevor Pels"),
        User(name: "Alice Johnson"),
        User(name: "Bob Smith"),
        User(name: "Charlie Brown"),
        User(name: "Diana Prince"),
        User(name: "Eve Taylor")
    ]

    let post1 = Post(
        user: users[0],
        content: "I was able to get some new wheels for my bike!!",
        imageURL: "bike_image.jpg",
        likes: Array(users.suffix(5)),
        comments: [
            Comment(user: users[0], text: "Can't wait to get that schmoney. And more text to make this a two line comment"),
            Comment(user: users[1], text: "Wow nice!")
        ],
        circleName: "Bike Parts"
    )

    let post2 = Post(
        user: users[1],
        content: "has started! Trevor Pels, Nick Le, Angelo Anders and Christine Quinta are making contributions",
        likes: [],
        comments: [],
        circleName: "Urban Explorers"
    )

    ScrollView {
        VStack(spacing: 0) {
            PostCard(
                post: post1,
                currentUser: users[2],
                onLikeTap: {},
                onCommentTap: {}
            )

            Divider()
                .background(TANDAColors.Brand.white3)

            PostCard(
                post: post2,
                currentUser: users[2],
                onLikeTap: {},
                onCommentTap: {}
            )
        }
    }
    .frame(width: 393)
    .background(TANDAColors.Neutral.n0)
}
