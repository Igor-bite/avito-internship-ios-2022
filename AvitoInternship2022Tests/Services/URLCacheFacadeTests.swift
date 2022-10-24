//
//  AvitoInternship2022Tests.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 18.10.2022.
//

@testable import AvitoInternship2022
import XCTest

final class URLCacheFacadeTests: XCTestCase {
    private enum Constants {
        static let url = URL(string: "https://www.test.com")!
    }

    private var sut: URLCacheFacade!
    private var data: Data!
    private var urlRequest = URLRequest(url: Constants.url)
    private var urlResponse = URLResponse(url: Constants.url, mimeType: nil,
                                          expectedContentLength: 0, textEncodingName: nil)

    override func setUp() {
        sut = URLCacheFacade(memoryCapacity: 1024 * 1024, diskCapacity: 1024 * 1024, diskPath: "diskPath")
        data = String("Hello world").data(using: .utf8)!
    }

    override func tearDown() {
        sut = nil
        data = nil
    }

    func test_givenCache_whenInsertWithLifetimeMoreThanTimeElapsed_thenDataExist() throws {
//        given
        let lifetime = 60.0 // 60 seconds

//        when
        sut.insert(data, forRequest: urlRequest, withResponse: urlResponse, lifetime: lifetime)

//        then
        XCTAssertNotNil(sut.data(forRequest: urlRequest), "Data must exist")
    }

    func test_givenCache_whenInsertWithLifetimeLessThanTimeElapsed_thenDataExist() throws {
//        given
        let lifetime = 0.1 // 0.1 second

//        when
        sut.insert(data, forRequest: urlRequest, withResponse: urlResponse, lifetime: lifetime)

//        then
        let exp = expectation(description: "Check after \(lifetime + 0.1) second")
        let result = XCTWaiter.wait(for: [exp], timeout: lifetime + 0.1)
        XCTAssertEqual(result, XCTWaiter.Result.timedOut, "Delay was interrupted")

        XCTAssertNil(sut.data(forRequest: urlRequest), "Data must not exist")
    }

    func test_givenCache_whenInsertWithNoExpiry_thenDataExist() throws {
//        given
        let lifetime: TimeInterval? = nil

//        when
        sut.insert(data, forRequest: urlRequest, withResponse: urlResponse, lifetime: lifetime)

//        then
        XCTAssertNotNil(sut.data(forRequest: urlRequest), "Data must not exist")
    }

    func test_givenCache_whenInsertAndRemoveData_thenDataNotExist() throws {
//        given
        let lifetime: TimeInterval? = nil

//        when
        sut.insert(data, forRequest: urlRequest, withResponse: urlResponse, lifetime: lifetime)
        sut.removeData(forRequest: urlRequest)

//        then
        XCTAssertNil(sut.data(forRequest: urlRequest), "Data must not exist")
    }
}
