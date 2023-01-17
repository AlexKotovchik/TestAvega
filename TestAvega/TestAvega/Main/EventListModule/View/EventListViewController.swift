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
    var presenter: EventListPresenterProtocol!
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = LayoutConstant.lineSpacing
        layout.minimumInteritemSpacing = LayoutConstant.interItemSpacing
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    var refreshControl = UIRefreshControl()
    var spinnerView = UIView()
    var spinner = UIActivityIndicatorView()
    var loadingView: LoadingCollectionReusableView?
    private lazy var dataSource = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupCollectionView()
        setupActivityIndicator()
        setupLayouts()
    }
    
}

extension EventListViewController: EventListViewProtocol {
    func presentEvents() {
        applySnapshot(animatingDifferences: false)
        refreshControl.endRefreshing()
        loadingView?.activityIndicator.stopAnimating()
        stopFirstLoading()
    }
    
    func failure(error: Error) {
        showAlert(message: error.localizedDescription)
    }
    
    func showNextLoading() {
        loadingView?.activityIndicator.startAnimating()
    }
    
    func showFirstLoading() {
        spinnerView.isHidden = false
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
                cell?.configure(with: event, index: indexPath.row)
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
        snapshot.appendItems(presenter.events)
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
    
    func setupActivityIndicator() {
        let spinnerView = UIView()
        spinnerView.backgroundColor = .black.withAlphaComponent(0.2)
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
     
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = .white
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        spinnerView.addSubview(spinner)
        view.addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            spinnerView.topAnchor.constraint(equalTo: view.topAnchor),
            spinnerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spinnerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            spinnerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            
            spinner.topAnchor.constraint(equalTo: spinnerView.topAnchor),
            spinner.trailingAnchor.constraint(equalTo: spinnerView.trailingAnchor),
            spinner.bottomAnchor.constraint(equalTo: spinnerView.bottomAnchor),
            spinner.leadingAnchor.constraint(equalTo: spinnerView.leadingAnchor),
        ])
        self.spinner = spinner
        self.spinnerView = spinnerView
    }
    
    @objc func refreshList() {
        presenter?.refresh()
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func stopFirstLoading() {
        spinnerView.isHidden = true
        spinner.stopAnimating()
        navigationController?.navigationBar.topItem?.title = "Казань"
    }
}

extension EventListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.loadNextPage(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let event = presenter.events[indexPath.row]
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.bounds.size.width, height: 20)
    }
    
}
