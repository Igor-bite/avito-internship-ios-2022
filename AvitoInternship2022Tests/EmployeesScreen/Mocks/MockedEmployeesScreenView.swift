//
//  MockedEmployeesScreenView.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 23.10.2022.
//

import Foundation
@testable import AvitoInternship2022

final class MockedEmployeesScreenView: EmployeesScreenViewInterface {
    var reloadDataCalls = 0

    var updateNoInternetIconVisibilityCalls = 0

    var updateNoDataViewVisibilityCalls = 0
    var updateNoDataViewVisibilityIsHidden = [Bool]()

    var showAlertCalls = 0
    var showAlertTitle = [String]()
    var showAlertMessage = [String?]()

    var updateLoadingIndicatorCalls = 0
    var updateLoadingIndicatorIsLoading = [Bool]()

    func reloadData() {
        reloadDataCalls += 1
    }

    func updateNoInternetIconVisibility() {
        updateNoInternetIconVisibilityCalls += 1
    }

    func updateNoDataViewVisibility(isHidden: Bool) {
        updateNoDataViewVisibilityCalls += 1
        updateNoDataViewVisibilityIsHidden.append(isHidden)
    }

    func showAlert(withTitle title: String, message: String?, completion: (() -> Void)?) {
        showAlertCalls += 1
        showAlertTitle.append(title)
        showAlertMessage.append(message)
        completion?()
    }

    func updateLoadingIndicator(isLoading: Bool) {
        updateLoadingIndicatorCalls += 1
        updateLoadingIndicatorIsLoading.append(isLoading)
    }
}
