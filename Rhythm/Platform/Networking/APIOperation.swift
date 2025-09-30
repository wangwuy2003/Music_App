//
//  APIOperation.swift
//  Rhythm
//
//  Created by Apple on 28/9/25.
//


protocol APIOperation {
    associatedtype Model : Codable
    func execute(completion : @escaping (Result<Model, Error>) -> Void)
}
