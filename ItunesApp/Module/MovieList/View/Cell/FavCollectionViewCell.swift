//
//  FavCollectionViewCell.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 09/01/24.
//

import UIKit

class FavCollectionViewCell: UICollectionViewCell{

    var rowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIColor.lightGray.image()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        self.addSubview(rowImage)
        
        rowImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        rowImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rowImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rowImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func configure(with movie: Movie) {
        self.rowImage.downloaded(from:movie.artworkUrl100 ?? ""){
            self.rowImage.layer.cornerRadius = 14
            self.rowImage.contentMode = .scaleAspectFill
            self.rowImage.layer.masksToBounds = true
        }
    }
    
}
