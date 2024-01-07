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
    func updateListStyle(isSearch:Bool)
}

class ViewController: UIViewController,MainViewProtocol{

    struct SearchControllerRestorableState {
        var wasActive = false
        var wasFirstResponder = false
    }
    
    var restoredState = SearchControllerRestorableState()
    
    var viewmodel: ListViewModelProtocol!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    var searchController: UISearchController!
    var styleButton : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewmodel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
    }
    
    func configureView() {
        //setup table
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        
        //setup searchbar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        //setup navbar items
        let search = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action:  #selector(self.onItemBarClick(_ :)))
        search.tag = 1
        
        let favoritesButton = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action:  #selector(self.onItemBarClick(_ :)))
        favoritesButton.tag = 3
        
        styleButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.rectangle"), style: .plain, target: self, action:  #selector(self.onItemBarClick(_ :)))
        styleButton.tag = 2
    
        self.navigationItem.setRightBarButtonItems([search,styleButton], animated: false)
        self.navigationItem.setLeftBarButtonItems([favoritesButton], animated: false)
        self.navigationItem.title = "List Movies"
        
    }
    
    func updateSearchbar(isSearch:Bool) {
        DispatchQueue.main.async {
            self.navigationItem.searchController = isSearch ? self.searchController : nil
            if self.viewmodel.numberOfRows()>0{
                //if item exist, move back to up
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            }
            if isSearch{
                //go to search
                self.present(self.searchController,animated: true)
            }
        }
    }
    
    func updateListStyle(isSearch:Bool){
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
//                change the style
                self.styleButton.image = UIImage(systemName: isSearch ? "list.bullet.rectangle" : "tablecells.fill")
            }
        }
    }

    
    @objc func onItemBarClick(_ sender: UIBarButtonItem){
        if sender.tag == 1{
            //searchbar clicked
            viewmodel.isSearch()
        }else if sender.tag == 2{
            //style button clicked
            viewmodel.isListStyle()
        }else{
            //favorited clicked
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
            self.tableView.reloadData()
        }
    }
    
}
