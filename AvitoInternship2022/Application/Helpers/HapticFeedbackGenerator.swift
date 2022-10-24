//
//  HapticFeedbackGenerator.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 22.10.2022.
//

import UIKit

final class HapticFeedbackGenerator {
    static func generate(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
