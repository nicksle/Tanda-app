# TANDA Auth Flow — SwiftUI Implementation Spec

**For:** Claude Code  
**Version:** 1.0  
**Date:** February 2026  
**Scope:** Full authentication flow — Splash → Sign Up → Email Verify → Celebration → Onboarding (4 steps) + Password Login branch

---

## Project Context

This is an iOS 17+ SwiftUI app using the TANDA design system. All tokens, colors, typography, and spacing are pre-defined. **Never use raw values** — always reference the token system.

### File Structure
```
TANDA/
├── TANDAApp.swift          ← App entry, AppState, RootView
├── Tokens/
│   ├── TANDAColors.swift   ← Color primitives + semantic
│   ├── TANDATypography.swift ← Post Grotesk type scale
│   ├── TANDASpacing.swift  ← 2xs through 2xl
│   └── TANDARadius.swift   ← none through full
├── Components/
│   ├── TANDAButton.swift   ← 4 kinds × 5 sizes
│   ├── TANDAInput.swift    ← text, amount, password, search
│   ├── TANDASheetHeader.swift ← title + optional nav actions
│   ├── TANDAButtonDock.swift  ← footer button container
│   ├── TANDADivider.swift  ← horizontal rule with optional label
│   ├── TANDAAuthButton.swift ← Google sign-in (capsule style)
│   └── PageView.swift      ← Head/Body/Foot layout
├── Screens/
│   ├── OnboardingSplash.swift  ← Existing carousel + Get Started
│   ├── SignUpSheet.swift       ← Existing half-sheet (needs refactor)
│   ├── PasswordLoginSheet.swift ← NEW
│   ├── EmailVerificationView.swift ← NEW
│   ├── CelebrationView.swift   ← NEW
│   └── Onboarding/
│       ├── OnboardingContainerView.swift ← NEW (manages 4 steps)
│       ├── CreatePasswordStep.swift ← NEW
│       ├── NameStep.swift          ← NEW
│       ├── LegalStep.swift         ← NEW
│       └── PhotoStep.swift         ← NEW
└── NewComponents/
    ├── TANDAOTPInput.swift       ← NEW
    ├── TANDAProgressBar.swift    ← NEW
    ├── TANDACheckbox.swift       ← NEW
    ├── TANDAAvatarUpload.swift   ← NEW
    └── PasswordStrengthBar.swift ← NEW
```

---

## Token Quick Reference

Use these everywhere. Never hardcode values.

### Colors
```swift
// Primitives
TANDAColors.Purple.p500      // #8B5CF6 — brand primary
TANDAColors.Purple.p600      // #7C3AED — brand secondary / pressed
TANDAColors.Neutral.n0       // #FFFFFF
TANDAColors.Neutral.n100     // #F3F4F6
TANDAColors.Neutral.n400     // #9CA3AF — text/secondary (dark mode)
TANDAColors.Neutral.n500     // #6B7280 — text/tertiary
TANDAColors.Neutral.n700     // #374151 — border (dark mode)
TANDAColors.Neutral.n800     // #1F2937 — surface/secondary (dark mode)
TANDAColors.Neutral.n900     // #111827 — surface/primary (dark mode)

// Semantic
TANDAColors.Brand.primary    // → purple/500
TANDAColors.Brand.secondary  // → purple/600
TANDAColors.border           // → neutral/700 (dark) / neutral/200 (light)

// Feedback
TANDAColors.Feedback.red     // #EF4444
TANDAColors.Feedback.green   // #22C55E
TANDAColors.Feedback.yellow  // #F59E0B

// Secondary palette
TANDAColors.Coral.c500       // #F68896
TANDAColors.DeepPurple.dp500 // #31005C
```

### Typography
```swift
TANDATypography.Display.m    // 28px Bold — splash headlines, celebration
TANDATypography.Heading.l    // 22px Bold — sheet titles, step titles
TANDATypography.Heading.s    // 17px Semibold — SheetHeader component
TANDATypography.Label.l      // 17px Medium — button text (large)
TANDATypography.Label.s      // 13px Medium — input labels, small actions
TANDATypography.Label.xs     // 11px Medium — strength labels, tiny text
TANDATypography.Paragraph.l  // 17px Regular — input text
TANDATypography.Paragraph.m  // 15px Regular — subtitles, descriptions
TANDATypography.Paragraph.s  // 13px Regular — helper text, sign-in links
```

