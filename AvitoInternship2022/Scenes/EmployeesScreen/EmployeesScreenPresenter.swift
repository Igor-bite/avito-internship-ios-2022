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

    private var company: Company? {
        didSet {
            sortedEmployees = company?.employees.sorted { $0.name < $1.name }
        }
    }

    private var sortedEmployees: [Company.Employee]? {
        didSet {
            view?.reloadData()
        }
    }

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

extension EmployeesScreenPresenter: EmployeesScreenPresenterInterface {
    var title: String? {
        "Employees"
    }

    var activeSections: [EmployeesScreenSection] {
        EmployeesScreenSection.allCases
    }

    func fetchData() {
        interactor.getCompany { result in
            switch result {
            case .success(let company):
                self.company = company
            case .failure(let error):
                print("Error: \(error.localizedDescription)") // TODO: add handling error
            }
        }
    }

    func items(forSection section: EmployeesScreenSection) -> [Company.Employee] {
        switch section {
        case .all:
            return sortedEmployees ?? []
        }
    }

    func headerTitle(forSection section: EmployeesScreenSection) -> String? {
        switch section {
        case .all:
            return company?.name
        }
    }
}
