//
//  EmployeeCell.swift
//  AvitoInternship2022
//
//  Created by Игорь Клюжев on 20.10.2022.
//

import UIKit

final class EmployeeCell: UICollectionViewCell, Reusable {
    private enum Constants {
        static let contentViewOffset = 15.0
        static let innerViewsOffset = 15.0
        static let cornerRadius = 5.0

        enum Icon {
            static let phoneImageName = "phone.circle"
            static let bigSizeSide = 50.0
            static let smallSizeSide = 20.0
        }

        enum Tags {
            static let backgroundColor = UIColor.Pallette.blueColor
            static let tagHeight = 30.0
            static let padding = 16.0
            static let font = FontFamily.Lato.semiBold.font(size: 17)
            static let spacing = 8.0
            static let cornerRadius = 12.0
        }
    }

    private let avatarImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constants.Icon.bigSizeSide / 2
        view.clipsToBounds = true
        view.tintColor = .Pallette.ElementColors.iconColor
        return view
    }()

    private let nameLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .Pallette.ElementColors.textColor
        label.font = FontFamily.Lato.bold.font(size: 25)
        return label
    }()

    private lazy var phoneImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: Constants.Icon.phoneImageName)
        view.tintColor = .Pallette.ElementColors.iconColor
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(numberTapped)))
        return view
    }()

    private lazy var phoneNumberLabel = {
        let label = UILabel()
        label.textColor = .Pallette.ElementColors.textColor
        label.font = FontFamily.Lato.regular.font(size: 15)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(numberTapped)))
        return label
    }()

    private var numberTapAction: (() -> Void)?

    private let skillsListView = {
        let view = TagsListView(frame: .zero)
        view.backgroundColor = .clear
        view.tagBackgroundColor = Constants.Tags.backgroundColor
        view.font = Constants.Tags.font
        view.tagHeight = Constants.Tags.tagHeight
        view.tagSpacingX = Constants.Tags.spacing
        view.tagSpacingY = Constants.Tags.spacing
        view.tagPadding = Constants.Tags.padding
        view.cornerRadius = Constants.Tags.cornerRadius
        return view
    }()

    private var skillsHeightConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .Pallette.ElementColors.cellBgColor
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true

        setupViews()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(employee: Company.Employee, onNumberTap: (() -> Void)? = nil) {
        numberTapAction = onNumberTap
        nameLabel.text = employee.name
        phoneNumberLabel.text = employee.phoneNumber
        let avatarSize = CGSize(width: Constants.Icon.bigSizeSide, height: Constants.Icon.bigSizeSide)
        avatarImageView.image = UserAvatarGenerator.generateUserImage(userName: employee.name, withSize: avatarSize)
        skillsListView.tagNames = employee.skills
    }

    private func setupViews() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneImageView)
        contentView.addSubview(phoneNumberLabel)
        contentView.addSubview(skillsListView)

        let constraints = constraintsForContentView() +
            constraintsForImageView() + constraintsForNameLabel() +
            constraintsForPhoneImageView() + constraintsForPhoneNumberLabel() +
            constraintsForSkillsCollection()

        NSLayoutConstraint.activate(constraints)
    }

    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        skillsHeightConstraint?.constant = skillsListView.preferredHeight(forWidth: frame.width - Constants.innerViewsOffset * 4)

        return super.preferredLayoutAttributesFitting(layoutAttributes)
    }

    @objc
    private func numberTapped() {
        numberTapAction?()
    }
}

//MARK: - Constraints related methods

private extension EmployeeCell {
    private func constraintsForContentView() -> [NSLayoutConstraint] {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return [
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
    }

    private func constraintsForImageView() -> [NSLayoutConstraint] {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false

        let top = avatarImageView.topAnchor.constraint(equalTo: nameLabel.topAnchor)
        let trail = avatarImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        trail.constant = -Constants.innerViewsOffset

        let width = avatarImageView.widthAnchor.constraint(equalToConstant: Constants.Icon.bigSizeSide)
        let height = avatarImageView.heightAnchor.constraint(equalToConstant: Constants.Icon.bigSizeSide)

        return [
            top,
            trail,
            width,
            height
        ]
    }

    private func constraintsForNameLabel() -> [NSLayoutConstraint] {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        let top = nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor)
        top.constant = Constants.innerViewsOffset
        let trail = nameLabel.trailingAnchor.constraint(equalTo: avatarImageView.leadingAnchor)
        trail.constant = -Constants.innerViewsOffset / 2
        let lead = nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        lead.constant = Constants.innerViewsOffset

        return [
            top,
            trail,
            lead
        ]
    }

    private func constraintsForPhoneImageView() -> [NSLayoutConstraint] {
        phoneImageView.translatesAutoresizingMaskIntoConstraints = false

        let top = phoneImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor)
        top.constant = Constants.innerViewsOffset / 2
        let lead = phoneImageView.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor)

        let width = phoneImageView.widthAnchor.constraint(equalToConstant: Constants.Icon.smallSizeSide)
        let height = phoneImageView.heightAnchor.constraint(equalToConstant: Constants.Icon.smallSizeSide)

        return [
            top,
            lead,
            width,
            height
        ]
    }

    private func constraintsForPhoneNumberLabel() -> [NSLayoutConstraint] {
        phoneNumberLabel.translatesAutoresizingMaskIntoConstraints = false

        let centerY = phoneNumberLabel.centerYAnchor.constraint(equalTo: phoneImageView.centerYAnchor)
        let lead = phoneNumberLabel.leadingAnchor.constraint(equalTo: phoneImageView.trailingAnchor)
        lead.constant = Constants.innerViewsOffset / 2
        let trail = phoneNumberLabel.trailingAnchor.constraint(lessThanOrEqualTo: avatarImageView.leadingAnchor)

        return [
            centerY,
            lead,
            trail
        ]
    }

    private func constraintsForSkillsCollection() -> [NSLayoutConstraint] {
        skillsListView.translatesAutoresizingMaskIntoConstraints = false

        let top = skillsListView.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor,
                                                      constant: Constants.innerViewsOffset)
        let lead = skillsListView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                           constant: Constants.innerViewsOffset)
        let trail = skillsListView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                             constant: -Constants.innerViewsOffset)
        let bottom = skillsListView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,
                                                            constant: -Constants.innerViewsOffset)
        bottom.priority = .defaultHigh

        let height = skillsListView.heightAnchor.constraint(equalToConstant: 10)
        skillsHeightConstraint = height

        return [
            top,
            bottom,
            lead,
            trail,
            height
        ]
    }
}
