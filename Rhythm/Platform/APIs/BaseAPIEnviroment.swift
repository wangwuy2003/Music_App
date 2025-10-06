//
//  BaseAPIEnviroment.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation

struct BaseAPIEnviroment: APIEnvironment {
    var baseURL: String {
        return "https://api-v2.soundcloud.com"
    }
    
    var timeout: TimeInterval {
        return 60
    }
    
    var headers: [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    var apiKey: String {
        return ""
    }
}