### Spacing
```swift
TANDASpacing.xxs  // 2
TANDASpacing.xs   // 4
TANDASpacing.sm   // 8
TANDASpacing.md   // 16
TANDASpacing.lg   // 24
TANDASpacing.xl   // 32
TANDASpacing.xxl  // 48
```

### Radius
```swift
TANDARadius.sm    // 8
TANDARadius.md    // 12
TANDARadius.lg    // 16
TANDARadius.xl    // 24
TANDARadius.full  // capsule (use Capsule() shape)
```

---

## Existing Components — Usage Patterns

### TANDAButton
```swift
// Primary (always Large, 56px, capsule, purple fill)
TANDAButton("Continue", kind: .primary, isFullWidth: true) { action() }

// With loading state
TANDAButton("Checking...", kind: .primary, isLoading: true, isFullWidth: true) { }

// Disabled (50% opacity)
TANDAButton("Continue", kind: .primary, isDisabled: true, isFullWidth: true) { }

// Tertiary (transparent, used for "Skip" actions)
TANDAButton("Skip for Now", kind: .tertiary) { skip() }
```

### TANDAInput
```swift
// Email
TANDAInput(text: $email, label: "Email", placeholder: "name@example.com")

// Password (has built-in Show/Hide toggle)
TANDAInput(text: $password, type: .password, label: "Password", placeholder: "Enter password")

// With error
TANDAInput(text: $password, type: .password, label: "Password", error: "Incorrect password. Please try again.")
```

### TANDADivider
```swift
TANDADivider(label: "or continue with")
```

### TANDAAuthButton
```swift
// Google (capsule, n800 bg, n700 border)
TANDAAuthButton(provider: .google) { handleGoogleSignIn() }

// Apple — use native SignInWithAppleButton
SignInWithAppleButton(.continue) { request in
    request.requestedScopes = [.email, .fullName]
} onCompletion: { result in }
    .signInWithAppleButtonStyle(.white)
    .frame(height: 56)
    .clipShape(Capsule())
```

### TANDAButtonDock
```swift
// Single button
TANDAButtonDock {
    TANDAButton("Continue", kind: .primary, isFullWidth: true) { }
}

// Two buttons (primary + skip)
TANDAButtonDock {
    TANDAButton("Add Photo", kind: .primary, isFullWidth: true) { }
    TANDAButton("Skip for Now", kind: .tertiary) { }
}
```

---

## NEW Components to Build

### 1. TANDAOTPInput

6-digit code entry for email verification.

```
┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐ ┌────┐
│  1 │ │  2 │ │  3 │ │  4 │ │  5 │ │  _ │  ← cursor in last
└────┘ └────┘ └────┘ └────┘ └────┘ └────┘
```

**Specs:**
- 6 individual digit boxes
- Each box: 44pt wide × 56pt tall (matches input height)
- Background: `TANDAColors.Neutral.n800` (surface/secondary)
- Border: 1px `TANDAColors.Neutral.n700` (border)
- Active/focused box: 2px `TANDAColors.Brand.primary`
- Filled box border: `TANDAColors.Brand.primary`
- Digit font: `TANDATypography.Heading.l` (22px Semibold)
- Digit color: text/primary (white in dark mode)
- Gap between boxes: `TANDASpacing.sm` (8px)
- Corner radius: `TANDARadius.md` (12px)

**Behavior:**
- Hidden `TextField` with `.keyboardType(.numberPad)` drives input
- Auto-advance: typing fills next box
- Backspace: clears current, moves back
- Paste support: accept 6-digit paste
- Binding: `@Binding var code: String`
- Callback: `var onComplete: ((String) -> Void)?` — fires when all 6 entered

**Interface:**
```swift
struct TANDAOTPInput: View {
    @Binding var code: String
    var onComplete: ((String) -> Void)? = nil
}
```

### 2. TANDAProgressBar

Segmented horizontal progress indicator for multi-step flows.

```
[██████] [██████] [▒▒▒▒▒▒] [▒▒▒▒▒▒]
  done     active   empty    empty
```

**Specs:**
- Each segment: flexible width, 4px height
- Gap: `TANDASpacing.xs` (4px)
- Empty color: `TANDAColors.Neutral.n700` (surface/tertiary)
- Completed/active color: `TANDAColors.Brand.primary` (purple/500)
- Corner radius: 2px on each segment
- Active segment: optional shimmer animation (gradient sweep)

