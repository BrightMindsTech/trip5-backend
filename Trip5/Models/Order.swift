import Foundation
import CoreLocation

enum Route: String, Codable {
    case irbidToAmman = "irbid_to_amman"
    case ammanToIrbid = "amman_to_irbid"
}

enum Service: Equatable {
    case basic
    case `private`(alone: Bool)
    case airport(toAirport: Bool)
    case instant(description: String)
    
    var priceJOD: Double? {
        switch self {
        case .basic: return 5
        case .private: return 15
        case .airport(let toAirport): return toAirport ? 25 : 15
        case .instant: return nil
        }
    }
    
    func priceFor(route: Route) -> Double? {
        switch self {
        case .basic: return 5
        case .private: return 15
        case .airport:
            return route == .irbidToAmman ? 25 : 15
        case .instant: return nil
        }
    }
}

extension Service: Codable {
    enum CodingKeys: String, CodingKey {
        case type, alone, toAirport, description
    }
    
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let type = try c.decode(String.self, forKey: .type)
        switch type {
        case "basic": self = .basic
        case "private":
            let alone = try c.decode(Bool.self, forKey: .alone)
            self = .private(alone: alone)
        case "airport":
            let toAirport = try c.decode(Bool.self, forKey: .toAirport)
            self = .airport(toAirport: toAirport)
        case "instant":
            let desc = try c.decode(String.self, forKey: .description)
            self = .instant(description: desc)
        default: throw DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Unknown service type"))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .basic: try c.encode("basic", forKey: .type)
        case .private(let alone): try c.encode("private", forKey: .type); try c.encode(alone, forKey: .alone)
        case .airport(let toAirport): try c.encode("airport", forKey: .type); try c.encode(toAirport, forKey: .toAirport)
        case .instant(let desc): try c.encode("instant", forKey: .type); try c.encode(desc, forKey: .description)
        }
    }
}

struct LocationInfo: Codable, Equatable {
    let latitude: Double
    let longitude: Double
    let address: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    init(latitude: Double, longitude: Double, address: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
    }
    
    init(coordinate: CLLocationCoordinate2D, address: String) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.address = address
    }
}

struct Order: Codable {
    let route: Route
    let date: Date
    let service: Service
    let fullName: String
    let phoneNumber: String
    let pickup: LocationInfo
    let destination: LocationInfo
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
