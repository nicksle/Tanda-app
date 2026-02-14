import SwiftUI

// MARK: - User Model
// Represents a user in the TANDA social feed.

struct User: Identifiable, Equatable {
    let id: UUID
    let name: String
    let avatarURL: String?  // Optional image URL

    init(id: UUID = UUID(), name: String, avatarURL: String? = nil) {
        self.id = id
        self.name = name
        self.avatarURL = avatarURL
    }

    // Generate initials for avatar placeholder
    var initials: String {
        let components = name.split(separator: " ")
        if components.count >= 2 {
            let first = components[0].prefix(1).uppercased()
            let last = components[1].prefix(1).uppercased()
            return "\(first)\(last)"
        } else if let first = components.first {
            return String(first.prefix(1).uppercased())
        }
        return "?"
    }

    // Avatar background color based on name hash
    var avatarColor: Color {
        let colors: [Color] = [
            TANDAColors.Purple.p400,
            TANDAColors.Secondary.coral,
            TANDAColors.Secondary.violet,
            TANDAColors.Secondary.magenta,
            TANDAColors.Secondary.periwinkle,
            TANDAColors.Feedback.blue
        ]
        let hash = abs(name.hashValue)
        return colors[hash % colors.count]
    }
}
