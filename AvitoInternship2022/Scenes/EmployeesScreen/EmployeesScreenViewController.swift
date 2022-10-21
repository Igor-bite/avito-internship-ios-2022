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
        ) { collectionView, indexPath, employee -> UICollectionViewCell? in

            guard let cell: EmployeeCell = collectionView.dequeueReusableCell(for: indexPath)
            else { return nil }

            cell.configure(employee: employee)
            return cell
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
            self.dataSource.apply(snapshot)
        }
    }
}
