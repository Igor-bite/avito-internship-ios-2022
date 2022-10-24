//
//  URLCacheFacade.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 20.10.2022.
//

import Foundation

final class URLCacheFacade: URLCacheFacadeProtocol {
    private enum Constants {
        static let keyPostfix = "urlCacheExpiry"
    }

    private let cache: URLCache

    init(memoryCapacity: Int, diskCapacity: Int, diskPath: String) {
        cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: diskPath)
    }

    func insert(_ data: Data, forRequest request: URLRequest, withResponse response: URLResponse, lifetime: TimeInterval?) {
        let cachedData = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedData, for: request)
        if let lifetime = lifetime {
            saveExpiryDate(Date().addingTimeInterval(lifetime), forRequest: request)
        } else {
            saveExpiryDate(nil, forRequest: request)
        }
    }

    func removeData(forRequest request: URLRequest) {
        cache.removeCachedResponse(for: request)
        saveExpiryDate(nil, forRequest: request)
    }

    func data(forRequest request: URLRequest) -> Data? {
        if isDataExpired(forRequest: request) {
            return nil
        }
        return cacheData(forRequest: request)
    }

    private func cacheData(forRequest request: URLRequest) -> Data? {
        cache.cachedResponse(for: request)?.data
    }
}

// MARK: - Cache values expiry handling

private extension URLCacheFacade {
    func isDataExpired(forRequest request: URLRequest) -> Bool {
        if let expiryDate = expiryDate(forRequest: request) {
            if Date() < expiryDate {
                return false
            }
            removeData(forRequest: request)
            return true
        }
        return false
    }

    func expiryDateDefaultsKey(forRequest request: URLRequest) -> String {
        "\(request.hashValue)\(Constants.keyPostfix)"
    }

    func expiryDate(forRequest request: URLRequest) -> Date? {
        UserDefaults.standard.value(forKey: expiryDateDefaultsKey(forRequest: request)) as? Date
    }

    func saveExpiryDate(_ expiryDate: Date?, forRequest request: URLRequest) {
        UserDefaults.standard.set(expiryDate, forKey: expiryDateDefaultsKey(forRequest: request))
    }
}
