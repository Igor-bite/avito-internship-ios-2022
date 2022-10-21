//
//  EmployeesScreenInterfaces.swift
//  avito-internship-ios-2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

protocol EmployeesScreenWireframeInterface: WireframeInterface {}

protocol EmployeesScreenViewInterface: ViewInterface {
    func reloadData()
}

protocol EmployeesScreenPresenterInterface: PresenterInterface {
    var title: String? { get }
    var activeSections: [EmployeesScreenSection] { get }

    func fetchData()
    func items(forSection section: EmployeesScreenSection) -> [Company.Employee]
}

protocol EmployeesScreenInteractorInterface: InteractorInterface {
    func getCompany(completion: @escaping (Result<Company, Error>) -> Void)
}
