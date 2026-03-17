import Foundation

enum L10n {
    static func string(_ key: String) -> String {
        LocalizationManager.shared.string(key)
    }
    
    static let appName = "Trip5"
    
    static var routeIrbidToAmman: String { string("route_irbid_to_amman") }
    static var routeAmmanToIrbid: String { string("route_amman_to_irbid") }
    
    static var chooseRoute: String { string("choose_route") }
    static var next: String { string("next") }
    static var back: String { string("back") }
    
    static var today: String { string("today") }
    static var scheduled: String { string("scheduled") }
    static var selectDate: String { string("select_date") }
    static var chooseDate: String { string("choose_date") }
    
    static var serviceBasic: String { string("service_basic") }
    static var serviceBasicDesc: String { string("service_basic_desc") }
    static var servicePrivate: String { string("service_private") }
    static var servicePrivateDesc: String { string("service_private_desc") }
    static var alone: String { string("alone") }
    static var family: String { string("family") }
    static var serviceAirport: String { string("service_airport") }
    static var serviceAirportDesc: String { string("service_airport_desc") }
    static var toAirport: String { string("to_airport") }
    static var fromAirport: String { string("from_airport") }
    static var serviceInstant: String { string("service_instant") }
    static var serviceInstantDesc: String { string("service_instant_desc") }
    static var whatToTransport: String { string("what_to_transport") }
    static var enterDescription: String { string("enter_description") }
    
    static var chooseService: String { string("choose_service") }
    static var jod: String { string("jod") }
    
    static var pickupLocation: String { string("pickup_location") }
    static var destination: String { string("destination") }
    static var useMyLocation: String { string("use_my_location") }
    static var fullName: String { string("full_name") }
    static var phoneNumber: String { string("phone_number") }
    static var enterFullName: String { string("enter_full_name") }
    static var enterPhone: String { string("enter_phone") }
    static var searchAddress: String { string("search_address") }
    
    static var yourDetails: String { string("your_details") }
    static var orderSummary: String { string("order_summary") }
    static var submitOrder: String { string("submit_order") }
    static var orderSent: String { string("order_sent") }
    static var orderSentDesc: String { string("order_sent_desc") }
    static var newOrder: String { string("new_order") }
    
    static var step: String { string("step") }
    static func stepOf(_ current: Int, total: Int) -> String {
        string("step_of").replacingOccurrences(of: "%1", with: "\(current)").replacingOccurrences(of: "%2", with: "\(total)")
    }
    
    static var errorRequired: String { string("error_required") }
    static var errorInvalidPhone: String { string("error_invalid_phone") }
    static var errorSelectLocation: String { string("error_select_location") }
    
    static var sending: String { string("sending") }
    static var errorSending: String { string("error_sending") }
}
