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
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(output), userInfo: text, repeats: false)
        }
    }
    
    @objc func output(){
        if timer.userInfo != nil {
            
            let s = timer.userInfo as? String ?? ""
            print(s)
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
