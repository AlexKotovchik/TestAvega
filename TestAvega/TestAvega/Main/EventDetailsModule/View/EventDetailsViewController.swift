//
//  detailViewController.swift
//  TestAvega
//
//  Created by AlexKotov on 12.01.23.
//

import UIKit

class EventDetailsViewController: UIViewController {
    var presenter: EventDetailsPresenterProtocol!
    
    let contentView = UIView()
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(20)
        label.numberOfLines = 0
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(16)
        label.numberOfLines = 0
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(24)
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupScrollView()
        setupLayouts()
        setupCollectionView()
        presenter.setEvent()
    }
    
}

extension EventDetailsViewController: EventDetailsViewProtocol {
    func setEvent(event: Event) {
        titleLabel.text = event.title.firstUppercased
        descriptionLabel.text = String(event.description
            .firstUppercased
            .dropFirst(3)
            .dropLast(5))
        if let date = event.dates.first {
            dateLabel.text = date.start.convertToDate() + " - " + date.end.convertToDate()
        }
    }
}

extension EventDetailsViewController {
    func setupScrollView() {
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.register(EventImageCollectionViewCell.self, forCellWithReuseIdentifier: EventImageCollectionViewCell.identifier)
    }
    
    func setupLayouts() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            collectionView.widthAnchor.constraint(equalToConstant: view.frame.width),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.width)
        ])
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            dateLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 12)
        ])
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
    }
    
}

extension EventDetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        presenter.event.images.count
        return 5 // for test
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventImageCollectionViewCell.identifier, for: indexPath) as! EventImageCollectionViewCell

//        let url = presenter.event.images[safe: indexPath.row]?.image ?? ""
        let url = "https://picsum.photos/id/\(indexPath.row)/200/300" // for test
        cell.configure(with: url)
        return cell
    }
}
