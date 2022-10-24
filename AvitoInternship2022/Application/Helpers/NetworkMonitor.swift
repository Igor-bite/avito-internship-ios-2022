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

protocol NetworkMonitorProtocol {
    var isConnected: Bool { get }
    func startMonitoring()
    func stopMonitoring()
}

final class NetworkMonitor: NetworkMonitorProtocol {
    static let shared = NetworkMonitor()

    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    private let monitor: NWPathMonitor

    private(set) lazy var isConnected: Bool = isConnected(withPath: monitor.currentPath)

    private init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self,
                  self.isConnected(withPath: path) != self.isConnected
            else { return }

            self.isConnected = self.isConnected(withPath: path)
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
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
