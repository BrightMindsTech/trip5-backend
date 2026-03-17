import SwiftUI

struct DetailsFormView: View {
    @ObservedObject var viewModel: OrderViewModel
    @ObservedObject var locationService: LocationService
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text(L10n.yourDetails)
                    .font(.title2.weight(.semibold))
                    .padding(.horizontal)
                
                MapLocationPicker(
                    title: L10n.pickupLocation,
                    selectedLocation: Binding(
                        get: { viewModel.pickupLocation },
                        set: { viewModel.pickupLocation = $0 }
                    ),
                    addressText: $viewModel.pickupAddress,
                    locationService: locationService
                )
                .padding(.horizontal)
                
                if viewModel.pickupError != nil {
                    Text(viewModel.pickupError!)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                MapLocationPicker(
                    title: L10n.destination,
                    selectedLocation: Binding(
                        get: { viewModel.destinationLocation },
                        set: { viewModel.destinationLocation = $0 }
                    ),
                    addressText: $viewModel.destinationAddress,
                    locationService: locationService
                )
                .padding(.horizontal)
                
                if viewModel.destinationError != nil {
                    Text(viewModel.destinationError!)
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.fullName)
                        .font(.headline)
                    TextField(L10n.enterFullName, text: $viewModel.fullName)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.name)
                    if let err = viewModel.fullNameError {
                        Text(err)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(L10n.phoneNumber)
                        .font(.headline)
                    TextField(L10n.enterPhone, text: $viewModel.phoneNumber)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)
                        .textContentType(.telephoneNumber)
                    if let err = viewModel.phoneError {
                        Text(err)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal)
                
                Button {
                    viewModel.goNext()
                } label: {
                    Text(L10n.next)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canProceedFromDetails)
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
            .padding(.vertical, 24)
        }
        .scrollDismissesKeyboard(.interactively)
    }
}
