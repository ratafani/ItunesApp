//
//  ViewController+TabbleDelegate.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import UIKit

var counting = 0
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewmodel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? SmallCollectionViewCell else {return UICollectionViewCell()}
        
        guard let movie = self.viewmodel.cellForRowAt(indexPath.row) else{
            return cell
        }
        cell.nameLabel.text = movie.trackName
        cell.rowImage.downloaded(from:movie.artworkUrl60 ?? ""){
            cell.rowImage.asCircle()
            cell.rowImage.contentMode = .scaleAspectFill
            cell.favoriteButtonTap = {
                self.viewmodel.favoriteForRowAt(indexPath.row)
            }
            cell.setFavoriteImagge(isFavorite: movie.isFavorites)
        }
        
        return cell
    }
    
    //size cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = self.view.frame.width * 0.97
        let itemHeight = 60.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.reloadData()
    }
}
