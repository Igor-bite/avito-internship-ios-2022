//
//  EmployeesScreenViewController.swift
//  avito-internship-ios-2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

import UIKit

final class EmployeesScreenViewController: UIViewController {
    private enum Constants {
        static let offset = 20.0
        static let interGroupSpacing = offset / 2
        static let interItemSpacing = offset / 2
        static let titleFont = FontFamily.Lato.semiBold.font(size: 30.0)
    }

    // MARK: - Public properties -

    var presenter: EmployeesScreenPresenterInterface?

    // MARK: - Private properties -

    private lazy var titleLabel = {
        let label = UILabel()
        label.text = presenter?.title
        label.font = Constants.titleFont
        label.textColor = .Pallette.ElementColors.textColor
        return label
    }()

    private lazy var dataSource = makeDataSource()

    private lazy var collectionView = {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(300),
            heightDimension: .estimated(50)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(Constants.interItemSpacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: Constants.offset, leading: Constants.offset,
                                                        bottom: Constants.offset, trailing: Constants.offset)
        section.interGroupSpacing = Constants.interGroupSpacing

        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true
        section.boundarySupplementaryItems = [sectionHeader]

        let layout = UICollectionViewCompositionalLayout(section: section)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: EmployeeCell.self)
        collectionView.register(supplementaryViewType: EmployeesSectionHeaderView.self,
                                ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.allowsSelection = false

        return collectionView
    }()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true

        setupViews()
        presenter?.fetchData()
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.backgroundColor = .Pallette.ElementColors.mainBgColor

        collectionView.dataSource = dataSource
        let constraints = titleLabelConstraints() + collectionViewConstraints()
        NSLayoutConstraint.activate(constraints)
    }

    private func titleLabelConstraints() -> [NSLayoutConstraint] {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.offset),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: Constants.offset)
        ]
    }

    private func collectionViewConstraints() -> [NSLayoutConstraint] {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        return [
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.offset),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ]
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<EmployeesScreenSection, Company.Employee> {
        let dataSource = UICollectionViewDiffableDataSource<EmployeesScreenSection, Company.Employee>(
            collectionView: collectionView
        ) { collectionView, indexPath, employee in

            guard let cell: EmployeeCell = collectionView.dequeueReusableCell(for: indexPath)
            else { return nil }

            cell.configure(employee: employee)
            return cell
        }
        dataSource.supplementaryViewProvider = { [weak self] collection, kind, indexPath in
            self?.supplementary(collectionView: collection, kind: kind, indexPath: indexPath)
        }
        return dataSource
    }

    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        guard
            let sectionHeader: EmployeesSectionHeaderView =
                collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, for: indexPath)
        else {
            assertionFailure("Could not dequeue sectionHeader")
            return nil
        }
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        sectionHeader.configure(withTitle: presenter?.headerTitle(forSection: section))
        return sectionHeader
    }
}

// MARK: - Extensions -

extension EmployeesScreenViewController: EmployeesScreenViewInterface {
    func reloadData() {
        guard let presenter = presenter
        else {
            assertionFailure("Data source for collection view is missing")
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<EmployeesScreenSection, Company.Employee>()
        let activeSections = presenter.activeSections
        snapshot.appendSections(activeSections)
        activeSections.forEach { section in
            snapshot.appendItems(presenter.items(forSection: section), toSection: section)
        }

        DispatchQueue.main.async {
            self.dataSource.apply(snapshot)
        }
    }
}
