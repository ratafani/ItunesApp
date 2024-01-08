//
//  DetailViewController.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 08/01/24.
//

import UIKit

class DetailViewController: UIViewController {
    
    // Movie data to display
    var movie: Movie?
    var viewModel : ListViewModelProtocol?

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
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
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
    }

    private func setupUI() {
        view.backgroundColor = .white

        // Add UI components to the view
        view.addSubview(backgroundCircleView)
        view.addSubview(favoriteButton)
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)

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

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }

    private func updateUI() {
        guard let movie = movie else { return }
        // Update UI components with movie details
        imageView.downloaded(from: movie.artworkUrl100 ?? "") {
            
        }  // Replace with your image
        titleLabel.text = movie.trackName
        descriptionLabel.text = movie.longDescription
    }

    @objc private func favoriteButtonTapped() {
        guard let movie = movie else {return}
        viewModel?.favoriteForRowAt(movie)
    }
}
