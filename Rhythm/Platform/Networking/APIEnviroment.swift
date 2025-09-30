//
//  APIEnviroment.swift
//  Rhythm
//
//  Created by Apple on 28/9/25.
//

import Foundation
protocol APIEnvironment {
    var baseURL: String { get }
    var timeout: TimeInterval { get }
    var headers: [String: String] { get }
    var apiKey: String { get }
}
