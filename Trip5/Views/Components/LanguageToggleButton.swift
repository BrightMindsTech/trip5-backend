import SwiftUI

struct LanguageToggleButton: View {
    @ObservedObject var localization: LocalizationManager
    
    var body: some View {
        Button {
            localization.toggleLanguage()
        } label: {
            Text(localization.currentLanguage == .arabic ? "English" : "العربية")
                .font(.subheadline.weight(.medium))
                .foregroundColor(.accentColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
        }
        .buttonStyle(.plain)
    }
}
