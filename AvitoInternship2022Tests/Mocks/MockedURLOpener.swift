//
//  MockedURLOpener.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 23.10.2022.
//

@testable import AvitoInternship2022
import Foundation

final class MockedURLOpener: URLOpener {
    var openUrlCalls = 0

    func openUrl(_: URL?) {
        openUrlCalls += 1
    }
}
