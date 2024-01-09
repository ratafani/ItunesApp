
import Foundation
import CoreData


// MARK: - from API model
struct Movie: Codable,Equatable {
    var id: NSManagedObjectID = NSManagedObjectID()
    let wrapperType: WrapperType? // --
    let kind: Kind? // --
    let collectionID: Int?
    let trackID: Int?
    let artistName: String? // --
    let collectionName: String?
    let trackName: String? // --
    let collectionCensoredName: String?
    let trackCensoredName: String?
    let collectionArtistID: Int?
    let collectionArtistViewURL, collectionViewURL: String?
    let trackViewURL: String?
    let previewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let collectionPrice, trackPrice: Double?
    let trackRentalPrice: Double?
    let collectionHDPrice, trackHDPrice: Double?
    let trackHDRentalPrice: Double?
    let releaseDate: String?
    let collectionExplicitness, trackExplicitness: Explicitness?
    let trackCount, trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let contentAdvisoryRating: String?
    let shortDescription: String?
    let longDescription: String?
    let hasITunesExtras: Bool?
    let discCount, discNumber: Int?
    var isFavorites: Bool = false
    

    enum CodingKeys: String, CodingKey {
    
        case wrapperType, kind
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case collectionArtistID = "collectionArtistId"
        case collectionArtistViewURL = "collectionArtistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, trackRentalPrice
        case collectionHDPrice = "collectionHdPrice"
        case trackHDPrice = "trackHdPrice"
        case trackHDRentalPrice = "trackHdRentalPrice"
        case releaseDate, collectionExplicitness, trackExplicitness, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, contentAdvisoryRating, shortDescription, longDescription, hasITunesExtras, discCount, discNumber
    }
    
    
}

enum Explicitness: String, Codable {
    case notExplicit = "notExplicit"
}

enum Kind: String, Codable {
    case featureMovie = "feature-movie"
}

enum WrapperType: String, Codable {
    case track = "track"
}