**Interface:**
```swift
struct TANDAProgressBar: View {
    let totalSteps: Int
    let currentStep: Int    // 1-indexed
    var showShimmer: Bool = true
}
```

### 3. TANDACheckbox

Toggleable checkbox for legal agreements.

**Specs:**
- Size: 24 × 24pt
- Corner radius: 6px
- Unchecked: 2px border `TANDAColors.Neutral.n700`
- Checked: `TANDAColors.Brand.primary` fill, white checkmark icon
- Checkmark: SF Symbol `checkmark` at 12px, white
- Label: `TANDATypography.Paragraph.s`, `TANDAColors.Neutral.n400` (text/secondary)
- Tappable label text — links in `TANDAColors.Brand.primary` with underline
- Row gap: `TANDASpacing.md` (16px) between checkbox and label
- Vertical padding: `TANDASpacing.md` per row

**Interface:**
```swift
struct TANDACheckbox: View {
    @Binding var isChecked: Bool
    let label: String
    var linkText: String? = nil
    var onLinkTap: (() -> Void)? = nil
}
```

### 4. TANDAAvatarUpload

Circular avatar placeholder with camera/plus badge.

**Specs:**
- Circle: 120 × 120pt, `TANDAColors.Neutral.n800` (surface/secondary)
- Empty state: person icon (SF Symbol `person.fill`), 40pt, `TANDAColors.Neutral.n500`
- Badge: 36 × 36pt circle, bottom-right, `TANDAColors.Brand.primary` fill
- Badge icon: `plus` (empty) or `pencil` (has photo), 16pt, white
- Badge ring: 3px `TANDAColors.Neutral.n900` (surface/primary) border
- Filled state: gradient background `purple/500 → coral/500`, initials in Display/M white
- Center horizontally with `TANDASpacing.xl` (32px) vertical margin

**Interface:**
```swift
struct TANDAAvatarUpload: View {
    let initials: String?       // nil = empty state
    var onTap: (() -> Void)? = nil
}
```

### 5. PasswordStrengthBar

Visual indicator below password input.

**Specs:**
- 3 segments, same layout as progress bar (4px height, flex width)
- Gap: `TANDASpacing.xs` (4px)
- Empty: `TANDAColors.Neutral.n700`
- Weak (1 filled): `TANDAColors.Feedback.red`
- Medium (2 filled): `TANDAColors.Feedback.yellow`
- Strong (3 filled): `TANDAColors.Feedback.green`
- Label below: `TANDATypography.Label.xs`, color matches strength level
- Evaluate: length ≥ 8, has uppercase, has number/symbol

**Interface:**
```swift
struct PasswordStrengthBar: View {
    let password: String

    enum Strength { case none, weak, medium, strong }
}
```

---

## Screen Implementations

### Navigation Architecture

Update `AppState` to support the full flow:

```swift
class AppState: ObservableObject {
    enum AppScreen {
        case onboardingSplash
        case onboarding       // 4-step post-verification setup
        case home
    }

    @Published var currentScreen: AppScreen = .onboardingSplash
    @Published var isOnboardingComplete: Bool = false

    // Auth flow data (passed between screens)
    @Published var authEmail: String = ""
    @Published var isExistingAccount: Bool = false

    func completeOnboarding() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isOnboardingComplete = true
            currentScreen = .home
        }
    }

    func startOnboarding() {
        withAnimation(.easeInOut(duration: 0.4)) {
            currentScreen = .onboarding
        }
    }

    func resetToSplash() {
        withAnimation {
            currentScreen = .onboardingSplash
            isOnboardingComplete = false
            authEmail = ""
        }
    }
}
```

The flow is managed through a combination of sheet presentations (splash → sign-up, splash → password login) and full-screen transitions (AppState screen changes for verification → celebration → onboarding → home).

---

### Screen 1: OnboardingSplash (REFACTOR existing)

**File:** `OnboardingSplash.swift`  
**Presentation:** Root screen, full bleed  
**Layout:** ZStack with gradient + TabView carousel + bottom button

**Changes from current:**
- Add state for `showPasswordLogin` sheet
- Pass email + account check result to determine which sheet to show
- After sign-up sheet dismissal, transition to either Email Verification (new account) or trigger password login (existing)

