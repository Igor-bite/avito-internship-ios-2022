//
//  UIColor + extensions.swift
//  AvitoInternTask
//
//  Created by Игорь Клюжев on 13.10.2022.
//

import UIKit

extension UIColor {
    enum Pallette {
        static let grayColor = UIColor(light: UIColor(red: 233 / 255, green: 236 / 255, blue: 239 / 255, alpha: 1),
                                       dark: UIColor(red: 33 / 255, green: 37 / 255, blue: 41 / 255, alpha: 1))
        static let blueColor = UIColor(red: 73 / 255, green: 172 / 255, blue: 255 / 255, alpha: 1)
        static let orangeColor = UIColor.systemOrange

        enum ElementColors {
            static let mainBgColor = UIColor.systemBackground
            static let cellBgColor = grayColor
            static let textColor = UIColor.systemBackground.themeInverted
            static let secondaryTextColor = UIColor(light: .gray, dark: .lightGray)
            static let iconColor = blueColor
            static let warningIconColor = orangeColor
        }
    }

    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            if traitCollection.userInterfaceStyle == .dark {
                return dark
            }
            return light
        }
    }

    var lightThemeColor: UIColor {
        resolvedColor(with: .init(userInterfaceStyle: .light))
    }

    var darkThemeColor: UIColor {
        resolvedColor(with: .init(userInterfaceStyle: .dark))
    }

    var themeInverted: UIColor {
        .init(light: darkThemeColor, dark: lightThemeColor)
    }

    static func generateColorFor(text: String) -> UIColor {
        var hash = 0
        let colorConstant = 131
        let maxSafeValue = Int.max / colorConstant
        for char in text.unicodeScalars {
            if hash > maxSafeValue {
                hash /= colorConstant
            }
            hash = Int(char.value) + ((hash << 5) - hash)
        }
        let finalHash = abs(hash) % (256 * 256 * 256)
        let color = UIColor(hue: CGFloat(finalHash) / 255.0, saturation: 0.5, brightness: 0.75, alpha: 1.0)
        return color
    }
}
