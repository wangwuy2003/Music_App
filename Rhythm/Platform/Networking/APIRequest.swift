//
//  APIRequest.swift
//  Rhythm
//
//  Created by Apple on 28/9/25.
//

import Foundation
protocol APIRequest {
    var enviroment: APIEnvironment { get }
    var path: String { get }
    var encoding : ParameterEncoding { get }
    var method: HTTPMethod { get }
    var params: [String: Any] { get }
    var headers: [String: String] { get }
    var request: URLRequest { get }
}

extension APIRequest {
    var fullURL: URL {
        guard let url = URL(string: enviroment.baseURL ) else {
            fatalError("Invalid base URL")
        }
        guard !path.isEmpty else {
            
            return url
        }
        return url.appendingPathComponent(path)
    }
    
    var headers: [String: String] {
        return enviroment.headers
    }
    
    var params: [String: Any]{
        return [:]
    }
    

    var request: URLRequest {
        var request = URLRequest(url: fullURL)
        request.httpMethod = method.rawValue

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        do {
            try encoding.encode(request: &request, with: params)
        } catch {
            fatalError("Failed to encode request: \(error)")
        }

        return request
    }
    var encoding: ParameterEncoding {
        return .json
    }
        
    func printRequest(){
        print("Method : \(method)")
        print("Headers : \(headers)")
        print("Params : \(params)")
        print("Full Request :\(fullURL) ")
        print("request : \(request)")
    }
}
