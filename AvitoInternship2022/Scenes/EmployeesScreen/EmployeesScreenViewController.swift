//
//  EmployeesScreenViewController.swift
//  avito-internship-ios-2022
//
//  Created by Игорь Клюжев on 18.10.2022.
//

import UIKit

final class EmployeesScreenViewController: UIViewController {
    // MARK: - Public properties -

    var presenter: EmployeesScreenPresenterInterface?

    // MARK: - Private properties -

    private lazy var dataSource = makeDataSource()

    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(cellType: EmployeeCell.self)
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
        view.addSubview(collectionView)
        view.backgroundColor = .Pallette.ElementColors.mainBgColor

        collectionView.dataSource = dataSource
        let constraints = collectionViewConstraints()
        NSLayoutConstraint.activate(constraints)
    }

    private func collectionViewConstraints() -> [NSLayoutConstraint] {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return [
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ]
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<EmployeesScreenSection, Company.Employee> {
        let dataSource = UICollectionViewDiffableDataSource<EmployeesScreenSection, Company.Employee>(
            collectionView: collectionView
        ) { collectionView, indexPath, employee -> UICollectionViewCell? in

            let cell: EmployeeCell? = collectionView.dequeueReusableCell(for: indexPath)
            if let cell = cell {
                cell.configure(employee: employee)
                return cell
            }

            return .init()
        }

        return dataSource
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
            self.dataSource.apply(snapshot, animatingDifferences: true)
        }
    }
}
