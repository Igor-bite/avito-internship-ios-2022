//
//  MockedURLOpener.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 23.10.2022.
//

import Foundation
@testable import AvitoInternship2022

final class MockedURLOpener: URLOpener {
    var openUrlCalls = 0

    func openUrl(_ url: URL?) {
        openUrlCalls += 1
    }
}
