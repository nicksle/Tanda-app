import SwiftUI

// MARK: - Step 1: Legal Name

struct KYCNameStep: View {
    @Binding var firstName: String
    @Binding var lastName: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TANDASpacing.lg) {
                SheetIntro(
                    title: "Legal Name",
                    subtitle: "Please confirm your legal name as it appears on your government-issued ID."
                )

                VStack(spacing: TANDASpacing.md) {
                    Input(
                        text: $firstName,
                        label: "Legal First Name",
                        placeholder: "John"
                    )

                    Input(
                        text: $lastName,
                        label: "Legal Last Name",
                        placeholder: "Doe"
                    )
                }
            }
            .padding(.horizontal, TANDASpacing.lg)
            .padding(.bottom, TANDASpacing.xl)
        }
    }
}

// MARK: - Step 2: Address

struct AddressStep: View {
    @Binding var streetAddress: String
    @Binding var city: String
    @Binding var state: String
    @Binding var zipCode: String

    @State private var searchQuery = ""
    @State private var showSuggestions = false
    @FocusState private var isSearchFocused: Bool

    private let mockAddresses = [
        MockAddress(full: "123 Market St, San Francisco, CA 94103", street: "123 Market St", city: "San Francisco", state: "CA", zip: "94103"),
        MockAddress(full: "456 Mission St, San Francisco, CA 94105", street: "456 Mission St", city: "San Francisco", state: "CA", zip: "94105"),
        MockAddress(full: "789 Howard St, San Francisco, CA 94107", street: "789 Howard St", city: "San Francisco", state: "CA", zip: "94107"),
        MockAddress(full: "321 Valencia St, San Francisco, CA 94110", street: "321 Valencia St", city: "San Francisco", state: "CA", zip: "94110"),
        MockAddress(full: "654 Folsom St, San Francisco, CA 94107", street: "654 Folsom St", city: "San Francisco", state: "CA", zip: "94107")
    ]

    private var filteredAddresses: [MockAddress] {
        if searchQuery.isEmpty {
            return mockAddresses
        }
        return mockAddresses.filter { $0.full.lowercased().contains(searchQuery.lowercased()) }
    }

    private var hasCompleteAddress: Bool {
        !streetAddress.isEmpty && !city.isEmpty && !state.isEmpty && !zipCode.isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TANDASpacing.lg) {
                SheetIntro(
                    title: "Residential Address",
                    subtitle: "Enter your current residential address for identity verification."
                )

                VStack(spacing: TANDASpacing.md) {
                    // Search input
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Search Address")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(TANDAColors.Text.primary)

                        HStack(spacing: TANDASpacing.sm) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16))
                                .foregroundStyle(TANDAColors.Text.tertiary)

