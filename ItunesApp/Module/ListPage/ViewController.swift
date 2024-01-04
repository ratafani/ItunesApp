//
//  ViewController.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 04/01/24.
//

import UIKit
import Combine

protocol MainViewProtocol: AnyObject {
    func configureTableView()
    func reloadData()
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewmodel.viewDidLoad()
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(tableView)
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.frame
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.delegate = self
        searchController.searchBar.delegate = self
        
        definesPresentationContext = true
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


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewmodel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        let movie = viewmodel.cellForRowAt(indexPath.row)
        cell.textLabel?.text = movie.trackName
        if let data = try? Data(contentsOf: URL(filePath: movie.artworkUrl60)) {
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.contentView.largeContentImage = image
                }
            }
        }
        return cell
        
    }
    
}


extension ViewController : UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating,UISearchControllerDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, (text.isEmpty == false){
            do {
                DispatchQueue.main.async {
                    self.viewmodel.search(term: text, lim: nil, country: nil)
                }
                
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let text = searchBar.text, (text.isEmpty == false){
            do {
                DispatchQueue.main.async {
                    self.viewmodel.search(term: text, lim: nil, country: nil)
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.viewmodel.reset()
    }
}
