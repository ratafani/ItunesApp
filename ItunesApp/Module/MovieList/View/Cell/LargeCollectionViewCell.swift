//
//  LargeCollectionViewCell.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import UIKit

protocol BaseCell: UICollectionViewCell{
    var rowImage: UIImageView { get set }
    var nameLabel : UILabel { get set }
    var favorite : UIButton { get set }
    var favoriteButtonTap : ()->Void { get set }
    func addViews()
    func setFavoriteImagge(isFavorite : Bool)
    func configure(with movie:Movie)
}

class LargeCollectionViewCell: UICollectionViewCell,BaseCell {

    var rowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIColor.lightGray.image()
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.text = "Bob Lee"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.white
        label.text = "$5"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor.white
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
        
        rowImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        rowImage.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rowImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rowImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        favorite.rightAnchor.constraint(equalTo: rightAnchor,constant: -16).isActive = true
        favorite.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8).isActive = true
        favorite.heightAnchor.constraint(equalToConstant: 25).isActive = true
        favorite.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        genreLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor,constant: -8).isActive = true
        genreLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
//        genreLabel.rightAnchor.constraint(equalTo: favorite.leftAnchor, constant: 16).isActive = true
        
        priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -8).isActive = true
        priceLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
//        genreLabel.rightAnchor.constraint(equalTo: favorite.leftAnchor, constant: 16).isActive = true
        
        nameLabel.bottomAnchor.constraint(equalTo: genreLabel.topAnchor,constant: -8).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: favorite.leftAnchor, constant: 8).isActive = true
        
        
        favorite.addTarget(self, action: #selector(pressedAction(_:)), for: .touchUpInside)
        
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
    
    func configure(with movie:Movie){
        nameLabel.text = movie.trackName?.limit(num: 25)
        priceLabel.text = (movie.trackPrice != nil) ? "$\(movie.trackPrice!)" : "no price available"
        genreLabel.text = movie.primaryGenreName ?? "no genre available"
      
        rowImage.downloaded(from:movie.artworkUrl100 ?? ""){
            self.rowImage.editImage()
            self.rowImage.contentMode = .scaleAspectFill
            self.setFavoriteImagge(isFavorite: movie.isFavorites)
        }
    }
}
