//
//  VideosTests.swift
//  VideosTests
//
//  Created by Tim Roesner on 9/10/18.
//  Copyright © 2018 Tim Roesner. All rights reserved.
//

import XCTest
@testable import _0_2_Video_Fix

class MoviesTests: XCTestCase {
    
    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
    var testMovie = Movie()
    
    override func setUp() {
        super.setUp()
        
        testMovie.url = URL(fileURLWithPath: "./Documents/Movies/testMovie")
        testMovie.title = "Test Movie"
        testMovie.description = "This is a test movie."
        testMovie.duration = 120
        testMovie.year = "2018"
        testMovie.genres = "Drama, Comedy"
        testMovie.artwork = UIImage(named: "MissingArtworkMovies.png")
        testMovie.cast = ["Jack Smith","John Smith","Jane Smith"]
        testMovie.directors = ["Steven Smith"]
        testMovie.screenwriters = ["Aaron Smith"]
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMovieDetails() {
        let movieDetail = storyboard.instantiateViewController(withIdentifier: "movieDetail") as! MoviesDetail
        movieDetail.currentMovie = testMovie
        let _ = movieDetail.view
        
        XCTAssertEqual(testMovie.title, movieDetail.title)
        XCTAssertEqual(testMovie.artwork, movieDetail.cover.image)
        XCTAssertEqual("\(testMovie.duration)m    \(testMovie.year)    \(testMovie.genres)", movieDetail.subtitleLbl.text)
        XCTAssertEqual(testMovie.description, movieDetail.descLbl.text)
        XCTAssert(movieDetail.castLbl.text?.contains(testMovie.cast.first!) ?? false)
        XCTAssert(movieDetail.direcLbl.text?.contains(testMovie.directors.first!) ?? false)
        XCTAssert(movieDetail.screenwrLbl.text?.contains(testMovie.screenwriters.first!) ?? false)
    }
    
    func testParser() {
        guard let path = Bundle(for: type(of: self)).path(forResource: "testMovie", ofType: "mp4") else {
            fatalError("testMovie.mp4 not found")
        }
        let url = URL(fileURLWithPath: path)
        let testMovie = Movie().mapURLs(collection: [url]).first!
        
        XCTAssertEqual("Gone Girl", testMovie.title)
        XCTAssertEqual("This is a test movie.", testMovie.description)
        XCTAssertEqual("2014", testMovie.year)
        XCTAssertEqual("Thriller, Drama", testMovie.genres)
        XCTAssertEqual(["Ben Affleck", "Rosamund Pike"], testMovie.cast)
        XCTAssertEqual(["David Fincher"], testMovie.directors)
        XCTAssertEqual(["Gillian Flynn"], testMovie.screenwriters)
    }
    
    func testParserNonMetadata() {
        let testMovie = Movie().mapURLs(collection: [URL(fileURLWithPath: "~/Documents/noMovie.mp4")]).first!
        
        XCTAssertEqual("noMovie.mp4", testMovie.title)
    }
    
}
