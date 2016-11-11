//
//  NetworkService.swift
//  TechnicalTest
//
//  Created by Fayyazuddin Syed on 2016-11-07.
//  Copyright © 2016 Fayyazuddin Syed. All rights reserved.
//

import Foundation
import UIKit

class NetworkService {
    
    
    static func uploadImage() {
        guard let image = UIImage(named: "upload_image") else {return}
        let data = UIImagePNGRepresentation(image)
        // FIXME: the server is expecting a different data format (different base64 encoding type??)
        guard let base64String = data?.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed) else {
            return
        }
        
        var request = URLRequest(url: URL(string: "https://api-server.essenceprototyping.com:999/photos/upload")!)
        let parameters = "name=nice_kitty&data=\(base64String)"
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            print("\(data) \(response) \(error)")
        })
        task.resume()
    }
    
    static func getFeed(completion: @escaping (_ photos: [Photo]?, _ error: Error?) -> Void) {
        var request = URLRequest(url: URL(string: "https://api-server.essenceprototyping.com:999/photos/search/?searchString")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler:  {(data: Data?, response: URLResponse?, error: Error?) -> Void in
            print("\(data) \(response) \(error)")
            if let error = error {
                // Return with error
                completion(nil, error)
                return
            }
            if let data = data {
                do {
                    // Convert the data to a jsonObject
                    if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]] {
                        // Map the json on Photo objects
                        var photos = [Photo]()
                        for photoJSON in json {
                            photos.append(Photo(json: photoJSON))
                        }
                        // Return success
                        completion(photos, nil)
                    }
                    
                } catch {
                    print("serialization error")
                    // Return with error
                    completion(nil, nil)
                }
            }
        })
        task.resume()
    }
    
    static var imageCache = NSCache<NSString, UIImage>()
    
    static func getPhotoImage(photo: Photo, completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        guard let _id = photo._id else {
            completion(nil, nil)
            return
        }
        // Get the cached object (in-memory cache)
        if let image = imageCache.object(forKey: _id as NSString) {
            completion(image, nil)
            return
        }
        
        var request = URLRequest(url: URL(string: "https://api-server.essenceprototyping.com:999/photos/get/\(_id)")!)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.downloadTask(with: request, completionHandler: {(url: URL?, response: URLResponse?, error: Error?) -> Void in
            print("\(url) \(response) \(error)")
            
            if let url = url {
                do {
                    // Download of the image has finished, now the image is saved on the "url" on the disk
                    let string = try String(contentsOf: url, encoding: .utf8)
                    var image : UIImage?
                    if let imageData = Data(base64Encoded: string, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
                        
                        image = UIImage(data: imageData)
                        if let image = image {
                            imageCache.setObject(image, forKey: _id as NSString)
                        }
                    }
                    completion(image, error)
                    
                } catch {
                    completion(nil, nil)
                }
            }
            
            
        })
        
        task.resume()
    }
    
    
}
