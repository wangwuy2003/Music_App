//
//  APIClient.swift
//  Rhythm
//
//  Created by Apple on 28/9/25.
//

import Foundation
typealias APIClient = APIOperation & APIRequest

extension APIOperation where Self : APIRequest {
    func execute(completion: @escaping (Result<Model, Error>) -> Void) {
        self.printRequest()
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: self.request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.invalidResponse))
                }
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.httpStatus(code: httpResponse.statusCode)))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(APIError.emptyData))
                }
                return
            }
            do {
                let model = try JSONDecoder().decode(Model.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(model))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
        }
        task.resume()
    }
}
