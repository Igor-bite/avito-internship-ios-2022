//
//  MockedCompanyService.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 23.10.2022.
//

import Foundation
import XCTest
@testable import AvitoInternship2022

final class MockedCompanyService: CompanyService {
    var getCompanyCalls = 0
    var result: Result<Company, Error>?

    func getCompany(forceRefresh: Bool, completion: @escaping (Result<Company, Error>) -> Void) {
        getCompanyCalls += 1

        if let result = result {
            completion(result)
        }
    }
}