```swift
struct OnboardingSplash: View {
    @State private var currentSlide = 0
    @State private var showSignUp = false
    @State private var showEmailVerification = false
    @State private var showPasswordLogin = false
    @EnvironmentObject var appState: AppState

    private let slides = [
        "Share Funds for Shared Fun",
        "Save Together, Achieve More",
        "Your Goals, Within Reach"
    ]

    var body: some View {
        ZStack {
            // Full-bleed gradient
            LinearGradient(
                colors: [
                    TANDAColors.Purple.p500,
                    Color(hex: "#A855F7"),
                    TANDAColors.Coral.c500,
                    Color(hex: "#D946EF"),
                    TANDAColors.DeepPurple.dp500
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Carousel
                TabView(selection: $currentSlide) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        SlideView(headline: slides[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))

                // Get Started button (white for gradient contrast)
                VStack {
                    TANDAButton("Get Started", kind: .secondary, isFullWidth: true) {
                        showSignUp = true
                    }
                    // Note: .secondary gives n100 fill on light mode.
                    // May need a custom white button variant for dark-on-gradient.
                    // Alternative: use a plain Button with white Capsule background.
                }
                .padding(.horizontal, TANDASpacing.lg)
                .padding(.bottom, TANDASpacing.md)
            }
        }
        .sheet(isPresented: $showSignUp) {
            SignUpSheet(
                onNewAccount: { email in
                    appState.authEmail = email
                    showSignUp = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showEmailVerification = true
                    }
                },
                onExistingAccount: { email in
                    appState.authEmail = email
                    showSignUp = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        showPasswordLogin = true
                    }
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showPasswordLogin) {
            PasswordLoginSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $showEmailVerification) {
            EmailVerificationView()
        }
    }
}
```

---

### Screen 2: SignUpSheet (REFACTOR existing)

**File:** `SignUpSheet.swift`  
**Presentation:** `.sheet` half-sheet from splash  
**Layout:** VStack inside sheet

**Key design specs:**
| Element | Token | Value |
|---------|-------|-------|
| Title "Create Account" | `Heading.l` | 22px Bold, centered |
| Subtitle | `Paragraph.m` | 15px, text/secondary, centered |
| Email input | `TANDAInput` | label: "Email", placeholder: "name@example.com" |
| Continue button | `TANDAButton` primary | full-width, disabled until valid email |
| Divider | `TANDADivider` | label: "or continue with" |
| Apple button | Native `SignInWithAppleButton` | 56px, capsule, `.white` style |
| Google button | `TANDAAuthButton` | `.google` provider |
| Sign in link | `Paragraph.s` | text/secondary + brand/primary |
| Horizontal padding | `TANDASpacing.lg` | 24px |

**Callbacks:**
```swift
struct SignUpSheet: View {
    @State private var email = ""
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss

    var onNewAccount: ((String) -> Void)?
    var onExistingAccount: ((String) -> Void)?

    private var isValidEmail: Bool {
        email.contains("@") && email.contains(".")
    }
}
```

**Loading state:** When user taps Continue, show `TANDAButton` with `isLoading: true` and text "Checking...". After simulated delay (1.5s for prototype), call either `onNewAccount` or `onExistingAccount`.

**Sign in link behavior:** Tapping "Sign in" should prompt for email first, then go to `PasswordLoginSheet`.

---

### Screen 3: PasswordLoginSheet (NEW)

**File:** `PasswordLoginSheet.swift`  
**Presentation:** `.sheet` half-sheet from splash  
**Layout:** VStack inside sheet

**Key design specs:**
| Element | Token | Value |
|---------|-------|-------|
| Back link | `Paragraph.m` Medium + chevron.left icon | brand/primary color |
| Title "Welcome Back" | `Heading.l` | 22px Bold, centered |
| Email subtitle | `Paragraph.m` | text/secondary, centered |
| Password input | `TANDAInput` | type: `.password`, label: "Password" |
| Forgot link | `Label.s` | brand/primary, right-aligned |
| Sign In button | `TANDAButton` primary | full-width |
| Error state | `TANDAInput` error prop | "Incorrect password. Please try again." |
| Horizontal padding | `TANDASpacing.lg` | 24px |

**Behavior:**
- Back taps dismiss sheet, returning to sign-up
- For prototype: any password works. Optionally show error state on first attempt, success on second
- On success: `dismiss()` then `appState.completeOnboarding()` (skip to home for returning users)

```swift
struct PasswordLoginSheet: View {
    @State private var password = ""
    @State private var loginError: String? = nil
    @State private var isLoading = false
    @State private var attemptCount = 0
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
}
```

---

### Screen 4: EmailVerificationView (NEW)

