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
        static let titleHeight = 30.0
        static let titleFont = FontFamily.Lato.semiBold.font(size: titleHeight)
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

    private lazy var noInternetIconView = {
        let view = UIImageView(image: Asset.noInternet.image.withRenderingMode(.alwaysTemplate))
        view.tintColor = .Pallette.ElementColors.warningIconColor
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noInternetIconTapped)))
        view.alpha = (presenter?.isInternetConnected ?? false) ? 0.0 : 1.0
        return view
    }()

    private let noDataImage = {
        let view = UIImageView(image: Asset.noData.image)
        view.contentMode = .scaleAspectFit
        view.alpha = 0
        return view
    }()

    private lazy var dataSource = createDataSource()

    private lazy var collectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.register(cellType: EmployeeCell.self)
        collectionView.register(supplementaryViewType: EmployeesSectionHeaderView.self,
                                ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.allowsSelection = false
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.refreshControl?.beginRefreshing()
        collectionView.backgroundColor = .Pallette.ElementColors.mainBgColor

        return collectionView
    }()

    // MARK: - Lifecycle -

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true

        setupViews()
        presenter?.fetchData(forceRefresh: false)
    }

    @objc
    private func refresh() {
        presenter?.fetchData(forceRefresh: true)
    }

    @objc
    private func noInternetIconTapped() {
        presenter?.noInternetIconTapped()
    }

    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(noInternetIconView)
        view.addSubview(collectionView)
        view.addSubview(noDataImage)
        view.backgroundColor = .Pallette.ElementColors.mainBgColor

        collectionView.dataSource = dataSource
        let constraints = titleLabelConstraints() + navBarIconConstraints() + collectionViewConstraints() + noDataImageViewConstraints()
        NSLayoutConstraint.activate(constraints)
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

    func updateNoInternetIconVisibility() {
        guard let presenter = presenter else { return }
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0) {
                self.noInternetIconView.alpha = presenter.isInternetConnected ? 0.0 : 1.0
            }
        }
    }

    func updateNoDataViewVisibility(isHidden: Bool) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0) {
                self.noDataImage.alpha = isHidden ? 0.0 : 1.0
            }
        }
    }

    func showAlert(withTitle title: String, message: String?, completion: (() -> Void)?) {
        DispatchQueue.main.async { [weak self] in
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alertVC, animated: true, completion: completion)
        }
    }

    func updateLoadingIndicator(isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.collectionView.refreshControl?.beginRefreshing()
            } else {
                self.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
}

// MARK: Making constraints methods
private extension EmployeesScreenViewController {
    func titleLabelConstraints() -> [NSLayoutConstraint] {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return [
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.offset),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.offset),
            titleLabel.trailingAnchor.constraint(equalTo: noInternetIconView.leadingAnchor, constant: -Constants.offset),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Constants.titleFont.lineHeight)
        ]
    }

    private func navBarIconConstraints() -> [NSLayoutConstraint] {
        noInternetIconView.translatesAutoresizingMaskIntoConstraints = false
        return [
            noInternetIconView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            noInternetIconView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                         constant: -Constants.offset),
            noInternetIconView.widthAnchor.constraint(equalToConstant: Constants.titleHeight),
            noInternetIconView.heightAnchor.constraint(equalToConstant: Constants.titleHeight)
        ]
    }

    func collectionViewConstraints() -> [NSLayoutConstraint] {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        return [
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.offset),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ]
    }

    func noDataImageViewConstraints() -> [NSLayoutConstraint] {
        noDataImage.translatesAutoresizingMaskIntoConstraints = false
        let safeArea = view.safeAreaLayoutGuide
        return [
            noDataImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            noDataImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noDataImage.widthAnchor.constraint(lessThanOrEqualToConstant: 500),
            noDataImage.trailingAnchor.constraint(lessThanOrEqualTo: safeArea.trailingAnchor),
            noDataImage.leadingAnchor.constraint(greaterThanOrEqualTo: safeArea.leadingAnchor),
            noDataImage.widthAnchor.constraint(equalTo: noDataImage.heightAnchor)
        ]
    }
}

// MARK: Collection view reladted methods
private extension EmployeesScreenViewController {
    func createDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, item in
            self?.cell(collectionView: collectionView, indexPath: indexPath, item: item)
        }

        dataSource.supplementaryViewProvider = { [weak self] collection, kind, indexPath in
            self?.supplementary(collectionView: collection, kind: kind, indexPath: indexPath)
        }
        return dataSource
    }

    func cell(collectionView: UICollectionView, indexPath: IndexPath, item: Company.Employee) -> UICollectionViewCell? {
        guard let cell: EmployeeCell = collectionView.dequeueReusableCell(for: indexPath) else { return nil }
        cell.configure(employee: item) { [weak self] in
            self?.presenter?.phoneNumberTapped(forItemAt: indexPath)
        }
        return cell
    }

    func supplementary(collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? {
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

    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, layoutEnvironment in
            let item = self.createItem()
            let group = self.createGroup(withWidth: layoutEnvironment.container.effectiveContentSize.width,
                                         item: item)
            return self.createSection(withGroup: group)
        }
        return layout
    }

    func createItem() -> NSCollectionLayoutItem {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(300),
            heightDimension: .estimated(50)
        )
        return NSCollectionLayoutItem(layoutSize: itemSize)
    }

    func createGroup(withWidth width: CGFloat, item: NSCollectionLayoutItem) -> NSCollectionLayoutGroup{
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let columns = self.collectionViewColumnCount(for: width)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
        group.interItemSpacing = .fixed(Constants.interItemSpacing)
        return group
    }

    func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
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
        return sectionHeader
    }

    func createSection(withGroup group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection{
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: Constants.offset,
                                                        bottom: Constants.offset, trailing: Constants.offset)
        section.interGroupSpacing = Constants.interGroupSpacing
        section.boundarySupplementaryItems = [self.createHeader()]
        return section
    }

    func collectionViewColumnCount(for width: CGFloat) -> Int {
        let optimalWidth = 280
        return Int(width) / optimalWidth
    }
}
