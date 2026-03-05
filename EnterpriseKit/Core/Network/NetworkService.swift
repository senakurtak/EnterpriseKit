//
//  NetworkService.swift
//  EnterpriseKit
//
//  Created by Sena Kurtak on 6.03.2026.
//

import Foundation

final class NetworkService {
    
    static let shared = NetworkService()
    private init() {}
    
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        method: String = "GET",
        body: Data? = nil
    ) async throws -> T {
        
        guard let url = endpoint.url else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.decodingError
        }
    }
}
