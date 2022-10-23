//
//  MockedURLCacheFacade.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import Foundation
@testable import AvitoInternship2022

final class MockedURLCacheFacade: URLCacheFacadeProtocol {
    var data: Data?
    var insertCalledTimes = 0
    var removeCalledTimes = 0

    func insert(_ data: Data, forRequest request: URLRequest, withResponse response: URLResponse, lifetime: TimeInterval?) {
        insertCalledTimes += 1
    }

    func removeData(forRequest request: URLRequest) {
        removeCalledTimes += 1
    }

    func data(forRequest request: URLRequest) -> Data? {
        return data
    }
}
