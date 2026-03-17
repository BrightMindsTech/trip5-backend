import SwiftUI

struct ConfirmationView: View {
    @ObservedObject var viewModel: OrderViewModel
    
    var body: some View {
        Group {
            if viewModel.orderSent {
                OrderSuccessView(viewModel: viewModel)
            } else {
                OrderSummaryView(viewModel: viewModel)
            }
        }
    }
}

struct OrderSummaryView: View {
    @ObservedObject var viewModel: OrderViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(L10n.orderSummary)
                    .font(.title2.weight(.semibold))
                    .padding(.horizontal)
                
                if let order = viewModel.buildOrder() {
                    OrderSummaryRow(label: "Route", value: order.route == .irbidToAmman ? L10n.routeIrbidToAmman : L10n.routeAmmanToIrbid)
                    OrderSummaryRow(label: "Date", value: order.formattedDate)
                    OrderSummaryRow(label: "Service", value: serviceDescription(order))
                    OrderSummaryRow(label: L10n.pickupLocation, value: order.pickup.address)
                    OrderSummaryRow(label: L10n.destination, value: order.destination.address)
                    OrderSummaryRow(label: L10n.fullName, value: order.fullName)
                    OrderSummaryRow(label: L10n.phoneNumber, value: order.phoneNumber)
                }
                
                if let error = viewModel.submitError {
                    Text(error)
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                Button {
                    Task {
                        await submitOrder()
                    }
                } label: {
                    if viewModel.isSubmitting {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    } else {
                        Text(L10n.submitOrder)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isSubmitting)
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .padding(.vertical, 24)
        }
    }
    
    private func serviceDescription(_ order: Order) -> String {
        switch order.service {
        case .basic: return "\(L10n.serviceBasic) - 5 \(L10n.jod)"
        case .private(let alone): return "\(L10n.servicePrivate) - 15 \(L10n.jod) (\(alone ? L10n.alone : L10n.family))"
        case .airport(let toAirport):
            let price = order.service.priceFor(route: order.route) ?? 0
            return "\(L10n.serviceAirport) - \(Int(price)) \(L10n.jod) (\(toAirport ? L10n.toAirport : L10n.fromAirport))"
        case .instant(let desc): return "\(L10n.serviceInstant): \(desc)"
        }
    }
    
    private func submitOrder() async {
        guard let order = viewModel.buildOrder() else { return }
        viewModel.isSubmitting = true
        viewModel.submitError = nil
        do {
            try await OrderAPIService.submit(order)
            viewModel.orderSent = true
        } catch {
            viewModel.submitError = L10n.errorSending
        }
        viewModel.isSubmitting = false
    }
}

struct OrderSummaryRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(.horizontal)
    }
}

struct OrderSuccessView: View {
    @ObservedObject var viewModel: OrderViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 64))
                .foregroundColor(.green)
            Text(L10n.orderSent)
                .font(.title.weight(.semibold))
            Text(L10n.orderSentDesc)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Spacer()
            Button {
                viewModel.resetForNewOrder()
            } label: {
                Text(L10n.newOrder)
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
            }
            .buttonStyle(.borderedProminent)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
}