**File:** `EmailVerificationView.swift`  
**Presentation:** `.fullScreenCover` from splash  
**Layout:** VStack centered, dark background

**Key design specs:**
| Element | Token | Value |
|---------|-------|-------|
| Close button (top-left) | SF `xmark`, 24pt | white, padding: spacing/md from edges |
| Email icon box | 72 × 72pt, radius 20px | purple gradient (p500 → p400), float animation |
| Title "Check Your Email" | `Heading.l` | 22px Bold, white |
| Subtitle "We sent a verification code to" | `Paragraph.m` | text/secondary |
| Email address | `Paragraph.m` Medium | text/primary (white) |
| OTP input | `TANDAOTPInput` | 6 digits |
| Resend text | `Paragraph.s` | text/tertiary + brand/primary for timer/link |
| Verify button | `TANDAButton` primary | full-width, disabled until 6 digits entered |
| Background | `surface/primary` | n900 |

**Behavior:**
- Close button dismisses back to splash
- Resend timer: counts down from 60s, then shows "Resend" as tappable link
- On 6 digits entered: auto-enable Verify button
- On verify: simulate loading (1s), then transition to CelebrationView
- Use `TANDAButtonDock` for bottom Verify button

```swift
struct EmailVerificationView: View {
    @State private var otpCode = ""
    @State private var resendCountdown = 60
    @State private var isVerifying = false
    @State private var showCelebration = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
}
```

---

### Screen 5: CelebrationView (NEW)

**File:** `CelebrationView.swift`  
**Presentation:** Full screen (navigate from verification, or use `.fullScreenCover`)  
**Layout:** Centered content + bottom button

**Key design specs:**
| Element | Token | Value |
|---------|-------|-------|
| Check circle | 100 × 100pt | brand/primary fill, radius/full |
| Check icon | SF `checkmark`, 40pt | white |
| Glow ring | inset -12px | brand/primary at 20% opacity |
| Title "You're In!" | `Display.m` | 28px Bold, white |
| Subtitle | `Paragraph.m` | text/secondary |
| Continue button | `TANDAButton` primary | full-width |
| Background | `surface/primary` | n900 |

**Behavior:**
- Entry animation: scale-up check circle + confetti-like particle effect (optional, nice-to-have)
- Continue button: `appState.startOnboarding()` → transition to onboarding container
- Auto-advance after 3 seconds is optional

```swift
struct CelebrationView: View {
    @State private var animate = false
    @EnvironmentObject var appState: AppState
}
```

---

### Screen 6: OnboardingContainerView (NEW)

**File:** `OnboardingContainerView.swift`  
**Presentation:** Full screen via AppState `.onboarding`  
**Layout:** VStack with progress bar + step content + bottom button dock

This is the parent view that manages 4 steps via a `@State var currentStep: Int`.

**Structure:**
```swift
struct OnboardingContainerView: View {
    @State private var currentStep = 1
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var agreedToTerms = false
    @State private var agreedToPrivacy = false
    @State private var hasPhoto = false
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 0) {
            // Progress header: back button + TANDAProgressBar
            HStack(spacing: TANDASpacing.md) {
                Button { goBack() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
                }

                TANDAProgressBar(totalSteps: 4, currentStep: currentStep)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, TANDASpacing.md)

            // Step content (switches on currentStep)
            // ...

            Spacer()

            // TANDAButtonDock with Continue
            TANDAButtonDock { ... }
        }
        .background(TANDAColors.Neutral.n900)
    }
}
```

**Navigation:** Back button on step 1 could dismiss/return to celebration or do nothing. Steps 2-4 go back one step. Continue advances. Step 4 calls `appState.completeOnboarding()`.

---

### Step 1: CreatePasswordStep

**Key design specs:**
| Element | Token | Value |
|---------|-------|-------|
| Title "Create a Password" | `Heading.l` | 22px Bold |
| Subtitle | `Paragraph.m` | text/secondary |
| Password input | `TANDAInput` type: `.password` | label: "Password" |
| Strength bar | `PasswordStrengthBar` | below password input |
| Confirm input | `TANDAInput` type: `.password` | label: "Confirm Password" |
| Spacing above inputs | `TANDASpacing.lg` | 24px |

**Validation:** Continue enabled when password.count ≥ 8 AND password == confirmPassword.

---

### Step 2: NameStep

