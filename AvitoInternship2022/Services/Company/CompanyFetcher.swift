//
//  CachingCompanyFetcher.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 19.10.2022.
//

import Foundation

final class CompanyFetcher: CompanyService {
    // MARK: - Constants

    private enum Constants {
        static let diskPath = "companyFetcherCache"
        static let allowedMemorySize = 10 * 1_024 * 1_024 // 10 Mb
        static let allowedDiskSize = 10 * 1_024 * 1_024   // 10 Mb
        static let cacheStorageTimeInterval: Double = 60 * 60 // 1 hour
    }

    // MARK: - Private properties

    private let networkService: NetworkServiceProtocol
    private let cache: URLCacheFacadeProtocol?
    private lazy var urlSession = URLSession(configuration: .default)
    private let decoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    // MARK: - Public functions

    init(networkService: NetworkServiceProtocol,
         cache: URLCacheFacadeProtocol?) {
        self.networkService = networkService
        self.cache = cache
    }

    convenience init() {
        self.init(
            networkService: NetworkService.shared,
            cache: URLCacheFacade(memoryCapacity: Constants.allowedMemorySize,
                                  diskCapacity: Constants.allowedDiskSize,
                                  diskPath: Constants.diskPath)
        )
    }

    func getCompany(forceRefresh: Bool, completion: @escaping (Result<Company, Error>) -> Void) {
        let requestType = RequestType.company
        guard let request = requestType.urlRequest else {
            completion(.failure(ServiceError.failedCreatingUrlRequest))
            return
        }

        if !forceRefresh,
           let cachedData = cache?.data(forRequest: request),
           let company = decode(data: cachedData)
        {
            completion(.success(company))
        } else {
            startRequest(request, completion: completion)
        }
    }

    private func startRequest(_ request: URLRequest,
                              completion: @escaping (Result<Company, Error>) -> Void) {
        networkService.request(request) { result in
            switch result {
            case .success(let (data, response)):
                guard let data = data else {
                    completion(.failure(ServiceError.missingData))
                    return
                }

                guard let company = self.decode(data: data) else {
                    completion(.failure(ServiceError.decodingFailure))
                    return
                }

                if let response = response {
                    self.cache?.insert(data,
                                       forRequest: request,
                                       withResponse: response,
                                       lifetime: Constants.cacheStorageTimeInterval)
                }
                completion(.success(company))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    private func decode(data: Data) -> Company? {
        do {
            let companyResult = try decoder.decode(CompanyRequestResult.self, from: data)
            return companyResult.company
        } catch {
            return nil
        }
    }
}
