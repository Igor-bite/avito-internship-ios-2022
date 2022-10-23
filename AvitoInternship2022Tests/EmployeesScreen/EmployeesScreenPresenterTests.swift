//
//  EmployeesScreenPresenter.swift
//  AvitoInternship2022Tests
//
//  Created by Игорь Клюжев on 23.10.2022.
//

import XCTest
@testable import AvitoInternship2022

final class EmployeesScreenPresenterTests: XCTestCase {
    private var sut: EmployeesScreenPresenter!
    private var networkMonitor: MockedNetworkMonitor!
    private var interactor: MockedEmployeesScreenInteractor!
    private var view: MockedEmployeesScreenView!
    private var urlOpener: MockedURLOpener!

    override func setUp() {
        networkMonitor = .init()
        interactor = .init()
        view = .init()
        urlOpener = .init()
        sut = .init(view: view, interactor: interactor, wireframe: EmployeesScreenWireframe(), networkMonitor: networkMonitor, urlOpener: urlOpener)
    }

    override func tearDown() {
        networkMonitor = nil
        interactor = nil
        view = nil
        urlOpener = nil
        sut = nil
    }

    func test_givenPresenter_whenInternetConnected_thenIsInternetConnectedEquals() throws {
//        given
        networkMonitor.isConnected = true

//        then
        XCTAssertEqual(sut.isInternetConnected, networkMonitor.isConnected, "Presenter should return the same connection status as network monitor")
    }

    func test_givenPresenter_whenFetchDataCalledNotFirstTimeAndNoInternet_thenShowAlertAndUpdateLoadingIndicator() throws {
//        given
        networkMonitor.isConnected = false
        interactor.result = .success(.init(name: "Name", employees: [Company.Employee(name: "name", phoneNumber: "12345", skills: [])]))

//        when
        sut.fetchData(forceRefresh: true)

        let exp1 = expectation(description: "Wait for completion of fetching")
        let result1 = XCTWaiter.wait(for: [exp1], timeout: 0.1)
        XCTAssertEqual(result1, XCTWaiter.Result.timedOut, "Delay was interrupted")

        sut.fetchData(forceRefresh: true)

        let exp2 = expectation(description: "Wait for completion of fetching")
        let result2 = XCTWaiter.wait(for: [exp2], timeout: 0.1)
        XCTAssertEqual(result2, XCTWaiter.Result.timedOut, "Delay was interrupted")

//        then
        XCTAssertEqual(view.showAlertCalls, 1, "Show alert must be called when no connection on startup")
        XCTAssertEqual(view.showAlertTitle[0], "No Internet connection", "Not correct alert title")
        XCTAssertEqual(view.showAlertMessage[0], "Please check your connection and try again", "Not correct alert message")
        XCTAssertEqual(view.updateLoadingIndicatorCalls, 2, "Update loading indicator must be called")
        XCTAssertFalse(view.updateLoadingIndicatorIsLoading[0], "Update loading indicator must be called with isLoading false")
    }

    func test_givenPresenter_whenFetchDataCalledAndInternetConnected_thenGetCompanyCalledAndNoDataVisibilityUpdated() throws {
//        given
        networkMonitor.isConnected = true
        interactor.result = .success(.init(name: "Name", employees: [Company.Employee(name: "name", phoneNumber: "12345", skills: [])]))

//        when
        sut.fetchData(forceRefresh: true)

        let exp = expectation(description: "Wait for completion of fetching")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(result, XCTWaiter.Result.timedOut, "Delay was interrupted")

//        then
        XCTAssertEqual(interactor.getCompanyCalls, 1, "Get company must be called")
        XCTAssertEqual(view.updateNoDataViewVisibilityCalls, 1, "Update no data view visibility must be called after fetch")
        XCTAssertTrue(view.updateNoDataViewVisibilityIsHidden[0], "No data image must be hidden when employees array not empty")
    }

    func test_givenPresenter_whenInteractorResultSuccess_thenReloadDataCalledAndUpdateLoadingIndicator() throws {
//        given
        networkMonitor.isConnected = true
        interactor.result = .success(.init(name: "Name", employees: [Company.Employee(name: "name", phoneNumber: "12345", skills: [])]))

//        when
        sut.fetchData(forceRefresh: true)

        let exp = expectation(description: "Wait for completion of fetching")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(result, XCTWaiter.Result.timedOut, "Delay was interrupted")

//        then
        XCTAssertEqual(view.reloadDataCalls, 1, "Reload data must be called once")
        XCTAssertEqual(view.updateLoadingIndicatorCalls, 1, "Update loading indicator must be called")
        XCTAssertFalse(view.updateLoadingIndicatorIsLoading[0], "Update loading indicator must be called with isLoading false")
    }

