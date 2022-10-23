//
//  MockedEmployeesScreenInteractor.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 23.10.2022.
//

import Foundation
@testable import AvitoInternship2022

final class MockedEmployeesScreenInteractor: EmployeesScreenInteractorInterface {
    var getCompanyCalls = 0
    var isForceRefresh: Bool?
    var result: Result<Company, Error>?

    func getCompany(forceRefresh: Bool, completion: @escaping (Result<AvitoInternship2022.Company, Error>) -> Void) {
        getCompanyCalls += 1
        isForceRefresh = forceRefresh

        if let result = result {
            completion(result)
        }
    }
}
