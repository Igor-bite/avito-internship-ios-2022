//
//  ServiceError.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 20.10.2022.
//

import Foundation

enum ServiceError: String, Error {
    case failedCreatingUrlRequest
    case missingData
    case decodingFailure
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        rawValue
    }
}
