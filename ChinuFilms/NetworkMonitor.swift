//
//  NetworkMonitor.swift
//  SanskarEP
//
//  Created by Vaibhav on 22/04/25.
//

import Network

protocol NetworkStatusDelegate: AnyObject {
    func networkBecameUnavailable()
    func networkBecameAvailable()
}

class NetworkMonitor {
    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")

    weak var delegate: NetworkStatusDelegate?

    private var wasConnected: Bool = true
    private var isFirstCheckDone = false

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.handlePath(path)
        }

        monitor.start(queue: queue)

        // ✅ Immediate check on launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let currentPath = self.monitor.currentPath
            self.handlePath(currentPath)
        }
    }

    private func handlePath(_ path: NWPath) {
        let isConnected = path.status == .satisfied

        if isConnected {
            if !wasConnected {
                delegate?.networkBecameAvailable()
            }
        } else {
            if wasConnected || !isFirstCheckDone {
                delegate?.networkBecameUnavailable()
            }
        }

        wasConnected = isConnected
        isFirstCheckDone = true
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}

