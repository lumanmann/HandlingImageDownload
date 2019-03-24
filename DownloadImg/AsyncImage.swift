//
//  AsyncImage.swift
//  DownloadImg
//
//  Created by WY NG on 15/3/2019.
//  Copyright © 2019 lumanmann. All rights reserved.
//

import Foundation
import  UIKit

class AsyncImage {
    
    var urlString: String? {
        didSet {
            if urlString != urlStrStored {
                urlStrStored = urlString
            }
        }
    }
    
    private var urlStrStored: String? = "" {
        didSet {
            if urlStrStored != nil{
                startDownload()
            } else {
                self.imageStored = nil
            }
            
        }
    }
    
    // The downloeded image, it could be a placeholder image if the image is downloading or the download is failed
    var image: UIImage {
        return self.imageStored ?? placeholder
    }
    
    // Image download complete closure
    var completeDownload: ((UIImage?) -> Void)?
    
    private var imageStored: UIImage?
    private let placeholder: UIImage
    
    private var isDownloading: Bool = false
    
    init() {
        placeholder = UIImage(named: "placeholder")!
    }
    
    func startDownload() {
        
        if isDownloading { return }
        guard let url = URL(string: urlStrStored!) else { return }
        
        isDownloading = true
        download(url: url, completion: {(image, response, error) in
            if image == nil { return }
            self.imageStored = image
            self.isDownloading = false
            DispatchQueue.main.async {
                print("Downloaded")
                self.completeDownload?(image)
            }
        })
        
    }
    
    private func download(url: URL, completion: @escaping (UIImage?, URLResponse?, Error?) -> ()) {
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                completion(UIImage(data: data), response, error)
            } else {
                completion(nil, response, error)
            }
            }.resume()
        
    }
    
    
}

