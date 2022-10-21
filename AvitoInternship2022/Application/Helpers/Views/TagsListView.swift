//
//  TagsListView.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 21.10.2022.
//

import UIKit

class TagsListView: UIView {

// MARK: - Public properties

    var tagNames: [String] = [] {
        didSet {
            addTagLabels()
        }
    }
    var tagHeight: CGFloat = 30
    var tagPadding: CGFloat = 16
    var tagSpacingX: CGFloat = 8
    var tagSpacingY: CGFloat = 8
    var font: UIFont = .systemFont(ofSize: 17)
    var tagBackgroundColor: UIColor = .Pallette.blueColor
    var cornerRadius: CGFloat = 12

// MARK: - Private properties

    private var tagLabels = [UILabel]()

// MARK: - Public functions

    func preferredHeight(forWidth width: CGFloat) -> CGFloat {
        var currentOriginX: CGFloat = 0
        var currentOriginY: CGFloat = 0

        tagLabels.forEach { label in
            if currentOriginX + label.intrinsicContentSize.width > width {
                currentOriginX = 0
                currentOriginY += tagHeight + tagSpacingY
            }
            label.frame.origin.x = currentOriginX
            label.frame.origin.y = currentOriginY
            currentOriginX += label.frame.width + tagSpacingX
        }

        return currentOriginY + tagHeight
    }

// MARK: - Private functions

    private func addTagLabels() {
        removeTags()
        for tagName in tagNames {
            let newLabel = UILabel()
            newLabel.text = tagName
            configure(label: newLabel)

            addSubview(newLabel)
            tagLabels.append(newLabel)
        }
    }

    private func configure(label: UILabel) {
        label.font = font
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = tagBackgroundColor
        label.clipsToBounds = true
        label.layer.cornerRadius = cornerRadius
        label.frame.size.width = label.intrinsicContentSize.width + tagPadding
        label.frame.size.height = tagHeight
    }

    private func removeTags() {
        for tagLabel in tagLabels {
            tagLabel.removeFromSuperview()
        }
        tagLabels = []
    }
}
