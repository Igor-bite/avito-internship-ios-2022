//
//  CompanyFetcherTests.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 23.10.2022.
//

@testable import AvitoInternship2022
import XCTest

final class CompanyFetcherTests: XCTestCase {
    private enum Constants {
        static let url = URL(string: "https://www.test.com")!
    }

    private var sut: CompanyFetcher!
    private var networkService: MockedNetworkService!
    private var cache: MockedURLCacheFacade!
    private var urlRequest = URLRequest(url: Constants.url)
    private var urlResponse = URLResponse(url: Constants.url, mimeType: nil,
                                          expectedContentLength: 0, textEncodingName: nil)

    private let company = Company(name: "Name",
                                  employees: [.init(name: "name", phoneNumber: "12345", skills: ["Skill"])])
    private let encoder = {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }()

    private var requestData: Data! {
        try! encoder.encode(CompanyRequestResult(company: company))
    }

    override func setUp() {
        networkService = .init()
        cache = .init()
        sut = .init(networkService: networkService, cache: cache)
    }

    override func tearDown() {
        networkService = nil
        cache = nil
        sut = nil
    }

    func test_givenForceRefreshFalse_whenDataInCache_thenReturnCachedData() throws {
//        given
        let forceRefresh = false
        cache.data = requestData
        networkService.result = .success((requestData, urlResponse))

//        when
        let exp = expectation(description: "Wait for completion")

        sut.getCompany(forceRefresh: forceRefresh) { result in

//            then
            switch result {
            case .success(let retrievedCompany):
                XCTAssertEqual(self.company, retrievedCompany)
            case .failure(let error):
                XCTFail("Failed with error: \(error); Request must succeed")
            }
            exp.fulfill()
        }
        XCTAssertEqual(networkService.requestMethodCalls, 0, "Request network must not be called")

        wait(for: [exp], timeout: 0.1)
    }

    func test_givenForceRefreshFalse_whenDataNotInCache_thenRequestAndReturnNetworkData() throws {
//        given
        let forceRefresh = false
        networkService.result = .success((requestData, urlResponse))

        checkFetchThroughNetworkAndSaveToCache(forceRefresh: forceRefresh)
    }

    func test_givenForceRefreshTrue_whenDataInCache_thenRequestAndReturnNetworkData() throws {
//        given
        let forceRefresh = true
        cache.data = requestData
        networkService.result = .success((requestData, urlResponse))

        checkFetchThroughNetworkAndSaveToCache(forceRefresh: forceRefresh)
    }

    func test_givenForceRefreshTrue_whenDataNotInCache_thenRequestAndReturnNetworkData() throws {
        let forceRefresh = true
        networkService.result = .success((requestData, urlResponse))

        checkFetchThroughNetworkAndSaveToCache(forceRefresh: forceRefresh)
    }

    func checkFetchThroughNetworkAndSaveToCache(forceRefresh: Bool) {
//        when
        let exp = expectation(description: "Wait for completion")

        sut.getCompany(forceRefresh: forceRefresh) { result in

//            then
            switch result {
            case .success(let retrievedCompany):
                XCTAssertEqual(self.company, retrievedCompany)
            case .failure(let error):
                XCTFail("Failed with error: \(error); Request must succeed")
            }
            exp.fulfill()
        }
        XCTAssertEqual(networkService.requestMethodCalls, 1, "Request network must be called only once")

        wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(cache.insertCalledTimes, 1, "Fetched data must be saved 1 time")
    }
}
