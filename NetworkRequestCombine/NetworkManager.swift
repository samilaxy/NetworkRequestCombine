    //
    //  NetworkManager.swift
    //  NetworkRequestCombine
    //
    //  Created by Noye Samuel on 10/05/2023.
    //

import Foundation
import Combine


class NetworkManager {
    
    typealias Params = [String: Any]
    
    func request<T: Decodable>(from endPoint: EndPointEnum, queryParams: Params?) ->AnyPublisher<T, Error> {
        
            // Create URL components from the base URL
        var urlComponents = URLComponents(url: endPoint.url, resolvingAgainstBaseURL: false)
        
            // Add query parameters to the URL components
        if let params = queryParams {
            urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value as? String) }
        }
            // Create a URLRequest from the final URL
        var request = URLRequest(url: urlComponents?.url ?? endPoint.url)
            // Set the HTTP method of the request
        request.httpMethod = endPoint.httpMethod.rawValue
        
            // Set the request body
        if endPoint.isJSONEncoded {
            if let parameters = queryParams, let bodyData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
                request.httpBody = bodyData
            }
        }
        
            // Set common headers, such as API keys and content type
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap({ data, response in
                
                    // If the response is invalid, throw an error
              
                    // Return Response data
                return data
            })
            .decode(type: T.self, decoder : JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

protocol Request {
    var url: URL { get }
    var contentType: String { get }
    var httpMethod: HTTPMethod { get }
    var isJSONEncoded: Bool { get }
}

enum EndPointEnum {
    case users
    case posts
    case send
}

    // defining end point types
extension EndPointEnum: Request {
    
    
    var contentType: String { return "application/json" }
        // is Json encoded
    var isJSONEncoded: Bool {
        switch self {
            case .users, .posts:
                return false
            case .send:
                return true
        }
    }
        // is http request methods
    var httpMethod: HTTPMethod {
        switch self {
                    // Post Method
            case .send:
                return .post
                    // Get Method
            case .users, .posts:
                return .get
        }
    }
        // full URL to return
    var url: URL {
        
        switch self {
            case .users:
                return APIFullURLs.users
            case .posts:
                return APIFullURLs.posts
            case .send:
                return APIFullURLs.send
        }
    }
}

    // specify endpoints to be added to base url
struct APIFullURLs {
    static let users = EndPoints(with: "/users").requestedURL
    static let posts = EndPoints(with: "/posts").requestedURL
    static let send = EndPoints(with: "/send").requestedURL
    init() {}
}

    // Construct url
class EndPoints {
        // MARK: - Public variables
    let baseURL = "https://jsonplaceholder.typicode.com"
    var requestedURL: URL
    
        // MARK: - Required init
    required init(with URI: String) {
        
        let urlString = baseURL + URI
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL")
        }
        requestedURL =  url
    }
}

    // The Request Method
enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
}

    // Error enum
enum APIError: Error {
    case decodingError
    case errorCode(Int)
    case unknown
    case noInternetConnection
}
















