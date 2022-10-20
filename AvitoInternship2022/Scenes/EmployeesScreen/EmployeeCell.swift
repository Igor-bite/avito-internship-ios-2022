//
//  EmployeeCell.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 20.10.2022.
//

import UIKit

final class EmployeeCell: UICollectionViewCell, Reusable {
    private enum Constants {
        static let offset = 20.0
    }

    private let titleLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = FontFamily.Lato.bold.font(size: 21)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .lightGray.withAlphaComponent(0.6)
        layer.cornerRadius = 5
        clipsToBounds = true

        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(employee: Company.Employee) {
        titleLabel.text = employee.name
    }

    private func setupViews() {
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 40).isActive = true

        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        contentView.addSubview(titleLabel)

        setupTitle()
    }

    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let top = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        top.constant = Constants.offset
        let lead = titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        lead.constant = Constants.offset
        let trail = titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        trail.constant = -Constants.offset
        let bottom = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottom.constant = -Constants.offset

        let constraints = [
            top,
            lead,
            trail,
            bottom
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
