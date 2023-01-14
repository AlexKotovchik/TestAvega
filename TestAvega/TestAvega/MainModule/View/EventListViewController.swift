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
        let images = events.map { $0.images }
        let titles = events.map { $0.title }
        print(images)
        print(titles)
        collectionView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func failure(error: Error) {
        
    }
    
    
}

extension EventListViewController {
    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: EventCollectionViewCell.identifier)
        collectionView.register(LoadingCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingCollectionReusableView.identifier)
        
        setupRefreshControl()
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
        presenter?.loadNextPage(index: indexPath.row)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
    
}

extension EventListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.events.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row != (presenter?.events.count ?? 0) / 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventCollectionViewCell.identifier, for: indexPath) as? EventCollectionViewCell else { return UICollectionViewCell()}
            cell.configure(with: presenter?.events[indexPath.row])
            return cell
//        } else {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCollectionReusableView.identifier, for: indexPath) as? LoadingCollectionReusableView else { return UICollectionViewCell() }
//            cell.activityIndicator.startAnimating()
//            return cell
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: LoadingCollectionReusableView.identifier, for: indexPath) as? LoadingCollectionReusableView
            aFooterView?.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.black
            return aFooterView ?? UICollectionReusableView()
        }
        return UICollectionReusableView()
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
        if ((presenter?.isNextLoading) != nil) {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 55)
        }
    }
    
}
