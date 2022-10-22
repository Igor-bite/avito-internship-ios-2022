//
//  EmployeesSectionHeaderView.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 22.10.2022.
//

import UIKit

final class EmployeesSectionHeaderView: UICollectionReusableView, Reusable {
    private enum Constants {
        static let fontSize = 20.0
        static let font = FontFamily.Lato.semiBold.font(size: fontSize)
        static let offset = 10.0
    }

    private let titleLabel = {
        let label = UILabel()
        label.textColor = .Pallette.ElementColors.secondaryTextColor
        label.font = Constants.font
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(withTitle title: String?) {
        titleLabel.text = title
    }

    private func setupViews() {
        backgroundColor = .systemBackground
        addSubview(titleLabel)
        let constraints = constraintsForTitleLabel()
        NSLayoutConstraint.activate(constraints)
    }

    private func constraintsForTitleLabel() -> [NSLayoutConstraint] {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return [
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.offset),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.offset),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.offset)
        ]
    }
}
