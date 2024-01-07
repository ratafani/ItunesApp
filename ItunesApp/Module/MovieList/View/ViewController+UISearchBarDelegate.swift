//
//  ViewController+UISearchBarDelegate.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import UIKit


extension ViewController : UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating,UISearchControllerDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, (text.isEmpty == false){
            DispatchQueue.main.async {
                self.viewmodel.search(term: text, lim: nil, country: nil)
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.viewmodel.isSearch()
    }
}
