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
    fileprivate var baseURL = "https://image.tmdb.org/t/p"
    fileprivate var posterPath: String?
    var title: String?
    var description: String?
    
    init(jsonResult: NSDictionary) {
        // Poster URL
        if let posterPath = jsonResult.value(forKey: "poster_path") as? String {
            self.posterPath = posterPath
        }
        
        // Title
        if let title = jsonResult.value(forKey: "title") as? String {
            self.title = title
        }
        else if let title = jsonResult.value(forKey: "original_title") as? String {
            self.title = title
        }
        
        // Description
        if let description = jsonResult.value(forKey: "overview") as? String {
            self.description = description
        }
    }
    
    class func fetchEndpoint(_ endpoint: String, successCallback: @escaping ([Movie]) -> Void, error: ((NSError?) -> Void)?) {
        let url = "https://api.themoviedb.org/3/movie/\(endpoint)"
        let manager = AFHTTPRequestOperationManager()
        manager.get(url, parameters: params, success: { (operation ,responseObject) -> Void in
            if let responseObject = responseObject as? NSDictionary {
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
            }
            }, failure: { (operation, requestError) -> Void in
                if let errorCallback = error {
                    errorCallback(requestError as NSError)
                }
        })
    }
    
    func setPosterThumbail(_ view: UIImageView) -> Void {
        guard let smallImageURL = getPosterURL(45) else { return }
        guard let largeImageURL = getPosterURL(342) else { return }
        setImage(URLRequest(url: smallImageURL), asset: URLRequest(url: largeImageURL), view: view)
    }
    
    func setPoster(_ view: UIImageView) -> Void {
        guard let smallImageURL = getPosterURL(342) else { return }
        guard let largeImageURL = getOriginalPosterURL() else { return }
        setImage(URLRequest(url: smallImageURL), asset: URLRequest(url: largeImageURL), view: view)
    }
    
    func getOriginalPosterURL() -> URL? {
        guard let poster = posterPath else { return nil }
        let urlString = "\(baseURL)/original/\(poster)"
        return URL(string: urlString)
    }
    
    func getPosterURL(_ size: Int) -> URL? {
        guard let poster = posterPath else { return nil }
        let urlString = "\(baseURL)/w\(size)/\(poster)"
        return URL(string: urlString)
    }
    
    func getTrailerURL(_ success: @escaping (URL) -> Void, error: ((NSError?) -> Void)?) {
        guard let title = title else {
            if let error = error {
                error(NSError(domain: "No movie title", code: 2, userInfo: nil))
            }
            return
        }
        
        let params = [
            "key": "AIzaSyD-6CFEKonGVe9Qa-r384caYjGQH9yyX0k",
            "part": "id",
            "maxResults": "1",
            "q": "\(title) trailer"
        ]
        let youtubeSearchURL = "https://www.googleapis.com/youtube/v3/search"
        let youtubeWatchURL = "https://www.youtube.com/watch"
        
        let manager = AFHTTPRequestOperationManager()
        manager.get(youtubeSearchURL, parameters: params, success: { (operation, responseObject) -> Void in
            if let responseObject = responseObject as? NSDictionary {
                if let results = responseObject["items"] as? [NSDictionary] {
                    if let id = results[0]["id"] as? NSDictionary {
                        if let videoId = id["videoId"] {
                            if let url = URL(string: "\(youtubeWatchURL)?v=\(videoId)") {
                               success(url)
                            }
                        }
                    }
                }
            }
            if let error = error {
                error(NSError(domain: "Failed to retrieve trailer", code: 3, userInfo: nil))
            }
        }, failure: { (operation, err) -> Void in
            if let error = error {
                error(err as NSError)
            }
        })
    }
    
    // Sets image first to preview (assumed small), then asset (assumed large)
    // for the given view.
    fileprivate func setImage(_ preview: URLRequest, asset: URLRequest, view: UIImageView) -> Void {
        let placeholder = UIImage(named: "placeholder")
        view.setImageWith(preview, placeholderImage: placeholder, success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
            
            // smallImageResponse will be nil if the smallImage is already available
            // in cache (might want to do something smarter in that case).
            view.alpha = 0.0
            view.image = smallImage;
            
            let duration = smallImageResponse == nil ? 0 : 0.5
            
            UIView.animate(withDuration: duration, animations: { () -> Void in
                
                view.alpha = 1.0
                
                }, completion: { (sucess) -> Void in
                    
                    // The AFNetworking ImageView Category only allows one request to be sent at a time
                    // per ImageView. This code must be in the completion block.
                    view.setImageWith(
                        asset,
                        placeholderImage: smallImage,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            view.image = largeImage
                        },
                        failure: { (request, response, error) -> Void in
                            print("Error loading large image \(error)")
                            // Set small image!
                            view.image = smallImage
                    })
            })
            }, failure: { (request, response, error) -> Void in
                // Try to get the large image
                view.setImageWith(
                    asset,
                    placeholderImage: placeholder,
                    success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                        view.image = largeImage
                    },
                    // Failed at large and small
                    failure: { (request, response, error) -> Void in
                        print("Error loading both images \(error)")
                        // Set placeholder image!
                        view.image = placeholder
                })
        })
    }
}
