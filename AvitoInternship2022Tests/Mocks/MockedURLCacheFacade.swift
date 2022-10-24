//
//  MockedURLCacheFacade.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 24.10.2022.
//

@testable import AvitoInternship2022
import Foundation

final class MockedURLCacheFacade: URLCacheFacadeProtocol {
    var data: Data?
    var insertCalledTimes = 0
    var removeCalledTimes = 0

    func insert(_: Data, forRequest _: URLRequest, withResponse _: URLResponse, lifetime _: TimeInterval?) {
        insertCalledTimes += 1
    }

    func removeData(forRequest _: URLRequest) {
        removeCalledTimes += 1
    }

    func data(forRequest _: URLRequest) -> Data? {
        return data
    }
}
