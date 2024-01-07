//
//  ViewController+TabbleDelegate.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import UIKit


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        let movie = viewmodel.cellForRowAt(indexPath.row)
        cell.textLabel?.text = movie.trackName
        return cell
    }
    
}
