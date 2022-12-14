//
//  MockedNetworkMonitor.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 23.10.2022.
//

@testable import AvitoInternship2022
import Foundation

final class MockedNetworkMonitor: NetworkMonitorProtocol {
    private var isConnectedWrapped: Bool!

    var isConnected: Bool {
        set {
            isConnectedWrapped = newValue
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }
        get {
            isConnectedWrapped
        }
    }

    func startMonitoring() {}
    func stopMonitoring() {}
}
