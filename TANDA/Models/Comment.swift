import Foundation

// MARK: - Comment Model
// Represents a comment on a post.

struct Comment: Identifiable, Equatable {
    let id: UUID
    let user: User
    var text: String
    let timestamp: Date

    init(
        id: UUID = UUID(),
        user: User,
        text: String,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.user = user
        self.text = text
        self.timestamp = timestamp
    }

    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id
    }
}
