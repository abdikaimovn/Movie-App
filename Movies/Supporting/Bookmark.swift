//
//  Bookmark.swift
//  Movies
//
//  Created by Нурдаулет on 19.10.2023.
//

import Foundation

struct BookmarkModel: Codable {
    var movieIDs: [Int]

    init() {
        movieIDs = []
    }

    // Add a method to add or remove movie IDs
    mutating func addMovieID(_ movieID: Int) {
        if !movieIDs.contains(movieID) {
            movieIDs.append(movieID)
        }
    }

    mutating func removeMovieID(_ movieID: Int) {
        if let index = movieIDs.firstIndex(of: movieID) {
            movieIDs.remove(at: index)
        }
    }
}

class BookmarkManager {
    static let shared = BookmarkManager()
    
    private var bookmarkModel: BookmarkModel

    init() {
        // Load existing bookmark data from UserDefaults or create a new model
        if let bookmarkData = UserDefaults.standard.data(forKey: "bookmarkData"),
           let model = try? JSONDecoder().decode(BookmarkModel.self, from: bookmarkData) {
            bookmarkModel = model
        } else {
            bookmarkModel = BookmarkModel()
        }
    }
    
    // Add a method to add a movie ID to bookmarks
    func addMovieID(_ movieID: Int) {
        bookmarkModel.addMovieID(movieID)
        saveBookmarkData()
    }
    
    // Add a method to remove a movie ID from bookmarks
    func removeMovieID(_ movieID: Int) {
        bookmarkModel.removeMovieID(movieID)
        saveBookmarkData()
    }
    
    // Add a method to get the list of bookmarked movie IDs
    func getBookmarkedMovieIDs() -> [Int] {
        return bookmarkModel.movieIDs
    }
    
    // Add a method to check if a movie ID is bookmarked
    func isMovieBookmarked(_ movieID: Int) -> Bool {
        return bookmarkModel.movieIDs.contains(movieID)
    }
    
    // Save the updated bookmark data to UserDefaults
    private func saveBookmarkData() {
        if let encodedData = try? JSONEncoder().encode(bookmarkModel) {
            UserDefaults.standard.set(encodedData, forKey: "bookmarkData")
        }
    }
}
