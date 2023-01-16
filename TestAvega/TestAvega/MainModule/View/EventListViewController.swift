//
//  ViewController.swift
//  TestAvega
//
//  Created by AlexKotov on 11.01.23.
//

import UIKit

private enum LayoutConstant {
    static let sectionSpacing: CGFloat = 16
    static let interItemSpacing: CGFloat = 16
    static let lineSpacing: CGFloat = 8
    static let itemsInRow: CGFloat = 2
}

typealias DataSource = UICollectionViewDiffableDataSource<Section, Event>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Event>


enum Section {
    case main
}

class EventListViewController: UIViewController {
    var presenter: EventListPresenterProtocol?
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    var refreshControl = UIRefreshControl()
    var loadingView: LoadingCollectionReusableView?
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Kazan"
        setupCollectionView()
        setupLayouts()
    }
    
}

extension EventListViewController: EventListViewProtocol {
    func presentEvents() {
        guard let events = presenter?.events else { return }
        let desc = events.map { $0.dates }
        print(desc)
        applySnapshot(animatingDifferences: false)
        refreshControl.endRefreshing()
        loadingView?.activityIndicator.stopAnimating()
    }
    
    func failure(error: Error) {
        
    }
    
    
}

extension EventListViewController {
    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: EventCollectionViewCell.identifier)
        collectionView.register(LoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingCollectionReusableView.identifier)
        
        setupRefreshControl()
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, event) ->
                UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: EventCollectionViewCell.identifier,
                    for: indexPath) as? EventCollectionViewCell
                cell?.configure(with: event)
                return cell
            })
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
          guard kind == UICollectionView.elementKindSectionFooter else {
            return nil
          }
          let loadingView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: LoadingCollectionReusableView.identifier,
            for: indexPath) as? LoadingCollectionReusableView
            self.loadingView = loadingView
          return loadingView
        }
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(presenter?.events ?? [])
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshList), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }
    
    func setupLayouts() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        ])
    }
    
    @objc func refreshList() {
        presenter?.refresh()
    }
    
    
}

extension EventListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if presenter?.isNextLoading ?? false {
            loadingView?.activityIndicator.startAnimating()
        }
        presenter?.loadNextPage(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = presenter!.events[indexPath.row]
        let detailVC = ModuleBuilder.createEventDetailView(event: event)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
}

extension EventListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.frame.width - LayoutConstant.sectionSpacing * 2 - LayoutConstant.interItemSpacing * (LayoutConstant.itemsInRow - 1)) / LayoutConstant.itemsInRow
        return CGSize(width: itemWidth, height: itemWidth * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstant.sectionSpacing, left: LayoutConstant.sectionSpacing, bottom: LayoutConstant.sectionSpacing, right: LayoutConstant.sectionSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstant.interItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.bounds.size.width, height: 20)
    }
    
}
