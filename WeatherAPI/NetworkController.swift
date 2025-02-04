//
//  NetworkController.swift
//  WeatherAPI
//
//  Created by Wylan L Neely on 1/25/25.
//

import UIKit
import Combine

class NetworkController {
        
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    private static func performRequest(
        for url: URL,
        httpMethod: HTTPMethod,
        urlParameters: [String: String]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) async throws -> Data {
        // Add query items to the URL
        let requestURL = addQueryItems(to: url, from: urlParameters)
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        request.timeoutInterval = 50
        request.allHTTPHeaderFields = headers

        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for HTTP errors
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }

    // Helper function to add query items
    private static func addQueryItems(to url: URL, from parameters: [String: String]?) -> URL {
        guard let parameters = parameters, !parameters.isEmpty else { return url }
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        components?.queryItems = queryItems
        
        return components?.url ?? url
    }
        
    //Weather Section
    private static let apiKey = "c1000adb412f466f9b9211757242906"
     
        
    static func fetchWeatherData(_ forCity: String) async throws -> WeatherObject? {
        guard let baseUrl = URL(string: "https://api.weatherapi.com/v1/current.json") else {
                throw URLError(.badURL)
        }
               
        let data = try await performRequest(for: baseUrl, httpMethod: .get,
                                            urlParameters: ["key": apiKey,
                                                            "q": forCity],
                                            headers: nil, body: nil)
               
              //test this area
        if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
            if let weatherObject = WeatherObject(json: json) {
                return weatherObject
            } else {
                throw URLError(.cannotParseResponse) // add custom error type to describe that data is currupted or cannot be parsed
            }
        }
            throw URLError(.cannotParseResponse)
    }
        
    static func downloadImage(from url: URL) -> AnyPublisher<UIImage, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, _ in
                guard let image = UIImage(data: data) else {
                    throw URLError(.cannotDecodeContentData)
                }
                return image
            }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
        }
        
        
}
