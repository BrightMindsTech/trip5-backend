import SwiftUI

struct ServiceSelectionView: View {
    @ObservedObject var viewModel: OrderViewModel
    
    @State private var showPrivateOption = false
    @State private var showAirportOption = false
    @State private var showInstantOption = false
    @State private var instantDescription = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Text(L10n.chooseService)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            
            ScrollView {
                VStack(spacing: 12) {
                    ServiceCard(
                        title: L10n.serviceBasic,
                        subtitle: L10n.serviceBasicDesc,
                        price: 5,
                        isSelected: viewModel.service?.isBasic == true
                    ) {
                        viewModel.service = .basic
                        showPrivateOption = false
                        showAirportOption = false
                        showInstantOption = false
                    }
                    
                    ServiceCard(
                        title: L10n.servicePrivate,
                        subtitle: L10n.servicePrivateDesc,
                        price: 15,
                        isSelected: viewModel.service?.isPrivate == true
                    ) {
                        showPrivateOption = true
                        showAirportOption = false
                        showInstantOption = false
                    }
                    if showPrivateOption {
                        HStack(spacing: 12) {
                            SubOptionButton(title: L10n.alone, isSelected: viewModel.service?.isAlone == true) {
                                viewModel.service = .private(alone: true)
                            }
                            SubOptionButton(title: L10n.family, isSelected: viewModel.service?.isFamily == true) {
                                viewModel.service = .private(alone: false)
                            }
                        }
                        .padding(.leading, 20)
                    }
                    
                    if let route = viewModel.route {
                        ServiceCard(
                            title: L10n.serviceAirport,
                            subtitle: L10n.serviceAirportDesc,
                            price: route == .irbidToAmman ? 25 : 15,
                            isSelected: viewModel.service?.isAirport == true
                        ) {
                            showAirportOption = true
                            showPrivateOption = false
                            showInstantOption = false
                        }
                        if showAirportOption {
                            HStack(spacing: 12) {
                                SubOptionButton(title: L10n.toAirport, isSelected: viewModel.service?.isToAirport == true) {
                                    viewModel.service = .airport(toAirport: true)
                                }
                                SubOptionButton(title: L10n.fromAirport, isSelected: viewModel.service?.isFromAirport == true) {
                                    viewModel.service = .airport(toAirport: false)
                                }
                            }
                            .padding(.leading, 20)
                        }
                    }
                    
                    ServiceCard(
                        title: L10n.serviceInstant,
                        subtitle: L10n.serviceInstantDesc,
                        price: nil,
                        isSelected: viewModel.service?.isInstant == true
                    ) {
                        showInstantOption = true
                        showPrivateOption = false
                        showAirportOption = false
                    }
                    if showInstantOption {
                        TextField(L10n.enterDescription, text: $instantDescription, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3...6)
                            .padding(.horizontal, 20)
                            .onChange(of: instantDescription) { _, newValue in
                                viewModel.service = .instant(description: newValue)
                            }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button {
                viewModel.goNext()
            } label: {
                Text(L10n.next)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.borderedProminent)
            .disabled(!viewModel.canProceedFromService)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
}

private extension Service {
    var isBasic: Bool { if case .basic = self { return true }; return false }
    var isPrivate: Bool { if case .private = self { return true }; return false }
    var isAirport: Bool { if case .airport = self { return true }; return false }
    var isInstant: Bool { if case .instant = self { return true }; return false }
    var isAlone: Bool { if case .private(let a) = self { return a }; return false }
    var isFamily: Bool { if case .private(let a) = self { return !a }; return false }
    var isToAirport: Bool { if case .airport(let t) = self { return t }; return false }
    var isFromAirport: Bool { if case .airport(let t) = self { return !t }; return false }
}

struct ServiceCard: View {
    let title: String
    let subtitle: String
    let price: Double?
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                if let price = price {
                    Text("\(Int(price)) \(L10n.jod)")
                        .font(.headline)
                        .foregroundColor(isSelected ? .white : .accentColor)
                }
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.accentColor : Color(.systemGray6))
            )
        }
        .buttonStyle(.plain)
    }
}

struct SubOptionButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(isSelected ? Color.accentColor : Color(.systemGray5))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }
}
