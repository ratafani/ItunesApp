//
//  DetailViewController.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 08/01/24.
//

import UIKit

protocol DetailViewControllerProtocol{
    func setupUI()
    func updateUI()
}

class DetailViewController: UIViewController,DetailViewControllerProtocol {
    
    // Movie data to display
    var viewModel : DetailViewModelProtocol?

    // UI components
    private let backgroundCircleView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let starImage = UIImage(systemName: "star")
        button.setImage(starImage, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
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

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        viewModel?.viewDidLoad()
    }

    func setupUI() {
        view.backgroundColor = .white

        // Add UI components to the view
        view.addSubview(backgroundCircleView)
        view.addSubview(favoriteButton)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(genreLabel)
        view.addSubview(priceLabel)
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

        // Layout constraints
        NSLayoutConstraint.activate([
            backgroundCircleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backgroundCircleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backgroundCircleView.widthAnchor.constraint(equalToConstant: 30),
            backgroundCircleView.heightAnchor.constraint(equalToConstant: 30),

            favoriteButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            favoriteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 30),
            favoriteButton.heightAnchor.constraint(equalToConstant: 30),

            imageView.topAnchor.constraint(equalTo: favoriteButton.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            genreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            genreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            genreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: genreLabel.trailingAnchor, constant: 8),
            priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            
            descriptionLabel.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    func updateUI() {
        guard let movie = viewModel?.getMovie() else { return }

        imageView.downloaded(from: movie.artworkUrl100 ?? "") {}
       
        DispatchQueue.main.async {
            self.titleLabel.text = movie.trackName
            self.descriptionLabel.text = movie.longDescription
            self.priceLabel.text = (movie.trackPrice != nil) ? "$ \(movie.trackPrice!)" : "no price available"
            self.genreLabel.text = movie.primaryGenreName ?? "no genre available"
            if movie.isFavorites{
                self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            }else{
                self.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
       
    }

    @objc private func favoriteButtonTapped() {
        viewModel?.favorite()
    }
}
