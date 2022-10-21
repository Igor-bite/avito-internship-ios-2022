//
//  CompanyModel.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

import Foundation

struct Company: Codable {
    struct Employee: Codable, Hashable {
        let name: String
        let phoneNumber: String
        let skills: [String]
    }

    let name: String
    let employees: [Employee]
}
