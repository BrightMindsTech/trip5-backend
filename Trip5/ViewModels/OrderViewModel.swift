import Foundation
import SwiftUI
import CoreLocation

@MainActor
final class OrderViewModel: ObservableObject {
    enum Step: Int, CaseIterable {
        case route = 1
        case date = 2
        case service = 3
        case details = 4
        case confirmation = 5
        
        var total: Int { 5 }
    }
    
    @Published var currentStep: Step = .route
    @Published var route: Route?
    @Published var isToday: Bool = true
    @Published var scheduledDate: Date = Calendar.current.startOfDay(for: Date())
    @Published var service: Service?
    @Published var fullName: String = ""
    @Published var phoneNumber: String = ""
    @Published var pickupLocation: LocationInfo?
    @Published var pickupAddress: String = ""
    @Published var destinationLocation: LocationInfo?
    @Published var destinationAddress: String = ""
    
    @Published var isSubmitting = false
    @Published var submitError: String?
    @Published var orderSent = false
    
    var orderDate: Date {
        isToday ? Date() : scheduledDate
    }
    
    var canProceedFromRoute: Bool { route != nil }
    var canProceedFromDate: Bool { true }
    var canProceedFromService: Bool {
        guard let s = service else { return false }
        if case .instant(let desc) = s { return !desc.trimmingCharacters(in: .whitespaces).isEmpty }
        return true
    }
    
    var canProceedFromDetails: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        isValidPhone(phoneNumber) &&
        pickupLocation != nil &&
        destinationLocation != nil
    }
    
    var fullNameError: String? {
        fullName.trimmingCharacters(in: .whitespaces).isEmpty ? L10n.errorRequired : nil
    }
    
    var phoneError: String? {
        if phoneNumber.isEmpty { return L10n.errorRequired }
        if !isValidPhone(phoneNumber) { return L10n.errorInvalidPhone }
        return nil
    }
    
    var pickupError: String? {
        pickupLocation == nil ? L10n.errorSelectLocation : nil
    }
    
    var destinationError: String? {
        destinationLocation == nil ? L10n.errorSelectLocation : nil
    }
    
    func goNext() {
        guard let next = Step(rawValue: currentStep.rawValue + 1) else { return }
        currentStep = next
    }
    
    func goBack() {
        guard let prev = Step(rawValue: currentStep.rawValue - 1) else { return }
        currentStep = prev
    }
    
    func goToStep(_ step: Step) {
        currentStep = step
    }
    
    func resetForNewOrder() {
        currentStep = .route
        route = nil
        isToday = true
        scheduledDate = Calendar.current.startOfDay(for: Date())
        service = nil
        fullName = ""
        phoneNumber = ""
        pickupLocation = nil
        pickupAddress = ""
        destinationLocation = nil
        destinationAddress = ""
        isSubmitting = false
        submitError = nil
        orderSent = false
    }
    
    func buildOrder() -> Order? {
        guard let route = route,
              let service = service,
              let pickup = pickupLocation,
              let destination = destinationLocation else { return nil }
        
        return Order(
            route: route,
            date: orderDate,
            service: service,
            fullName: fullName.trimmingCharacters(in: .whitespaces),
            phoneNumber: phoneNumber.trimmingCharacters(in: .whitespaces),
            pickup: pickup,
            destination: destination
        )
    }
    
    func formattedOrderText() -> String {
        guard let order = buildOrder() else { return "" }
        
        var serviceDesc = ""
        switch order.service {
        case .basic: serviceDesc = "\(L10n.serviceBasic) - 5 \(L10n.jod)"
        case .private(let alone): serviceDesc = "\(L10n.servicePrivate) - 15 \(L10n.jod) (\(alone ? L10n.alone : L10n.family))"
        case .airport(let toAirport): serviceDesc = "\(L10n.serviceAirport) - \(order.service.priceFor(route: order.route) ?? 0) \(L10n.jod) (\(toAirport ? L10n.toAirport : L10n.fromAirport))"
        case .instant(let desc): serviceDesc = "\(L10n.serviceInstant): \(desc)"
        }
        
        let routeText = order.route == .irbidToAmman ? L10n.routeIrbidToAmman : L10n.routeAmmanToIrbid
        
        return """
        New Trip5 Order
        ---
        Route: \(routeText)
        Date: \(order.formattedDate)
        Service: \(serviceDesc)
        ---
        Pickup: \(order.pickup.address) (\(order.pickup.latitude), \(order.pickup.longitude))
        Destination: \(order.destination.address) (\(order.destination.latitude), \(order.destination.longitude))
        ---
        Name: \(order.fullName)
        Phone: \(order.phoneNumber)
        ---
        """
    }
    
    private func isValidPhone(_ phone: String) -> Bool {
        let cleaned = phone.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
        if cleaned.hasPrefix("+962") {
            return cleaned.count >= 12
        }
        if cleaned.hasPrefix("962") {
            return cleaned.count >= 11
        }
        if cleaned.hasPrefix("0") {
            return cleaned.count >= 9 && cleaned.count <= 10
        }
        return cleaned.count >= 9 && cleaned.count <= 10
    }
}
