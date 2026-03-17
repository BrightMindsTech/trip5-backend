import SwiftUI

struct DateSelectionView: View {
    @ObservedObject var viewModel: OrderViewModel
    
    private var minDate: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Text(L10n.chooseDate)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
                .padding(.top, 24)
            
            VStack(spacing: 16) {
                DateOptionCard(
                    title: L10n.today,
                    isSelected: viewModel.isToday
                ) {
                    viewModel.isToday = true
                }
                
                DateOptionCard(
                    title: L10n.scheduled,
                    isSelected: !viewModel.isToday
                ) {
                    viewModel.isToday = false
                }
                
                if !viewModel.isToday {
                    DatePicker(
                        L10n.selectDate,
                        selection: $viewModel.scheduledDate,
                        in: minDate...,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding()
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
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
}

struct DateOptionCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "calendar")
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
