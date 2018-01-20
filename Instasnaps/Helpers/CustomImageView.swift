//
//  CustomImageView.swift
//  Instasnaps
//
//  Created by Pritam Hinger on 11/01/18.
//  Copyright © 2018 AppDevelapp. All rights reserved.
//

import UIKit

var imageCache = [String: UIImage]()

class CustomImageView: UIImageView {
    
    var lastURLUsedToLoadImage:String?
    
    func loadImage(withUrlString imageUrl:String){
        
        lastURLUsedToLoadImage = imageUrl
        self.image = nil
        if let cachedImage = imageCache[imageUrl] {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error occured while fetching image", error)
                return
            }
            
            if url.absoluteString != self.lastURLUsedToLoadImage{
                print("Returning as url don't matched")
                return
            }
            
            guard let imageData = data else { return }
            print(imageData)
            guard let image = UIImage(data: imageData) else { return }
            imageCache[url.absoluteString] = image
            DispatchQueue.main.async {
                self.image = image
            }
            
            }.resume()
    }
}
