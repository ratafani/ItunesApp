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

    struct SearchControllerRestorableState {
        var wasActive = false
        var wasFirstResponder = false
    }
    
    weak var coordinator : MainCoordinator?
    
    var restoredState = SearchControllerRestorableState()
    
    var viewmodel: ListViewModelProtocol!
    
    lazy var mCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .init(white: 1, alpha: 0.2)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        return collectionView
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
//        view.addSubview(collectionView)
    }
    
    func configureView() {
        //setup table
        mCollectionView.delegate = self
        mCollectionView.dataSource = self
        self.view.addSubview(self.mCollectionView)
        mCollectionView.register(SmallCollectionViewCell.self, forCellWithReuseIdentifier: "Small")
        mCollectionView.register(LargeCollectionViewCell.self, forCellWithReuseIdentifier: "Large")
        mCollectionView.translatesAutoresizingMaskIntoConstraints = false
        mCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        mCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        mCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        mCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 100).isActive = true
        
        
        //setup searchbar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        //setup navbar items
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action:  #selector(self.onItemBarClick(_ :)))
        search.tag = 1
        
        //NOTE: wanted to have list of fatorites access here
//        let favoritesButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action:  #selector(self.onItemBarClick(_ :)))
//        favoritesButton.tag = 3
        
        styleButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle"), style: .plain, target: self, action:  #selector(self.onItemBarClick(_ :)))
        styleButton.tag = 2
    
        self.navigationItem.setRightBarButtonItems([search,styleButton], animated: false)
        self.navigationItem.title = "List Movies"
        
    }
    
    func updateSearchbar(isSearch:Bool) {
        DispatchQueue.main.async {
            self.navigationItem.searchController = isSearch ? self.searchController : nil
            if self.viewmodel.numberOfRows()>0{
                //if item exist, move back to up
                self.mCollectionView.scrollsToTop = true
            }
            if isSearch{
                //go to search
                self.present(self.searchController,animated: true)
            }
        }
    }
    
    func updateListStyle(layout:ListLayoutStyle){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
//                change the style
                self.styleButton.image = UIImage(systemName: layout == .table ? "list.bullet.rectangle" : "tablecells.fill")
                self.reloadData()
            }
        }
    }

    
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
        
        // Restore the searchController's active state.
        if restoredState.wasActive {
            searchController.isActive = restoredState.wasActive
            restoredState.wasActive = false
            
            if restoredState.wasFirstResponder {
                searchController.searchBar.becomeFirstResponder()
                restoredState.wasFirstResponder = false
            }
        }
    }
    
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            self.mCollectionView.reloadData()
        }
    }
    
    func getViewFrame()->CGFloat{
        return self.view.bounds.width
    }
}
