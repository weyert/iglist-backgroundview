//
//  UIImage+URL.swift
//  IGListKitBug
//
//  Created by Weyert de Boer on 25/08/2017.
//  Copyright © 2017 Weyert de Boer. All rights reserved.
//

import UIKit

public extension UIImageView {
    
    public func loadImage(_ url: URL) -> URLSessionDataTask {
        let session = URLSession(configuration: .default)
        
        let downloadImageTask = session.dataTask(with: url) { [weak self] data, response, error in
            // The download has finished.
            if let e = error {
                print("Error downloading image: \(e)")
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let _ = response as? HTTPURLResponse {
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        let image = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self?.image = image
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        
        downloadImageTask.resume()
        return downloadImageTask
    }
}

