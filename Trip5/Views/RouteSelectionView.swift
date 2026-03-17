import SwiftUI

struct RouteSelectionView: View {
    @ObservedObject var viewModel: OrderViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text(L10n.chooseRoute)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            
            VStack(spacing: 16) {
                RouteCard(
                    title: L10n.routeIrbidToAmman,
                    isSelected: viewModel.route == .irbidToAmman
                ) {
                    viewModel.route = .irbidToAmman
                }
                
                RouteCard(
                    title: L10n.routeAmmanToIrbid,
                    isSelected: viewModel.route == .ammanToIrbid
                ) {
                    viewModel.route = .ammanToIrbid
                }
            }
            .padding(.horizontal)
            
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
            .disabled(!viewModel.canProceedFromRoute)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
}

struct RouteCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "car.fill")
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : .accentColor)
                Text(title)
                    .font(.title3.weight(.medium))
                    .foregroundColor(isSelected ? .white : .primary)
                Spacer()
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
