//
//  ViewController+TabbleDelegate.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import UIKit

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.viewmodel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.viewmodel.cellSize().1, for: indexPath) as? BaseCell else {return UICollectionViewCell()}
        
        guard let movie = self.viewmodel.cellForRowAt(indexPath.row) else{
            return cell
        }
        cell.nameLabel.text = movie.trackName?.limit(num: 30)
        cell.rowImage.downloaded(from:movie.artworkUrl100 ?? ""){
            cell.rowImage.editImage()
            cell.rowImage.contentMode = .scaleAspectFill
            cell.favoriteButtonTap = {
                self.viewmodel.favoriteForRowAt(movie)
            }
            cell.setFavoriteImagge(isFavorite: movie.isFavorites)
        }
        
        return cell
    }
    
    //size cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = self.viewmodel.cellSize().0
        let itemHeight = self.viewmodel.cellSize().1 == "Small" ? 60.0 : 200.0
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        4
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = self.viewmodel.cellForRowAt(indexPath.row) else {return}
        self.coordinator?.showDetail(movie: movie){ [weak self] m in
            guard let self else {return}
            self.viewmodel.changeListMovie(by: m)
//            self.reloadData()
        }
    }
}


