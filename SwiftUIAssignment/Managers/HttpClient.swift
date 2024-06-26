//
//  HttpClient.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/19/24.
//

import Foundation

enum AppError: Error {
    case badUrl
    case badResponse
    case badData
    case badRequest
    case decoderError(Error)
    case serverError(Error?)
    case genericError
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol RequestBuilder {
    var baseUrl: String { get }
    var path: String? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryParam: [String: String]? { get }
    var bodyParam: [String: Any]? { get }
    
    func buildRequest() throws -> URLRequest
}

extension RequestBuilder {
    var baseUrl: String { "" }
    var headers: [String: String]? { nil }
    var queryParam: [String: String]? { nil }
    var bodyParam: [String: Any]? { nil }
    
    func buildRequest() throws -> URLRequest {
        // Get the url components
        guard var urlComponents = URLComponents(string: baseUrl) else {
            throw AppError.badUrl
        }
        
        // Adding path to url component
        if let path = path {
            urlComponents.path = urlComponents.path.appending(path)
        }
        
        // Add query param
        if let queryParam = queryParam {
            let encodedQuery = encodeParam(queryParam)
            urlComponents.query = encodedQuery
        }
        
        guard let url = urlComponents.url else {
            throw AppError.badUrl
        }
        
        // Method type
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // Adding Headers
        if let headers = headers {
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add body params
        if let bodyParam = bodyParam {
            request.httpBody = try JSONSerialization.data(withJSONObject: bodyParam)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
    
    private func encodeParam(_ params: [String: String]) -> String? {
        var components = URLComponents()
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.percentEncodedQuery
    }
}

class HttpClient {
    
    func fetch<T: Decodable>(request: RequestBuilder, completion: @escaping (Result<T, AppError>) -> Void) {
        do {
            let request = try request.buildRequest()
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.serverError(error)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    completion(.failure(.badResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.badData))
                    return
                }
                
                do {
                    let result = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.decoderError(error)))
                }
            }.resume()
        } catch {
            completion(.failure(.badUrl))
        }
    }
    
    func fetch<T: Decodable>(request: RequestBuilder) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            fetch(request: request) { (result: Result<T, AppError>) in
                switch result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func fetch<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func fetchData(request: RequestBuilder, completion: @escaping (Result<Data, AppError>) -> Void) {
        do {
            let request = try request.buildRequest()
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(.serverError(error)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    completion(.failure(.badResponse))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.badData))
                    return
                }
                
                completion(.success(data))
            }.resume()
        } catch {
            completion(.failure(.badUrl))
        }
    }
    
    func download(request: RequestBuilder, completion: @escaping (Result<URL, AppError>) -> Void) {
        do {
            let request = try request.buildRequest()
            URLSession.shared.downloadTask(with: request) { localURL, response, error in
                if let error = error {
                    completion(.failure(.serverError(error)))
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    completion(.failure(.badResponse))
                    return
                }
                
                guard let localURL = localURL else {
                    completion(.failure(.badData))
                    return
                }
                
                completion(.success(localURL))
            }.resume()
        } catch {
            completion(.failure(.badUrl))
        }
    }
    
    func download(request: URLRequest) async throws -> URL {
        let (tempURL, response) = try await URLSession.shared.download(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return tempURL
    }

}
