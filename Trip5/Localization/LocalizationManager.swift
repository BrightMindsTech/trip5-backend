import Foundation
import SwiftUI

enum AppLanguage: String, CaseIterable {
    case arabic = "ar"
    case english = "en"
    
    var displayName: String {
        switch self {
        case .arabic: return "العربية"
        case .english: return "English"
        }
    }
    
    var layoutDirection: LayoutDirection {
        self == .arabic ? .rightToLeft : .leftToRight
    }
    
    var identifier: String {
        rawValue
    }
}

@MainActor
final class LocalizationManager: ObservableObject {
    static let shared = LocalizationManager()
    
    private let languageKey = "app_language"
    
    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.standard.set(currentLanguage.rawValue, forKey: languageKey)
        }
    }
    
    var isArabic: Bool {
        currentLanguage == .arabic
    }
    
    init() {
        if let saved = UserDefaults.standard.string(forKey: languageKey),
           let lang = AppLanguage(rawValue: saved) {
            currentLanguage = lang
        } else {
            currentLanguage = .arabic
        }
    }
    
    func toggleLanguage() {
        currentLanguage = currentLanguage == .arabic ? .english : .arabic
    }
    
    func string(_ key: String) -> String {
        let bundle = Bundle.main
        if let path = bundle.path(forResource: currentLanguage.rawValue, ofType: "lproj"),
           let langBundle = Bundle(path: path) {
            return langBundle.localizedString(forKey: key, value: key, table: nil)
        }
        return key
    }
}
