//
//  MovieEntity.swift
//  ItunesApp
//
//  Created by Muhammad Tafani Rabbani on 07/01/24.
//

import Foundation
import CoreData

//MARK: extention from coredata entity so that can communicate with model from API
extension MovieEntity{
    func update(with movie:Movie){
        self.artworkUrl60 = movie.artworkUrl60
        self.artworkUrl100 = movie.artworkUrl100
        self.longDescription = movie.longDescription
        self.trackName = movie.trackName
        self.isFavorite = movie.isFavorites
        self.releaseDate = movie.releaseDate
        self.trackID = Int32(movie.trackID ?? 0)
        self.primaryGenreName = movie.primaryGenreName
        self.trackPrice = movie.trackPrice ?? 0.0
    }
    
    func createMovie() -> Movie {
    
        return Movie(
            id: self.objectID,
            wrapperType: .track,
            kind: .featureMovie,
            collectionID: nil,
            trackID: Int(self.trackID),
            artistName: nil,
            collectionName: nil,
            trackName: self.trackName,
            collectionCensoredName: nil,
            trackCensoredName: nil,
            collectionArtistID: nil,
            collectionArtistViewURL: nil,
            collectionViewURL: nil,
            trackViewURL: nil,
            previewURL: nil,
            artworkUrl30: "",
            artworkUrl60: self.artworkUrl60,
            artworkUrl100: self.artworkUrl100,
            collectionPrice: nil,
            trackPrice: self.trackPrice,
            trackRentalPrice: nil,
            collectionHDPrice: nil,
            trackHDPrice: nil,
            trackHDRentalPrice: nil,
            releaseDate: self.releaseDate,
            collectionExplicitness: .notExplicit,
            trackExplicitness: .notExplicit,
            trackCount: nil,
            trackNumber: nil,
            trackTimeMillis: nil,
            country: nil,
            currency: nil,
            primaryGenreName: self.primaryGenreName,
            contentAdvisoryRating: nil,
            shortDescription: nil,
            longDescription: self.longDescription,
            hasITunesExtras: nil,
            discCount: nil,
            discNumber: nil,
            isFavorites: self.isFavorite
            
        )
    }
}
