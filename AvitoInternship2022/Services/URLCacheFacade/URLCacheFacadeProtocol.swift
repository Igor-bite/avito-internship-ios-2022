//
//  URLCacheFacadeProtocol.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 20.10.2022.
//

import Foundation

protocol URLCacheFacadeProtocol {
    func insert(_ data: Data, forRequest request: URLRequest, withResponse response: URLResponse, lifetime: TimeInterval?)
    func removeData(forRequest request: URLRequest)
    func data(forRequest request: URLRequest) -> Data?
}
