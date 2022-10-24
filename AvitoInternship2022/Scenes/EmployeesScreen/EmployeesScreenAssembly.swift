//
//  EmployeesScreenAssembly.swift
//  avito-internship-ios-2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

import UIKit

final class EmployeesScreenAssembly {
    // MARK: - Module setup -

    func build() -> UIViewController {
        let view = EmployeesScreenViewController()
        let interactor = EmployeesScreenInteractor()
        let presenter = EmployeesScreenPresenter(view: view, interactor: interactor)
        view.presenter = presenter

        return view
    }
}