**Key design specs:**
| Element | Token | Value |
|---------|-------|-------|
| Title "What's Your Name?" | `Heading.l` | 22px Bold |
| Subtitle | `Paragraph.m` | text/secondary |
| First Name input | `TANDAInput` | label: "First Name" |
| Last Name input | `TANDAInput` | label: "Last Name" |

**Validation:** Continue enabled when both fields non-empty.

---

### Step 3: LegalStep

**Key design specs:**
| Element | Token | Value |
|---------|-------|-------|
| Title "Terms & Privacy" | `Heading.l` | 22px Bold |
| Subtitle | `Paragraph.m` | text/secondary |
| Terms checkbox | `TANDACheckbox` | linkText: "Terms of Service" |
| Privacy checkbox | `TANDACheckbox` | linkText: "Privacy Policy" |

**Validation:** Continue enabled when both checkboxes checked.

---

### Step 4: PhotoStep

**Key design specs:**
| Element | Token | Value |
|---------|-------|-------|
| Title "Add a Photo" | `Heading.l` | 22px Bold |
| Subtitle | `Paragraph.m` | text/secondary |
| Avatar | `TANDAAvatarUpload` | initials: nil (empty) or "SJ" (filled) |
| Add Photo button | `TANDAButton` primary | full-width |
| Skip button | `TANDAButton` tertiary | "Skip for Now" |

**Behavior:**
- "Add Photo" taps the avatar (for prototype, just toggle to filled state with initials)
- "Skip for Now" proceeds without photo
- Both paths: `appState.completeOnboarding()` → Home

---

## Summary: New Components Needed

| Component | File | Priority |
|-----------|------|----------|
| `TANDAOTPInput` | TANDAOTPInput.swift | Required — Email Verify screen |
| `TANDAProgressBar` | TANDAProgressBar.swift | Required — Onboarding container |
| `TANDACheckbox` | TANDACheckbox.swift | Required — Legal step |
| `TANDAAvatarUpload` | TANDAAvatarUpload.swift | Required — Photo step |
| `PasswordStrengthBar` | PasswordStrengthBar.swift | Required — Password step |

## Summary: Screens to Build/Modify

| Screen | File | Status |
|--------|------|--------|
| `OnboardingSplash` | OnboardingSplash.swift | REFACTOR — add sheet routing |
| `SignUpSheet` | SignUpSheet.swift | REFACTOR — add callbacks, loading |
| `PasswordLoginSheet` | PasswordLoginSheet.swift | NEW |
| `EmailVerificationView` | EmailVerificationView.swift | NEW |
| `CelebrationView` | CelebrationView.swift | NEW |
| `OnboardingContainerView` | OnboardingContainerView.swift | NEW |
| `CreatePasswordStep` | CreatePasswordStep.swift | NEW |
| `NameStep` | NameStep.swift | NEW |
| `LegalStep` | LegalStep.swift | NEW |
| `PhotoStep` | PhotoStep.swift | NEW |
| `AppState` | TANDAApp.swift | REFACTOR — add auth state |

---

## Implementation Order

Build in this sequence to maintain a working app at each step:

1. **New components first** — TANDAOTPInput, TANDAProgressBar, TANDACheckbox, TANDAAvatarUpload, PasswordStrengthBar
2. **AppState updates** — Add authEmail, isExistingAccount, startOnboarding()
3. **SignUpSheet refactor** — Add callbacks, loading state, keep existing working
4. **PasswordLoginSheet** — New, presented from splash
5. **EmailVerificationView** — New, uses TANDAOTPInput
6. **CelebrationView** — New, simple transition screen
7. **Onboarding steps** — Container + 4 step views
8. **OnboardingSplash refactor** — Wire up sheet routing to connect everything
9. **RootView update** — Add `.onboarding` case routing to OnboardingContainerView

---

## Design Rules

- **Dark mode only** for this flow — all screens use n900 background, white text
- **All buttons are full-width** in this flow (`.isFullWidth: true`)
- **Primary buttons are always Large** (56px) — this is enforced by TANDAButton
- **Sheet horizontal padding** is `TANDASpacing.lg` (24px)
- **Input fields** are 56px tall, 12px radius, 1px border (2px when focused/error)
- **Never use raw hex colors** — always reference TANDAColors
- **Never use raw font sizes** — always reference TANDATypography
- **Never use raw spacing values** — always reference TANDASpacing
- **Capsule shape** for all buttons (TANDAButton handles this automatically)
- **Animations** use `.easeInOut` with 0.3–0.5s duration for transitions
