//
//  ReusableCells.swift
//  AvitoInternTask
//
//  Created by Игорь Клюжев on 13.10.2022.
//

import Foundation

public protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
