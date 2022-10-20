//
//  UIColor + extensions.swift
//  AvitoInternTask
//
//  Created by Игорь Клюжев on 13.10.2022.
//

import UIKit

extension UIColor {
    enum Pallette {
        static let grayColor = UIColor(red: 248 / 255, green: 248 / 255, blue: 248 / 255, alpha: 1)
        static let blueColor = UIColor(red: 73 / 255, green: 172 / 255, blue: 255 / 255, alpha: 1)

        enum ElementColors {
            static let mainBgColor = UIColor(light: .white, dark: .black)
            static let cellBgColor = grayColor
            static let textColor = UIColor(light: .black, dark: .white)
            static let iconColor = blueColor
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
}
