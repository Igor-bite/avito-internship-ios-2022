//
//  EmployeesScreenInteractor.swift
//  avito-internship-ios-2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

import Foundation

final class EmployeesScreenInteractor {
    private let companyService: CompanyService

    init(companyService: CompanyService = CompanyFetcher()) {
        self.companyService = companyService
    }
}

// MARK: - Extensions -

extension EmployeesScreenInteractor: EmployeesScreenInteractorInterface {
    func getCompany(forceRefresh: Bool, completion: @escaping (Result<Company, Error>) -> Void) {
        companyService.getCompany(forceRefresh: forceRefresh, completion: completion)
    }
}
