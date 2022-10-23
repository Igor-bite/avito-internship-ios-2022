//
//  AvitoInternship2022UITestsLaunchTests.swift
//  AvitoInternship2022UITests
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import XCTest

final class AvitoInternship2022UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "EmployeesScreen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
