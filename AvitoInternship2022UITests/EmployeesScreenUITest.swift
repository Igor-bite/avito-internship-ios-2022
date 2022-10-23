//
//  EmployeesScreenUITest.swift
//  AvitoInternship2022UITests
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import FBSnapshotTestCase

final class EmployeesScreenUITest: FBSnapshotTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        fileNameOptions = [.OS, .device]
        app.launch()
    }

    func test_checkLayout() throws {
        Thread.sleep(forTimeInterval: 2.0)

        verifyView(identifier: "EmployeesScreen")
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }

    func verifyView(identifier: String,
                    perPixelTolerance: CGFloat = 0,
                    overallTolerance: CGFloat = 0.001) {
        guard let screenshotWithoutStatusBar = app.screenshot().image.removingStatusBar else {
            return XCTFail("An error occurred while cropping the screenshot", file: #file, line: #line)
        }
        FBSnapshotVerifyView(UIImageView(image: screenshotWithoutStatusBar), identifier: identifier, perPixelTolerance: perPixelTolerance, overallTolerance: overallTolerance)
    }
}

extension UIImage {

    var removingStatusBar: UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }

        var yOffset: CGFloat = 0

        switch UIDevice.current.model {
        case "Simulator iPhone 11 Pro",
            "Simulator iPhone XS Max",
            "Simulator iPhone X",
            "Simulator iPhone 12 Pro",
            "Simulator iPhone 12 Pro Max",
            "Simulator iPhone XS":
            yOffset = 132
        case "Simulator iPhone XR",
            "Simulator iPhone 12",
            "Simulator iPhone 11":
            yOffset = 88
        case "Simulator iPhone 6 Plus",
            "Simulator iPhone 6S Plus",
            "Simulator iPhone 7 Plus",
            "Simulator iPhone 8 Plus":
            yOffset = 54
        default:
            yOffset = 40
        }

        let rect = CGRect(
            x: 0,
            y: Int(yOffset),
            width: cgImage.width,
            height: cgImage.height - Int(yOffset)
        )

        if let croppedCGImage = cgImage.cropping(to: rect) {
            return UIImage(cgImage: croppedCGImage, scale: scale, orientation: imageOrientation)
        }

        return nil
    }
}