                            TextField("Start typing your address...", text: $searchQuery)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundStyle(TANDAColors.Text.primary)
                                .focused($isSearchFocused)
                                .onChange(of: searchQuery) { _, _ in
                                    showSuggestions = !searchQuery.isEmpty
                                }
                        }
                        .padding(TANDASpacing.md)
                        .background(TANDAColors.Surface.primary)
                        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
                    }

                    // Address suggestions dropdown
                    if showSuggestions && !filteredAddresses.isEmpty {
                        VStack(spacing: 0) {
                            ForEach(filteredAddresses) { address in
                                Button {
                                    selectAddress(address)
                                } label: {
                                    HStack(spacing: TANDASpacing.sm) {
                                        Image(systemName: "mappin.circle.fill")
                                            .font(.system(size: 20))
                                            .foregroundStyle(TANDAColors.Purple.p500)

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(address.street)
                                                .font(.system(size: 15, weight: .medium))
                                                .foregroundStyle(TANDAColors.Text.primary)

                                            Text("\(address.city), \(address.state) \(address.zip)")
                                                .font(.system(size: 13, weight: .regular))
                                                .foregroundStyle(TANDAColors.Text.secondary)
                                        }

                                        Spacer()
                                    }
                                    .padding(TANDASpacing.md)
                                    .background(TANDAColors.Surface.primary)
                                }
                                .buttonStyle(.plain)

                                if address.id != filteredAddresses.last?.id {
                                    Divider()
                                        .padding(.leading, 48)
                                }
                            }
                        }
                        .background(TANDAColors.Surface.primary)
                        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
                        .overlay(
                            RoundedRectangle(cornerRadius: TANDARadius.md)
                                .stroke(TANDAColors.Neutral.n300, lineWidth: 1)
                        )
                    }

                    // Selected address display
                    if hasCompleteAddress {
                        VStack(alignment: .leading, spacing: TANDASpacing.sm) {
                            HStack {
                                Text("Selected Address")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(TANDAColors.Text.primary)

                                Spacer()

                                Button {
                                    clearAddress()
                                } label: {
                                    Text("Change")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundStyle(TANDAColors.Purple.p500)
                                }
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(streetAddress)
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundStyle(TANDAColors.Text.primary)

                                Text("\(city), \(state) \(zipCode)")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(TANDAColors.Text.secondary)
                            }
                            .padding(TANDASpacing.md)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(TANDAColors.Neutral.n50)
                            .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
                        }
                    }
                }
            }
            .padding(.horizontal, TANDASpacing.lg)
            .padding(.bottom, TANDASpacing.xl)
        }
    }

    private func selectAddress(_ address: MockAddress) {
        streetAddress = address.street
        city = address.city
        state = address.state
        zipCode = address.zip
        searchQuery = address.full
        showSuggestions = false
        isSearchFocused = false
    }

    private func clearAddress() {
        streetAddress = ""
        city = ""
        state = ""
        zipCode = ""
        searchQuery = ""
    }
}

// Mock address model for simulated autocomplete
private struct MockAddress: Identifiable {
    let id = UUID()
    let full: String
    let street: String
    let city: String
    let state: String
    let zip: String
}

// MARK: - Step 3: Social Security Number

struct SSNStep: View {
    @Binding var ssn: String

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TANDASpacing.lg) {
                SheetIntro(
                    title: "Social Security Number",
                    subtitle: "We need your SSN to verify your identity and comply with financial regulations. Your information is encrypted and secure."
                )

                VStack(spacing: TANDASpacing.md) {
                    Input(
                        text: $ssn,
                        type: .ssn,
                        label: "Social Security Number",
                        placeholder: "XXX-XX-XXXX"
                    )

                    // Security notice
                    HStack(alignment: .top, spacing: TANDASpacing.sm) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(TANDAColors.Purple.p500)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your SSN is secure")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(TANDAColors.Text.primary)

                            Text("We use 256-bit encryption to protect your personal information.")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(TANDAColors.Text.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(TANDASpacing.md)
                    .background(TANDAColors.Purple.p100)
                    .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
                }
            }
            .padding(.horizontal, TANDASpacing.lg)
            .padding(.bottom, TANDASpacing.xl)
        }
    }
}

// MARK: - Step 4: Date of Birth

struct DateOfBirthStep: View {
    @Binding var dateOfBirth: Date

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TANDASpacing.lg) {
                SheetIntro(
                    title: "Date of Birth",
                    subtitle: "Please provide your date of birth to verify your age and identity."
                )

                VStack(spacing: TANDASpacing.md) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date of Birth")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(TANDAColors.Text.primary)

                        DatePicker(
                            "",
                            selection: $dateOfBirth,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(TANDASpacing.md)
                        .background(TANDAColors.Surface.primary)
                        .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
                    }
                }
            }
            .padding(.horizontal, TANDASpacing.lg)
            .padding(.bottom, TANDASpacing.xl)
        }
    }
}

// MARK: - Step 5: Government ID Upload

struct GovernmentIDStep: View {
    @Binding var idType: String
    @Binding var frontImage: UIImage?
    @Binding var backImage: UIImage?

