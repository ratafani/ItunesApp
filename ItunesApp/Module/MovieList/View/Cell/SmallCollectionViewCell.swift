//
//  SmallCollectionViewCell.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 05/01/24.
//

import UIKit

class SmallCollectionViewCell: UICollectionViewCell {
    
    
    let rowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.crop.circle")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.black
        label.text = "Bob Lee"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favorite: UIButton = {
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
        
        rowImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        rowImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        rowImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        rowImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        nameLabel.leftAnchor.constraint(equalTo: rowImage.rightAnchor, constant: 5).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: rowImage.centerYAnchor, constant: 0).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: favorite.leftAnchor, constant: -8).isActive = true
        
        favorite.rightAnchor.constraint(equalTo: rightAnchor,constant: -16).isActive = true
        favorite.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        favorite.heightAnchor.constraint(equalToConstant: 25).isActive = true
        favorite.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
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
}
