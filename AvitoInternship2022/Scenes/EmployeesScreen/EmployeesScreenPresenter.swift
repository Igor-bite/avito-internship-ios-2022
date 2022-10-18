//
//  EmployeesScreenPresenter.swift
//  avito-internship-ios-2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

import Foundation

final class EmployeesScreenPresenter {
    // MARK: - Private properties -

    private weak var view: EmployeesScreenViewInterface?
    private let interactor: EmployeesScreenInteractorInterface
    private let wireframe: EmployeesScreenWireframeInterface

    // MARK: - Lifecycle -

    init(
        view: EmployeesScreenViewInterface,
        interactor: EmployeesScreenInteractorInterface,
        wireframe: EmployeesScreenWireframeInterface
    ) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
}

// MARK: - Extensions -

extension EmployeesScreenPresenter: EmployeesScreenPresenterInterface {}
