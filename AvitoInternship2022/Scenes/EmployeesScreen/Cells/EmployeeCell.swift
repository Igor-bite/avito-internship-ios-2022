//
//  EmployeeCell.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 20.10.2022.
//

import UIKit

final class EmployeeCell: UICollectionViewCell, Reusable {
    private enum Constants {
        static let contentViewOffset = 20.0
        static let innerViewsOffset = 20.0
    }

    private let imageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person")
        view.tintColor = .black
        return view
    }()

    private let nameLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .black
        label.font = FontFamily.Lato.bold.font(size: 21)
        return label
    }()

    private let phoneImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "phone")
        view.tintColor = .black
        return view
    }()

    private let phoneNumberLabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = FontFamily.Lato.bold.font(size: 15)
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
        nameLabel.text = employee.name
        phoneNumberLabel.text = employee.phoneNumber
    }

    private func setupViews() {
        widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - Constants.contentViewOffset * 2).isActive = true
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneImageView)
        contentView.addSubview(phoneNumberLabel)

        let constraints = constraintsForContentView() +
        constraintsForImageView() + constraintsForNameLabel() +
        constraintsForPhoneImageView() + constraintsForPhoneNumberLabel()

        NSLayoutConstraint.activate(constraints)
    }

    private func constraintsForContentView() -> [NSLayoutConstraint] {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return [
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
    }

    private func constraintsForImageView() -> [NSLayoutConstraint] {
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let top = imageView.topAnchor.constraint(equalTo: contentView.topAnchor)
        top.constant = Constants.innerViewsOffset
        let lead = imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        lead.constant = Constants.innerViewsOffset

        let width = imageView.widthAnchor.constraint(equalToConstant: 30)
        let height = imageView.heightAnchor.constraint(equalToConstant: 30)

        return [
            top,
            lead,
            width,
            height
        ]
    }

    private func constraintsForNameLabel() -> [NSLayoutConstraint] {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let centerY = nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        let lead = nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor)
        lead.constant = Constants.innerViewsOffset
        let trail = nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        trail.constant = -Constants.innerViewsOffset

        return [
            centerY,
            lead,
            trail
        ]
    }

    private func constraintsForPhoneImageView() -> [NSLayoutConstraint] {
        phoneImageView.translatesAutoresizingMaskIntoConstraints = false

        let top = phoneImageView.topAnchor.constraint(equalTo: imageView.bottomAnchor)
        top.constant = Constants.innerViewsOffset
        let centerX = phoneImageView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)

        let width = phoneImageView.widthAnchor.constraint(equalToConstant: 20)
        let height = phoneImageView.heightAnchor.constraint(equalToConstant: 20)

        return [
            top,
            centerX,
            width,
            height
        ]
    }

    private func constraintsForPhoneNumberLabel() -> [NSLayoutConstraint] {
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false

        let centerY = phoneNumberLabel.centerYAnchor.constraint(equalTo: phoneImageView.centerYAnchor)
        let lead = phoneNumberLabel.leadingAnchor.constraint(equalTo: phoneImageView.trailingAnchor)
        lead.constant = Constants.innerViewsOffset / 2
        let trail = phoneNumberLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        trail.constant = -Constants.innerViewsOffset
        let bottom = phoneNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        bottom.constant = -Constants.innerViewsOffset

        return [
            centerY,
            lead,
            trail,
            bottom
        ]
    }
}
