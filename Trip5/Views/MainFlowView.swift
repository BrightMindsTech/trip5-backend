import SwiftUI

struct MainFlowView: View {
    @StateObject private var viewModel = OrderViewModel()
    @StateObject private var locationService = LocationService()
    @EnvironmentObject private var localization: LocalizationManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                StepProgressView(
                    currentStep: viewModel.currentStep.rawValue,
                    totalSteps: OrderViewModel.Step.confirmation.rawValue
                )
                .padding(.top, 8)
                
                Group {
                    switch viewModel.currentStep {
                    case .route:
                        RouteSelectionView(viewModel: viewModel)
                    case .date:
                        DateSelectionView(viewModel: viewModel)
                    case .service:
                        ServiceSelectionView(viewModel: viewModel)
                    case .details:
                        DetailsFormView(viewModel: viewModel, locationService: locationService)
                    case .confirmation:
                        ConfirmationView(viewModel: viewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("Trip5")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    LanguageToggleButton(localization: localization)
                }
                if viewModel.currentStep != .route && !viewModel.orderSent {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(L10n.back) {
                            viewModel.goBack()
                        }
                    }
                }
            }
            .environment(\.layoutDirection, localization.currentLanguage.layoutDirection)
        }
    }
}
