//
//  EmployeesScreenInterfaces.swift
//  avito-internship-ios-2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

protocol EmployeesScreenWireframeInterface: WireframeInterface {}

protocol EmployeesScreenViewInterface: ViewInterface {}

protocol EmployeesScreenPresenterInterface: PresenterInterface {}

protocol EmployeesScreenInteractorInterface: InteractorInterface {
    func getCompany(completion: @escaping (Result<Company, Error>) -> Void)
}
