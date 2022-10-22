//
//  EmployeesScreenWireframe.swift
//  avito-internship-ios-2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

import UIKit

final class EmployeesScreenWireframe: BaseWireframe<EmployeesScreenViewController> {
    // MARK: - Private properties -

    // MARK: - Module setup -

    init() {
        let moduleViewController = EmployeesScreenViewController()
        super.init(viewController: moduleViewController)

        let interactor = EmployeesScreenInteractor()
        let presenter = EmployeesScreenPresenter(view: moduleViewController, interactor: interactor, wireframe: self)
        moduleViewController.presenter = presenter
    }
}

// MARK: - Extensions -

extension EmployeesScreenWireframe: EmployeesScreenWireframeInterface {}
