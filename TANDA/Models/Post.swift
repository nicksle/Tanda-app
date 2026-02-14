import Foundation

// MARK: - Post Model
// Represents a social feed post with content, images, likes, and comments.

struct Post: Identifiable, Equatable {
    let id: UUID
    let user: User
    var content: String
    var imageURL: String?  // Optional attached image
    let timestamp: Date
    var visibility: PostVisibility
    var likes: [User]  // Users who liked this post
    var comments: [Comment]
    var circleName: String?  // Optional circle name for updates

    init(
        id: UUID = UUID(),
        user: User,
        content: String,
        imageURL: String? = nil,
        timestamp: Date = Date(),
        visibility: PostVisibility = .public,
        likes: [User] = [],
        comments: [Comment] = [],
        circleName: String? = nil
    ) {
        self.id = id
        self.user = user
        self.content = content
        self.imageURL = imageURL
        self.timestamp = timestamp
        self.visibility = visibility
        self.likes = likes
        self.comments = comments
        self.circleName = circleName
    }

    // Formatted timestamp (e.g., "16h")
    var timeAgo: String {
        let now = Date()
        let interval = now.timeIntervalSince(timestamp)
        let hours = Int(interval / 3600)
        let days = Int(interval / 86400)

        if days > 0 {
            return "\(days)d"
        } else if hours > 0 {
            return "\(hours)h"
        } else {
            let minutes = Int(interval / 60)
            return minutes > 0 ? "\(minutes)m" : "now"
        }
    }

    // Post type description for header
    var actionDescription: String {
        if let circleName = circleName {
            return "shared a payout update for \(circleName)"
        }
        return "posted an update"
    }

    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Post Visibility

enum PostVisibility: String, Codable {
    case `public` = "Public"
    case `private` = "Private"
    case friends = "Friends Only"

    var iconName: String {
        switch self {
        case .public: return "globe"
        case .private: return "lock.fill"
        case .friends: return "person.2.fill"
        }
    }
}
