//
//  NetworkMonitor.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 22.10.2022.
//

import Foundation
import Network

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    private let monitor: NWPathMonitor

    private(set) lazy var isConnected: Bool = isConnected(withPath: monitor.currentPath)

    private init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            let isConnected = self.isConnected(withPath: path)
            guard isConnected != self.isConnected else { return }

            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
            self.isConnected = isConnected
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }

    private func isConnected(withPath path: NWPath) -> Bool {
        path.status != .unsatisfied
    }
}
