//
//  Movies.swift
//  Flikz
//
//  Created by Luis Perez on 10/16/16.
//  Copyright © 2016 Luis PerezBunnyLemon. All rights reserved.
//

import Foundation
import AFNetworking

private let params = [
    "api_key": "7217afcbf999a48ff2e1b81e2577d05f",
    "languange": "en-US"
]
class Movie {
    private var baseURL = "https://image.tmdb.org/t/p"
    private var posterPath: String?
    var title: String?
    var description: String?
    
    init(jsonResult: NSDictionary) {
        // Poster URL
        if let posterPath = jsonResult.valueForKey("poster_path") as? String {
            self.posterPath = posterPath
        }
        
        // Title
        if let title = jsonResult.valueForKey("title") as? String {
            self.title = title
        }
        else if let title = jsonResult.valueForKey("original_title") as? String {
            self.title = title
        }
        
        // Description
        if let description = jsonResult.valueForKey("overview") as? String {
            self.description = description
        }
    }
    
    class func fetchNowPlaying(successCallback: ([Movie]) -> Void, error: ((NSError?) -> Void)?) {
        let nowPlayingURL = "https://api.themoviedb.org/3/movie/now_playing"
        let manager = AFHTTPRequestOperationManager()
        manager.GET(nowPlayingURL, parameters: params, success: { (operation ,responseObject) -> Void in
            if let results = responseObject["results"] as? NSArray {
                var movies: [Movie] = []
                if let results = results as? [NSDictionary] {
                    for result in results as [NSDictionary] {
                        movies.append(Movie(jsonResult: result))
                    }
                    successCallback(movies)
                }
                else {
                    if let errorCallback = error {
                        errorCallback(NSError(domain: "user", code: 1, userInfo: nil))
                    }
                }
            }
            }, failure: { (operation, requestError) -> Void in
                if let errorCallback = error {
                    errorCallback(requestError)
                }
        })
    }
    
    func getOriginalPosterURL() -> NSURL? {
        guard let poster = posterPath else { return nil }
        let urlString = "\(baseURL)/original/\(poster)"
        return NSURL(string: urlString)
    }
    
    func getPosterURL(size: Int) -> NSURL? {
        guard let poster = posterPath else { return nil }
        let urlString = "\(baseURL)/w\(size)/\(poster)"
        return NSURL(string: urlString)
    }
}