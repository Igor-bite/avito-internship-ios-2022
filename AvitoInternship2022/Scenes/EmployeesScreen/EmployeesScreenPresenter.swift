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
    private let networkMonitor = NetworkMonitor.shared

    private var company: Company? {
        didSet {
            if oldValue?.employees != company?.employees {
                sortedEmployees = company?.employees.sorted { $0.name < $1.name }
            }
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

        NotificationCenter.default.addObserver(self, selector: #selector(connectivityStatusChanged), name: .connectivityStatus, object: nil)
    }

    @objc
    private func connectivityStatusChanged() {
        view?.updateNoInternetIconVisibility()
        HapticFeedbackGenerator.generate(networkMonitor.isConnected ? .success : .warning)
    }

    private func showAlert(withTitle title: String, message: String?, completion: (() -> Void)? = nil) {
        HapticFeedbackGenerator.generate(.warning)
        view?.showAlert(withTitle: title, message: message, completion: completion)
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

    var isInternetConnected: Bool {
        networkMonitor.isConnected
    }

    func fetchData(forceRefresh: Bool) {
        if !networkMonitor.isConnected && company != nil {
            showAlert(withTitle: "No Internet connection", message: "Please check your connection and try again") {
                self.view?.updateLoadingIndicator(isLoading: false)
            }
            view?.updateNoDataViewVisibility(isHidden: !(sortedEmployees?.isEmpty ?? true))
            return
        }

        interactor.getCompany(forceRefresh: forceRefresh) { [weak self] result in
            switch result {
            case .success(let company):
                self?.company = company
                self?.view?.updateLoadingIndicator(isLoading: false)
            case .failure(let error):
                self?.showAlert(withTitle: "Error fetching data", message: error.localizedDescription) {
                    self?.view?.updateLoadingIndicator(isLoading: false)
                }
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
            let hasNoData = sortedEmployees?.isEmpty ?? true
            return hasNoData ? nil : company?.name
        }
    }

    func noInternetIconTapped() {
        showAlert(withTitle: "No Internet connection", message: nil)
    }
}
