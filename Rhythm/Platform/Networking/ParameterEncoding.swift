//
//  ParameterEncoding.swift
//  Rhythm
//
//  Created by Apple on 28/9/25.
//



import Foundation

enum ParameterEncoding {
    case url
    case json
    func encode(request: inout URLRequest, with parameters: [String: Any]) throws {
        switch self {
        case .url:
            guard let url = request.url else { return }
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = parameters.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
            request.url = components?.url

        case .json:
            if request.httpMethod == "GET" {
                 break
            }
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = data
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
    }
}
