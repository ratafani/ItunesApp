//
//  SmallCollectionViewCell.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import UIKit


class SmallCollectionViewCell: UICollectionViewCell,BaseCell {
    
    
    var rowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIColor.lightGray.image()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = UIColor.black
        label.text = "Bob Lee"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.text = "$5"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor.black
        label.text = "Bob Lee"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var favorite: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    var favoriteButtonTap : ()->Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    func addViews(){
        
        addSubview(rowImage)
        addSubview(nameLabel)
        addSubview(favorite)
        addSubview(genreLabel)
        addSubview(priceLabel)
        
        rowImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        rowImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rowImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        rowImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameLabel.leftAnchor.constraint(equalTo: rowImage.rightAnchor, constant: 5).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: favorite.leftAnchor, constant: -8).isActive = true
        
        genreLabel.leftAnchor.constraint(equalTo: rowImage.rightAnchor, constant: 5).isActive = true
        genreLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
//        genreLabel.rightAnchor.constraint(equalTo: favorite.leftAnchor, constant: -8).isActive = true
        
        priceLabel.leftAnchor.constraint(equalTo: genreLabel.rightAnchor, constant: 5).isActive = true
        priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        priceLabel.rightAnchor.constraint(equalTo: favorite.leftAnchor, constant: -8).isActive = true
        
        
        
        favorite.rightAnchor.constraint(equalTo: rightAnchor,constant: -16).isActive = true
        favorite.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        favorite.heightAnchor.constraint(equalToConstant: 25).isActive = true
        favorite.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        favorite.addTarget(self, action: #selector(pressedAction(_:)), for: .touchUpInside)
        
    }
    
    func configure(with movie:Movie){
        nameLabel.text = movie.trackName?.limit(num: 25)
        priceLabel.text = (movie.trackPrice != nil) ? "$ \(movie.trackPrice!)" : "no price available"
        genreLabel.text = movie.primaryGenreName ?? "no genre available"
        rowImage.downloaded(from:movie.artworkUrl100 ?? ""){
            self.rowImage.editImage()
            self.rowImage.contentMode = .scaleAspectFill
            self.setFavoriteImagge(isFavorite: movie.isFavorites)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    @objc func pressedAction(_ sender: UIButton) {
       // do your stuff here
      favoriteButtonTap()
    }
    
    func setFavoriteImagge(isFavorite : Bool){
        if isFavorite{
            favorite.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }else{
            favorite.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
}
