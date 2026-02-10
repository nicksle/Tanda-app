# TANDA Project Cleanup — Step 0

Before building new auth flow screens, clean up the existing codebase so everything that follows is built on a solid foundation.

---

## 1. Split TANDAApp.swift into Separate Files

**Problem:** TANDAApp.swift is a monolith (~300+ lines) containing tokens, app state, navigation, placeholder screens, mock data, and utility extensions. Every file in the project depends on tokens buried inside it.

**Action:** Extract into individual files:

```
Tokens/
├── TANDAColors.swift        ← All color primitives + semantic aliases
├── TANDATypography.swift    ← Post Grotesk type scale (Display, Heading, Label, Paragraph)
├── TANDASpacing.swift       ← xxs(2) through xxl(48)
└── TANDARadius.swift        ← none through full

App/
├── TANDAApp.swift           ← Only @main struct + WindowGroup
├── AppState.swift           ← ObservableObject with navigation enum + published state
└── RootView.swift           ← Switch statement routing on AppState.currentScreen

Utilities/
├── ColorHex.swift           ← Color(hex:) extension
└── MockData.swift           ← MockCircle, MockTransaction, sample data
```

**Why it matters:** Every future screen and component imports tokens. Isolated files make them easy to reference, edit, and hand to Claude Code without noise.

---

## 2. Use TANDASheetHeader and TANDAButtonDock in Existing Screens

**Problem:** `TANDASheetHeader` and `TANDAButtonDock` are fully built components that no screen actually uses. SignUpSheet hardcodes its own title/subtitle layout and manually positions its Continue button with raw padding.

**Action:** Refactor SignUpSheet to use both components:

```swift
// Before (current)
Text("Create Account")
    .font(TANDATypography.Heading.l)
    .padding(.bottom, 6)
Text("Enter your email to get started")
    .font(TANDATypography.Paragraph.m)
    .foregroundStyle(.secondary)
    .padding(.bottom, 24)

// After (using TANDASheetHeader)
TANDASheetHeader(
    title: "Create Account",
    subtitle: "Enter your email to get started"
)
```

**Apply this pattern to every sheet going forward** — PasswordLoginSheet, EmailVerification, Onboarding steps. This keeps sheet headers visually consistent automatically.

---

## 3. Remove Placeholder Screens

**Problem:** `OnboardingFlow` and `HomeScreen` are temporary stubs living inside TANDAApp.swift. Once we build the real implementations, these create confusion about which file is canonical.

**Action:**
- Delete the placeholder `OnboardingFlow` struct
- Delete the placeholder `HomeScreen` struct (and its temp components: `StatCard`, `CircleRow`, `TransactionRow`)
- Have RootView point to the real implementations, even if they're still incomplete
- Keep `MockData` in its own file for demo purposes

---

## 4. Standardize Screen Layout Patterns

**Problem:** Screens are inconsistent about structure. Some use `PageView`, some use raw VStacks with manual padding. No consistent approach to bottom button placement or safe area handling.

**Action:** Establish two standard skeletons:

### Full-Screen Views (EmailVerification, Celebration, Onboarding Steps)
```swift
VStack(spacing: 0) {
    // Top navigation (progress bar, close button, or nothing)
    
    // Scrollable content
    ScrollView {
        // ...
    }
    
    // Pinned bottom actions
    TANDAButtonDock {
        TANDAButton("Continue", kind: .primary, isFullWidth: true) { }
    }
}
.background(TANDAColors.Neutral.n900)
```

### Sheet Views (SignUp, PasswordLogin)
```swift
VStack(spacing: 0) {
    TANDASheetHeader(title: "...", subtitle: "...")
    
    // Sheet content
    VStack(spacing: TANDASpacing.md) {
        // inputs, dividers, auth buttons...
    }
    .padding(.horizontal, TANDASpacing.lg)
    
    Spacer()
    
    // Bottom actions
    TANDAButtonDock {
        TANDAButton("Continue", kind: .primary, isFullWidth: true) { }
    }
}
```

Every screen should use `TANDAButtonDock` for bottom buttons — it handles safe area padding (34px) and consistent spacing automatically.

---

## What to Leave Alone (For Now)

- **Deep folder nesting** (Features/Onboarding/, Features/Home/) — not needed yet with only a handful of screens. Let this happen naturally as Sprint 2-3 screens get added.
- **PageView component** — works fine for content-heavy screens like Home. Not needed for auth flow sheets, which are simpler.
- **TANDAAuthButton** — works as-is for Google. Apple uses native `SignInWithAppleButton` which is correct.

---

## Suggested Order

1. Extract tokens into separate files (TANDAColors, TANDATypography, TANDASpacing, TANDARadius)
2. Extract AppState and RootView into own files
3. Extract MockData and Color(hex:) extension
4. Refactor SignUpSheet to use TANDASheetHeader + TANDAButtonDock
5. Delete placeholder screens
6. Verify everything still builds and runs
7. Then proceed with new screen development
