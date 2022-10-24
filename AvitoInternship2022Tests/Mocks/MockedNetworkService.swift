//
//  MockedNetworkService.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 24.10.2022.
//

@testable import AvitoInternship2022
import Foundation

final class MockedNetworkService: NetworkServiceProtocol {
    var requestMethodCalls = 0
    var result: Result<(data: Data?, response: URLResponse?), Error>?

    func request(_: URLRequest, completion: @escaping (Result<(data: Data?, response: URLResponse?), Error>) -> Void) {
        requestMethodCalls += 1
        if let result = result {
            completion(result)
        }
    }
}
