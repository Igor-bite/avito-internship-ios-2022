//
//  RequestType.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 20.10.2022.
//

import Foundation

enum RequestType {
    case company
}

extension RequestType: TargetType {
    var baseUrl: String {
        "https://run.mocky.io/v3"
    }

    var path: String {
        switch self {
        case .company:
            return "/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
        }
    }
}
