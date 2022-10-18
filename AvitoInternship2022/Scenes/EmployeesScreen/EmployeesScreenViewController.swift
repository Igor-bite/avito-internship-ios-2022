//
//  EmployeesScreenViewController.swift
//  avito-internship-ios-2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

import UIKit

final class EmployeesScreenViewController: UIViewController {
    // MARK: - Public properties -

    var presenter: EmployeesScreenPresenterInterface?

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Extensions -

extension EmployeesScreenViewController: EmployeesScreenViewInterface {}
