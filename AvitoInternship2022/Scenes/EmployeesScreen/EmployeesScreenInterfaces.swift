//
//  EmployeesScreenInterfaces.swift
//  avito-internship-ios-2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

import UIKit

protocol EmployeesScreenAssemblyInterface {
    func build() -> UIViewController
}

protocol EmployeesScreenViewInterface: ViewInterface {
    func reloadData()
    func updateNoInternetIconVisibility()
    func updateNoDataViewVisibility(isHidden: Bool)
    func showAlert(withTitle title: String, message: String?, completion: (() -> Void)?)
    func updateLoadingIndicator(isLoading: Bool)
}

protocol EmployeesScreenPresenterInterface: PresenterInterface {
    var title: String? { get }
    var activeSections: [EmployeesScreenSection] { get }
    var isInternetConnected: Bool { get }

    func fetchData(forceRefresh: Bool)
    func items(forSection section: EmployeesScreenSection) -> [Company.Employee]
    func headerTitle(forSection section: EmployeesScreenSection) -> String?
    func noInternetIconTapped()
    func phoneNumberTapped(forItemAt indexPath: IndexPath)
}

protocol EmployeesScreenInteractorInterface: InteractorInterface {
    func getCompany(forceRefresh: Bool, completion: @escaping (Result<Company, Error>) -> Void)
}