    private let idTypes = ["Driver's License", "Passport", "State ID"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TANDASpacing.lg) {
                SheetIntro(
                    title: "Government ID",
                    subtitle: "Upload a photo of your government-issued ID. Make sure all information is clearly visible."
                )

                VStack(spacing: TANDASpacing.md) {
                    // ID Type Picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("ID Type")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(TANDAColors.Text.primary)

                        Menu {
                            ForEach(idTypes, id: \.self) { type in
                                Button(type) {
                                    idType = type
                                }
                            }
                        } label: {
                            HStack {
                                Text(idType.isEmpty ? "Select ID Type" : idType)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(idType.isEmpty ? TANDAColors.Text.tertiary : TANDAColors.Text.primary)

                                Spacer()

                                Image(systemName: "chevron.down")
                                    .font(.system(size: 14))
                                    .foregroundStyle(TANDAColors.Text.tertiary)
                            }
                            .padding(TANDASpacing.md)
                            .background(TANDAColors.Surface.primary)
                            .clipShape(RoundedRectangle(cornerRadius: TANDARadius.md))
                        }
                    }

                    // Front of ID
                    ImageUploadCard(
                        title: "Front of ID",
                        subtitle: "Upload a clear photo of the front of your ID",
                        image: $frontImage
                    )

                    // Back of ID (only for Driver's License and State ID)
                    if idType != "Passport" && !idType.isEmpty {
                        ImageUploadCard(
                            title: "Back of ID",
                            subtitle: "Upload a clear photo of the back of your ID",
                            image: $backImage
                        )
                    }
                }
            }
            .padding(.horizontal, TANDASpacing.lg)
            .padding(.bottom, TANDASpacing.xl)
        }
    }
}

// MARK: - Step 6: Selfie Verification

struct SelfieVerificationStep: View {
    @Binding var selfieImage: UIImage?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TANDASpacing.lg) {
                SheetIntro(
                    title: "Verify It's You",
                    subtitle: "Take a clear selfie to confirm your identity. Make sure your face is well-lit and clearly visible."
                )

                VStack(spacing: TANDASpacing.md) {
                    // Selfie tips
                    VStack(alignment: .leading, spacing: TANDASpacing.sm) {
                        Text("Tips for a good selfie:")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(TANDAColors.Text.primary)

                        TipRow(icon: "sun.max.fill", text: "Find good lighting")
                        TipRow(icon: "face.smiling", text: "Look directly at the camera")
                        TipRow(icon: "eyeglasses", text: "Remove glasses if possible")
                        TipRow(icon: "checkmark.circle.fill", text: "Make sure your face is clearly visible")
                    }
                    .padding(TANDASpacing.md)
                    .background(TANDAColors.Neutral.n50)
                    .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))

                    // Selfie upload
                    ImageUploadCard(
                        title: "Your Selfie",
                        subtitle: "Take a photo of yourself",
                        image: $selfieImage
                    )
                }
            }
            .padding(.horizontal, TANDASpacing.lg)
            .padding(.bottom, TANDASpacing.xl)
        }
    }
}

// MARK: - Step 7: Review & Submit

