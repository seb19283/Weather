//
//  Extensions.swift
//  Weather
//
//  Created by Sebastian Connelly on 10/26/21.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

// Extension so that we can query icon image in the background and it will automatically show up once loaded
extension UIImageView {
    func loadImageWithCache(url: String) {
        if let cachedImage = imageCache.object(forKey: url as AnyObject) {
            self.image = cachedImage as? UIImage
            return
        }
        
        guard let url2 = URL(string: url) else {
            return
        }
        
        URLSession.shared.dataTask(with: url2) { data, respons, error in
            if error != nil{
                print(error)
                return
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!){
                    imageCache.setObject(downloadedImage, forKey: url as AnyObject)
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
}
