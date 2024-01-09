//
//  ViewController.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 04/01/24.
//

import UIKit
import Combine

protocol MainViewProtocol: AnyObject {
    func configureView()
    func reloadData()
    func updateSearchbar(isSearch:Bool)
    func updateListStyle(layout:ListLayoutStyle)
    func getViewFrame()->CGFloat
}

class ViewController: UIViewController,MainViewProtocol{

    
    weak var coordinator : MainCoordinator?
    
    var viewmodel: ListViewModelProtocol!
    
    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .init(white: 1, alpha: 0.2)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.register(SmallCollectionViewCell.self, forCellWithReuseIdentifier: "Small")
        collectionView.register(LargeCollectionViewCell.self, forCellWithReuseIdentifier: "Large")
        collectionView.register(LastVisitReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LastVisitReusableView.reuseIdentifier)

        return collectionView
    }()
    
    lazy var favoriteCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .init(white: 1, alpha: 0.2)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        collectionView.register(FavCollectionViewCell.self, forCellWithReuseIdentifier: "Favorite")
        collectionView.register(LastVisitReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: LastVisitReusableView.reuseIdentifier)
        return collectionView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textColor = UIColor.black
        label.text = "Favorites :"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var searchController: UISearchController!
    var styleButton : UIBarButtonItem!
    var timer : Timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewmodel.viewDidLoad()
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func configureView() {
        
        self.view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 110).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 8).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 8).isActive = true
        
        //setup table
        favoriteCollectionView.delegate = self
        favoriteCollectionView.dataSource = self
        self.view.addSubview(self.favoriteCollectionView)
        favoriteCollectionView.translatesAutoresizingMaskIntoConstraints = false
        favoriteCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        favoriteCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        favoriteCollectionView.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor,constant: 4).isActive = true
        favoriteCollectionView.heightAnchor.constraint(equalToConstant: 180).isActive = true
       
        
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        self.view.addSubview(self.mCollectionView)
        mCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mCollectionView.topAnchor.constraint(equalTo: self.favoriteCollectionView.bottomAnchor,constant: 8).isActive = true
//
        //setup searchbar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        self.definesPresentationContext = false
        
        //setup navbar items
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action:  #selector(self.onItemBarClick(_ :)))
        search.tag = 1
        
        styleButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle"), style: .plain, target: self, action:  #selector(self.onItemBarClick(_ :)))
        styleButton.tag = 2
    
        self.navigationItem.setRightBarButtonItems([search,styleButton], animated: false)

        self.navigationItem.title = "List Movies"
        
    }
    //MARK: - to observe of searchar is in focus
    // when the focus was not in top of collection view, it should reload the table and go to the top of collection
    func updateSearchbar(isSearch:Bool) {
        DispatchQueue.main.async {
            self.navigationItem.searchController = isSearch ? self.searchController : nil
            if self.viewmodel.numberOfRows(isFavorite: false)>0{
                //if item exist, move back to up
                self.mCollectionView.scrollsToTop = true
            }
            if isSearch{
                //go to search
                self.present(self.searchController,animated: true)
            }
        }
    }
    //MARK: - update the layout style
    func updateListStyle(layout:ListLayoutStyle){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
//                change the style
                self.styleButton.image = UIImage(systemName: layout == .table ? "list.bullet.rectangle" : "tablecells.fill")
                self.reloadData()
            }
        }
    }

    //MARK: -function to listen all navbar item event
    @objc func onItemBarClick(_ sender: UIBarButtonItem){
        if sender.tag == 1{
            //searchbar clicked
            viewmodel.isSearch()
        }else {
            //style button clicked
            viewmodel.changeListStyle()
        }
    }
    
    func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: -reload all the collection view
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.mCollectionView.reloadData()
            self.favoriteCollectionView.reloadData()
        }
    }
    
    func getViewFrame()->CGFloat{
        return self.view.bounds.width
    }
}
