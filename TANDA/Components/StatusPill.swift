import SwiftUI

// MARK: - Status Pill
// Color-coded badge component showing circle status.
// Used in toolbar to indicate: Starting Soon, In Progress, or Available.

struct StatusPill: View {
    let status: CircleStatus

    var body: some View {
        Text(status.rawValue)
            .font(.system(size: 13, weight: .semibold))
            .foregroundStyle(status.color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(status.backgroundColor)
            .clipShape(Capsule())
    }
}

#Preview("Status Pills") {
    VStack(spacing: TANDASpacing.md) {
        StatusPill(status: .available)
        StatusPill(status: .startingSoon)
        StatusPill(status: .inProgress)
    }
    .padding()
}
