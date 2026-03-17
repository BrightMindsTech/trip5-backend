import Foundation

struct OrderAPIService {
    static func submit(_ order: Order) async throws {
        let url = URL(string: "\(Config.apiBaseURL)/api/orders")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(order)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let http = response as? HTTPURLResponse else {
            throw OrderAPIError.invalidResponse
        }
        
        guard (200...299).contains(http.statusCode) else {
            throw OrderAPIError.serverError(http.statusCode)
        }
    }
}

enum OrderAPIError: LocalizedError {
    case invalidResponse
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse: return "Invalid response from server"
        case .serverError(let code): return "Server error (\(code))"
        }
    }
}
