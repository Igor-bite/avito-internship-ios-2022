//
//  NetworkManager.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 20.10.2022.
//

import Foundation

protocol NetworkServiceProtocol {
    typealias NetworkRequestResult = Result<(data: Data?, response: URLResponse?), Error>
    func request(_ request: URLRequest, completion: @escaping (NetworkRequestResult) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    static let shared: NetworkServiceProtocol = NetworkService()

    private lazy var urlSession = URLSession(configuration: .default)

    private init() {}

    func request(_ request: URLRequest, completion: @escaping (NetworkRequestResult) -> Void) {
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success((data, response)))
        }.resume()
    }
}
