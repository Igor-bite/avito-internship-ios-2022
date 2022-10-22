//
//  EmployeesScreenViewController.swift
//  avito-internship-ios-2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

import UIKit

final class EmployeesScreenViewController: UIViewController {
    private enum Constants {
        static let offset = 15.0
        static let interGroupSpacing = offset / 2
        static let interItemSpacing = offset / 2
        static let titleFont = FontFamily.Lato.semiBold.font(size: 30.0)
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<EmployeesScreenSection, Company.Employee>
    typealias DataSource = UICollectionViewDiffableDataSource<EmployeesScreenSection, Company.Employee>

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

    private lazy var dataSource = createDataSource()

    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
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

    private func createDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            self?.cell(collectionView: collectionView, indexPath: indexPath, item: item)
        }

        dataSource.supplementaryViewProvider = { [weak self] collection, kind, indexPath in
            self?.supplementary(collectionView: collection, kind: kind, indexPath: indexPath)
        }
        return dataSource
    }

    private func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Company.Employee) -> UICollectionViewCell? {
        guard let cell: EmployeeCell = collectionView.dequeueReusableCell(for: indexPath) else { return nil }
        cell.configure(employee: item)
        return cell
    }

    private func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
        guard
            let sectionHeader: EmployeesSectionHeaderView =
                collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath)
        else {
            return nil
        }
        let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
        sectionHeader.configure(withTitle: presenter?.headerTitle(forSection: section))
        return sectionHeader
    }

    private func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .estimated(300),
                heightDimension: .estimated(50)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(50)
            )
            let columns = self.collectionViewColumnCount(for: layoutEnvironment.container.effectiveContentSize.width)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(Constants.interItemSpacing)

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.offset,
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

            return section
        }
        return layout
    }

    private func collectionViewColumnCount(for width: CGFloat) -> Int {
        let optimalWidth = 280
        return Int(width) / optimalWidth
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
        var snapshot = Snapshot()
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
