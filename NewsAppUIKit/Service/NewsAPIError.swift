//
//  NewsAPIError.swift
//  NewsAppUIKit
//
//  Created by Faruk Dereci on 12.12.2025.
//

import Foundation

enum NewsAPIError: Error {
    case badURL
    case nonHTTPResponse
    case httpStatus(code: Int, message: String?)
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "URL oluşturulamadı."
        case .nonHTTPResponse:
            return "HTTP olmayan bir cevap geldi."
        case .httpStatus(let code, let message):
            return message ?? "HTTP Hatası: \(code)"
        case .decodingFailed:
            return "JSON decode edilemedi"
        }
    }
}