struct ReviewSubmitStep: View {
    let firstName: String
    let lastName: String
    let ssn: String
    let dateOfBirth: Date
    let streetAddress: String
    let city: String
    let state: String
    let zipCode: String
    let idType: String
    let frontImage: UIImage?
    let backImage: UIImage?
    let selfieImage: UIImage?

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }

    private var maskedSSN: String {
        guard ssn.count >= 4 else { return "***-**-****" }
        let lastFour = ssn.suffix(4)
        return "***-**-\(lastFour)"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: TANDASpacing.lg) {
                SheetIntro(
                    title: "Review Your Information",
                    subtitle: "Please review your information before submitting. Your verification will be processed within 1-2 business days."
                )

                VStack(spacing: TANDASpacing.md) {
                    // Personal Information Section
                    ReviewSection(title: "Personal Information") {
                        ReviewItem(label: "Legal Name", value: "\(firstName) \(lastName)")
                        ReviewItem(label: "Social Security Number", value: maskedSSN)
                        ReviewItem(label: "Date of Birth", value: dateFormatter.string(from: dateOfBirth))
                        ReviewItem(label: "Address", value: "\(streetAddress)\n\(city), \(state) \(zipCode)")
                    }

                    // ID Information Section
                    ReviewSection(title: "Government ID") {
                        ReviewItem(label: "ID Type", value: idType)
                        if frontImage != nil {
                            ReviewItem(label: "Front of ID", value: "✓ Uploaded")
                        }
                        if backImage != nil {
                            ReviewItem(label: "Back of ID", value: "✓ Uploaded")
                        }
                    }

                    // Selfie Section
                    ReviewSection(title: "Identity Verification") {
                        if selfieImage != nil {
                            ReviewItem(label: "Selfie", value: "✓ Uploaded")
                        }
                    }

                    // Privacy notice
                    HStack(alignment: .top, spacing: TANDASpacing.sm) {
                        Image(systemName: "lock.shield.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(TANDAColors.Purple.p500)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Your information is secure")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(TANDAColors.Text.primary)

                            Text("We use bank-level encryption to protect your personal data and will never share it without your permission.")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(TANDAColors.Text.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(TANDASpacing.md)
                    .background(TANDAColors.Purple.p100)
                    .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
                }
            }
            .padding(.horizontal, TANDASpacing.lg)
            .padding(.bottom, TANDASpacing.xl)
        }
    }
}

// MARK: - Supporting Views

private struct TipRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: TANDASpacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(TANDAColors.Purple.p500)
                .frame(width: 20)

            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(TANDAColors.Text.secondary)
        }
    }
}

private struct ReviewSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: TANDASpacing.sm) {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(TANDAColors.Text.primary)

            VStack(alignment: .leading, spacing: TANDASpacing.sm) {
                content
            }
            .padding(TANDASpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(TANDAColors.Surface.primary)
            .clipShape(RoundedRectangle(cornerRadius: TANDARadius.lg))
        }
    }
}

private struct ReviewItem: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(TANDAColors.Text.tertiary)

            Text(value)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(TANDAColors.Text.primary)
        }
    }
}

// MARK: - Preview

#Preview("KYC Name Step") {
    @Previewable @State var firstName = "John"
    @Previewable @State var lastName = "Doe"

    KYCNameStep(firstName: $firstName, lastName: $lastName)
}

#Preview("Address Step") {
    @Previewable @State var streetAddress = ""
    @Previewable @State var city = ""
    @Previewable @State var state = ""
    @Previewable @State var zipCode = ""

    AddressStep(
        streetAddress: $streetAddress,
        city: $city,
        state: $state,
        zipCode: $zipCode
    )
}

#Preview("SSN Step") {
    @Previewable @State var ssn = ""

    SSNStep(ssn: $ssn)
}

#Preview("Date of Birth Step") {
    @Previewable @State var dateOfBirth = Date()

    DateOfBirthStep(dateOfBirth: $dateOfBirth)
}

#Preview("Government ID Step") {
    @Previewable @State var idType = ""
    @Previewable @State var frontImage: UIImage? = nil
    @Previewable @State var backImage: UIImage? = nil

    GovernmentIDStep(
        idType: $idType,
        frontImage: $frontImage,
        backImage: $backImage
    )
}

#Preview("Selfie Step") {
    @Previewable @State var selfieImage: UIImage? = nil

    SelfieVerificationStep(selfieImage: $selfieImage)
}

#Preview("Review Step") {
    ReviewSubmitStep(
        firstName: "John",
        lastName: "Doe",
        ssn: "123456789",
        dateOfBirth: Date(),
        streetAddress: "123 Main St",
        city: "San Francisco",
        state: "CA",
        zipCode: "94102",
        idType: "Driver's License",
        frontImage: UIImage(),
        backImage: UIImage(),
        selfieImage: UIImage()
    )
}
