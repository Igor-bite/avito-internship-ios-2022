//
//  MockedNetworkService.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import Foundation
@testable import AvitoInternship2022

final class MockedNetworkService: NetworkServiceProtocol {
    var requestMethodCalls = 0
    var result: Result<(data: Data?, response: URLResponse?), Error>?

    func request(_ request: URLRequest, completion: @escaping (Result<(data: Data?, response: URLResponse?), Error>) -> Void) {
        requestMethodCalls += 1
        if let result = result {
            completion(result)
        }
    }
}
