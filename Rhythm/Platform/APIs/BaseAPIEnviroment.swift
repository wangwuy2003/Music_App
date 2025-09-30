//
//  BaseAPIEnviroment.swift
//  Rhythm
//
//  Created by Apple on 29/9/25.
//

import Foundation
class BaseAPIEnviroment: APIEnvironment {
    var baseURL: String {
        return "https://api-v2.soundcloud.com"
    }
    
    var timeout: TimeInterval {
        return 10
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var apiKey: String {
        return ""
    }
    
}
