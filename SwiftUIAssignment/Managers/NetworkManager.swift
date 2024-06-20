//
//  NetworkManager.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/16/24.
//

import Foundation

class NetworkManager: NSObject {
    
    static let shared: NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    var apiKey: String = "cf4863382emsh660b0a010bd400dp1de074jsn26d3499ba6e2"
    
    private override init() {
        super.init()
    }
    
    enum HTTPMethod: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    enum NetworkError: Error {
        case invalidURL
        case noData
        case fileNotFound
    }
    
    func request(urlString: String, method: HTTPMethod, body: Data?, completion: @escaping (Result<Data, Error>) -> Void) {
        
        // 1. Step - Make URL
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        // 2. Step - Make Request
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let body = body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        request.setValue("wyre-data.p.rapidapi.com", forHTTPHeaderField: "x-rapidapi-host")
        request.setValue(apiKey, forHTTPHeaderField: "x-rapidapi-key")
        
        // Base authentication
        /*
        let credStr = "any formula"
        
        let logindata = credStr.data(using: .utf8)
        
        let base64 = logindata?.base64EncodedString()
        
        request.setValue(base64, forHTTPHeaderField: "Authorization")
        */
        
        request.timeoutInterval = 20.0 // timeout error
        
        // 3. Make Actual Session URL
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else  {
                completion(.failure(NetworkError.noData))
                return
            }
            
            completion(.success(data))
            
        })
        
        task.resume()
        
    }
    
    func requestDownload(urlString: String, method: HTTPMethod, body: Data?, completion: @escaping (Result<URL, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        let fileManager = FAFileManager.shared
        guard let documentsDirectory = fileManager.getDocumentDirectory() else {
            completion(.failure(NetworkError.fileNotFound))
            return
        }
        
        // Determine the appropriate directory based on the file type
        let fileExtension = url.pathExtension.lowercased()
        let targetDirectory = determineTargetDirectory(baseDirectory: documentsDirectory, fileExtension: fileExtension)
        
        // Ensure the target directory exists
        if !fileManager.isExist(file: targetDirectory) {
            do {
                try FileManager.default.createDirectory(at: targetDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch {
                completion(.failure(error))
                return
            }
        }

        let fileName = UUID().uuidString + "." + fileExtension
        let destinationURL = targetDirectory.appendingPathComponent(fileName)

        // Check if file already exists
        if fileManager.isExist(file: destinationURL) {
            completion(.success(destinationURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let bodyData = body {
            request.httpBody = bodyData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        let task = URLSession.shared.downloadTask(with: request) { tempFileUrl, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let tempFileUrl = tempFileUrl else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                try FileManager.default.moveItem(at: tempFileUrl, to: destinationURL)
                completion(.success(destinationURL))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func determineTargetDirectory(baseDirectory: URL, fileExtension: String) -> URL {
        switch fileExtension {
        case "jpg", "jpeg", "png", "gif":
            return baseDirectory.appendingPathComponent("photos")
        case "mov", "mp4":
            return baseDirectory.appendingPathComponent("videos")
        default:
            return baseDirectory.appendingPathComponent("downloads")
        }
    }


}
