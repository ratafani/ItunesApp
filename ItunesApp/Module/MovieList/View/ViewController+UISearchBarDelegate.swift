//
//  ViewController+UISearchBarDelegate.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import UIKit


extension ViewController : UISearchBarDelegate, UISearchDisplayDelegate, UISearchResultsUpdating,UISearchControllerDelegate{
    //MARK: -update search result when typing, listen only if there is //num of second finished
    //in this case i use 0.4 seconds spare, the purpose is to hold too many calls when user is still
    //typing
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, (text.isEmpty == false){
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(output), userInfo: text, repeats: false)
        }
    }
    
    @objc func output(){
        if timer.userInfo != nil {
            let s = timer.userInfo as? String ?? ""
            DispatchQueue.main.async {
                self.viewmodel.search(term: s, lim: nil, country: nil)
            }
        }
        timer.invalidate()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
        self.viewmodel.reset()
        self.viewmodel.isSearch()
    }
}
