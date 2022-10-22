//
//  TargetType.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 20.10.2022.
//

import Foundation

protocol TargetType {
    var baseUrl: String { get }
    var path: String { get }
}

extension TargetType {
    var urlRequest: URLRequest? {
        guard let url = URL(string: baseUrl + path) else { return nil }
        return URLRequest(url: url)
    }
}
