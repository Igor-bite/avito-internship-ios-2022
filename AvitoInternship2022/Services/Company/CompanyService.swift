//
//  CompanyService.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

import Foundation

protocol CompanyService {
    func getCompany(completion: @escaping (Result<Company, Error>) -> Void)
}
