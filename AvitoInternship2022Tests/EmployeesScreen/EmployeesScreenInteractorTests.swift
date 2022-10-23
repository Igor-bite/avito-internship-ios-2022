//
//  EmployeesScreenInteractorTests.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 23.10.2022.
//

import XCTest
@testable import AvitoInternship2022

final class EmployeesScreenInteractorTests: XCTestCase {
    private var companyService: MockedCompanyService!
    private var sut: EmployeesScreenInteractor!
    private let company = Company(name: "name",
                                  employees: [
                                    .init(name: "name", phoneNumber: "number", skills: ["skill"])
                                  ])
    private let error = ServiceError.missingData

    override func setUp() {
        companyService = .init()
        sut = EmployeesScreenInteractor(companyService: companyService)
    }

    override func tearDown() {
        companyService = nil
        sut = nil
    }

    func test_givenInteractor_whenSuccessResultInCompanyService_thenSuccessResult() throws {
//        given
        companyService.result = .success(company)

//        when
        let exp = expectation(description: "Wait for completion")
        sut.getCompany(forceRefresh: true) { fetchedResult in

//            then
            switch fetchedResult {
            case .success(let retrievedCompany):
                XCTAssert(retrievedCompany == self.company, "Company retrieved must be the same")
            case .failure(let error):
                XCTFail("Must be success, but got error: \(error.localizedDescription)")
            }
            exp.fulfill()
        }

        XCTAssertEqual(companyService.getCompanyCalls, 1, "Not correct number of calls to service")
        wait(for: [exp], timeout: 1.0)
    }

    func test_givenInteractor_whenFailureResultInCompanyService_thenSuccessResult() throws {
//        given
        companyService.result = .failure(error)

//        when
        let exp = expectation(description: "Wait for completion")
        sut.getCompany(forceRefresh: true) { fetchedResult in

//            then
            switch fetchedResult {
            case .success:
                XCTFail("Must be failure")
            case .failure(let retrievedError):
                guard let retrievedError = retrievedError as? ServiceError else {
                    XCTFail("Retrieved error type must be the same")
                    return
                }
                XCTAssert(retrievedError == self.error, "Error retrieved must be the same")
            }
            exp.fulfill()
        }

        XCTAssertEqual(companyService.getCompanyCalls, 1, "Not correct number of calls to service")
        wait(for: [exp], timeout: 1.0)
    }
}