    func test_givenPresenter_whenInteractorResultFailure_thenShowAlertAndUpdateLoadingIndicator() throws {
//        given
        networkMonitor.isConnected = true
        let error = ServiceError.missingData
        interactor.result = .failure(error)

//        when
        sut.fetchData(forceRefresh: true)

        let exp = expectation(description: "Wait for completion of fetching")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(result, XCTWaiter.Result.timedOut, "Delay was interrupted")

//        then
        XCTAssertEqual(view.showAlertCalls, 1, "Show alert must be called when no connection on startup")
        XCTAssertEqual(view.showAlertTitle[0], "Error fetching data", "Not correct alert title")
        XCTAssertEqual(view.showAlertMessage[0], error.localizedDescription, "Not correct alert message")
        XCTAssertEqual(view.updateLoadingIndicatorCalls, 1, "Update loading indicator must be called")
        XCTAssertFalse(view.updateLoadingIndicatorIsLoading[0], "Update loading indicator must be called with isLoading false")
    }

    func test_givenPresenter_whenIsConnectedChanged_thenUpdateNoInternetIconCalledSameNumberTimes() throws {
//        given
        let values = [true, false]
        let changeTimes = 2

//        when
        networkMonitor.isConnected = values[0]
        networkMonitor.isConnected = values[1]

//        then
        XCTAssertEqual(view.updateNoInternetIconVisibilityCalls, changeTimes, "Update no internet icon calls not correct")
    }

    func test_givenPresenter_whenFetchForceRefresh_thenGetCompanyForceRefreshSameAndCalledOneTime() throws {
//        given
        networkMonitor.isConnected = true

//        when
        sut.fetchData(forceRefresh: true)

//        then
        XCTAssertEqual(interactor.getCompanyCalls, 1, "Get company must be called 1 time")
        guard let isForceRefresh = interactor.isForceRefresh else {
            XCTFail("isForceRefresh must be set")
            return
        }
        XCTAssertTrue(isForceRefresh, "Force refresh flag must be the same in fetchData and getCompany")
    }

    func test_givenPresenter_whenNoCompanyFetched_thenCompanyEmployeesEmptyAndHeaderTitleNil() throws {
        XCTAssertEqual(sut.items(forSection: .all), [], "Items for sections must be equal to empty array when no company fetched")
        XCTAssertNil(sut.headerTitle(forSection: .all), "Header title must be nil when no company fetched")
    }

    func test_givenPresenter_whenItemForSectionCalled_thenCompanyEmployeesReturned() throws {
//        given
        networkMonitor.isConnected = true
        let employees = [Company.Employee(name: "name", phoneNumber: "12345", skills: [])]
        interactor.result = .success(.init(name: "Name", employees: employees))

//        when
        sut.fetchData(forceRefresh: true)

        let exp = expectation(description: "Wait for completion of fetching")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(result, XCTWaiter.Result.timedOut, "Delay was interrupted")

//        then
        XCTAssertEqual(sut.items(forSection: .all), employees, "Items for sections must be equal to company employees")
    }

    func test_givenPresenter_whenHeaderTitleCalled_thenCompanyNameReturned() throws {
//        given
        networkMonitor.isConnected = true
        let company = Company(name: "Name", employees: [.init(name: "name", phoneNumber: "12345", skills: [])])
        interactor.result = .success(company)

//        when
        sut.fetchData(forceRefresh: true)

        let exp = expectation(description: "Wait for completion of fetching")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(result, XCTWaiter.Result.timedOut, "Delay was interrupted")

//        then
        XCTAssertEqual(sut.headerTitle(forSection: .all), company.name, "Header title must be equal to company name")
    }

    func test_givenPresenter_whennoInternetIconTapped_thenShowAlert() throws {
//        when
        sut.noInternetIconTapped()

//        then
        XCTAssertEqual(view.showAlertCalls, 1, "Presenter must call showAlert 1 time")
        XCTAssertEqual(view.showAlertTitle[0], "No Internet connection", "Title not correct")
        XCTAssertNil(view.showAlertMessage[0], "Alert message must be nil")
    }

    func test_givenPresenter_whenPhoneNumberTapped_thenUrlOpened() throws {
//        given
        networkMonitor.isConnected = true
        interactor.result = .success(.init(name: "Name", employees: [.init(name: "name", phoneNumber: "12345", skills: [])]))

//        when
        sut.fetchData(forceRefresh: true)

        let exp = expectation(description: "Wait for completion of fetching")
        let result = XCTWaiter.wait(for: [exp], timeout: 0.1)
        XCTAssertEqual(result, XCTWaiter.Result.timedOut, "Delay was interrupted")

        sut.phoneNumberTapped(forItemAt: .init(row: 0, section: 0))

//        then
        XCTAssertEqual(urlOpener.openUrlCalls, 1, "Presenter should open url to call when phone number tapped 1 time")
    }
}
