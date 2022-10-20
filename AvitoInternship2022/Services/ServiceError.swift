//
//  ServiceError.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 20.10.2022.
//

import Foundation

enum ServiceError: Error {
    case failedCreatingUrlRequest
    case missingData
    case decodingFailure
}
