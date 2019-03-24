//
//  ViewController.swift
//  DownloadImage
//
//  Created by 吳重漢 on 2019/3/22.
//  Copyright © 2019 Hank. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageUrlTextField: UITextField!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    
    lazy var lastImageUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showButton.addTarget(self, action: #selector(showButtonAction), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearButtonAction), for: .touchUpInside)
    }

    func getImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }

    func downloadImage(from url: URL) {
        print("Download Started")
        getImageData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print("下載完成")
            DispatchQueue.main.async() {
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    @objc func showButtonAction() {
        guard let imageUrlString = imageUrlTextField.text, imageUrlString != "" else {
            return
        }
        
        if self.lastImageUrl != "" {
            guard self.lastImageUrl != imageUrlTextField.text else {
                return
            }
        }
        
        guard let imageUrl = URL(string: imageUrlString) else {
            return
        }
        
        self.downloadImage(from: imageUrl)
        self.lastImageUrl = imageUrlString
        
    }
    
    
    @objc func clearButtonAction() {
        self.imageUrlTextField.text = ""
        self.lastImageUrl = ""
        self.imageView.image = #imageLiteral(resourceName: "placeholder")
    }
}

