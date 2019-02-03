//
//  Functions.swift
//  FBLA
//
//  Created by Noah Holoubek on 1/23/19.
//  Copyright © 2019 Noah H. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import BLTNBoard

public func downloadImage(into destination: UIImageView, from location: String, completion: @escaping (Error?)->()){
    let store = Storage.storage().reference(withPath: location)
    
    // Check for image saved in cache, load image from disk if possible
    // If it is, proceed with extracting it from cache instead
    if (ImageCache.default.imageCachedType(forKey: store.fullPath).cached) {
        
        ImageCache.default.retrieveImage(forKey: store.fullPath, options: nil) { (image, cacheType) in
            if let image = image {
                destination.image = image
            }
            
            completion(nil)
        }
        
    } else {
        
        // Otherwise, asynchronously download the file data stored at location and store it for later
        store.downloadURL(completion: { (url, error) in
            guard let url = url else { print("Error: Image download url was nil"); return }
            
            print("Image was not found in cache, downloading and caching now...")
            destination.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageUrl) in
                ImageCache.default.store(destination.image!, forKey: store.fullPath)
            })
            
            completion(error)
        })
    }
}

protocol bulletinb: class{
    
    func showBulletin(days: Int, returnDate: Date, bookID: Int)
    
}

extension Array {
    mutating func shuffle(){
        for _ in 0..<10 {
            sort { (_,_) in arc4random() < arc4random() }
        }
    }
}
