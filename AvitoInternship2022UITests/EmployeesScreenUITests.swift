//
//  EmployeesScreenUITest.swift
//  AvitoInternship2022UITests
//
//  Created by Игорь Клюжев on 24.10.2022.
//

import FBSnapshotTestCase

final class EmployeesScreenUITests: FBSnapshotTestCase {
    let app = XCUIApplication()

    override func setUp() {
        super.setUp()
        fileNameOptions = [.OS, .device]
    }

    func test_checkLayout() throws {
        app.launch()

        Thread.sleep(forTimeInterval: 2.0)
        verifyView(identifier: "EmployeesScreen")
    }

    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }

    func verifyView(identifier: String,
                    perPixelTolerance: CGFloat = 0,
                    overallTolerance: CGFloat = 0.01) {
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

        let name = UIDevice.current.name

        if let ind = name.firstIndex(of: "i") {
            let model = name[ind..<name.endIndex]
            switch model {
            case "iPhone 11 Pro",
                "iPhone XS Max",
                "iPhone X",
                "iPhone 12 Pro",
                "iPhone 12 Pro Max",
                "iPhone 13 Pro Max",
                "iPhone 14 Pro Max",
                "iPhone 14 Plus",
                "iPhone XS":
                yOffset = 132
            case "iPhone XR",
                "iPhone 14",
                "iPhone 13",
                "iPhone 12",
                "iPhone 11":
                yOffset = 88
            case "iPhone 6 Plus",
                "iPhone 6S Plus",
                "iPhone 7 Plus",
                "iPhone 8 Plus":
                yOffset = 54
            default:
                yOffset = 40
            }
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
