// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let googleBook = try? JSONDecoder().decode(GoogleBook.self, from: jsonData)

import Foundation

// MARK: - GoogleBook
struct GoogleBook: Decodable {
    let kind: String?
    let totalItems: Int?
    let items: [Item]?
}

// MARK: - Item
struct Item: Decodable {
 
    let id, etag: String?
    let selfLink: String?
    let volumeInfo: VolumeInfo?
    
   

}






// MARK: - Epub






// MARK: - SaleInfoListPrice


// MARK: - Offer


// MARK: - OfferListPrice




// MARK: - VolumeInfo
struct VolumeInfo: Decodable {
    let title: String?
    let authors: [String]?
    let publishedDate: String?

    let allowAnonLogging: Bool?
    let contentVersion: String?

    let previewLink: String?
    let infoLink: String?
    let canonicalVolumeLink: String?
    let publisher, description: String?
    let pageCount: Int?
    let categories: [String]?
    let imageLinks: ImageLinks?
    let subtitle: String?
    let averageRating: Double?
    let ratingsCount: Int?
}

// MARK: - ImageLinks
struct ImageLinks: Decodable {
    let smallThumbnail, thumbnail: String?
}

