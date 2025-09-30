//
//  APIError.swift
//  Rhythm
//
//  Created by Apple on 28/9/25.
//

import Foundation
enum APIError: Error {
    case invalidResponse
    case httpStatus(code: Int)
    case emptyData
}
