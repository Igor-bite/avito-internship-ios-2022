//
//  URLOpener.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 23.10.2022.
//

import UIKit

protocol URLOpener {
    func openUrl(_ url: URL?)
}

final class BasicURLOpener: URLOpener {
    func openUrl(_ url: URL?) {
        if let url = url, UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}
