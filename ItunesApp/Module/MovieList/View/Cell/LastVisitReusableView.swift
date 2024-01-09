//
//  LastVisitReusableView.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 09/01/24.
//

import UIKit

class LastVisitReusableView: UICollectionReusableView {
    static let reuseIdentifier = "CollectionHeaderView"

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        // Add your UI components, constraints, and styling here
        addSubview(titleLabel)

        // Add constraints for titleLabel (adjust as needed)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        let last = UserDefaults.standard.object(forKey: "LastVisit") as? String
        
        titleLabel.text = "Last visit: \(last ?? "no last visit yet")"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
