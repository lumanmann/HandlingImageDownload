//
//  ViewController.swift
//  DownloadImg
//
//  Created by WY NG on 15/3/2019.
//  Copyright © 2019 lumanmann. All rights reserved.
//

// https://cdn.pixabay.com/photo/2017/06/05/20/10/blue-2375119_1280.jpg
// https://cdn.pixabay.com/photo/2015/09/27/20/12/women-961208_1280.jpg

import UIKit

class ViewController: UIViewController {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.yellow
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let urlTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "URL"
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.borderStyle =  UITextField.BorderStyle.roundedRect
        tf.textContentType = UITextContentType.URL
        return tf
    }()
    
    let showButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Show", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.lightGray
        btn.isEnabled = true
        return btn
    }()
    
    let clearButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Clear", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.lightGray
        btn.isEnabled = true
        return btn
    }()
    
    var asyncImage = AsyncImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showButton.addTarget(self, action: #selector(showClicked), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearClicked), for: .touchUpInside)
        
        asyncImage.completeDownload = { image in
            self.imageView.image = image
        }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
            ])
        
        let stackView = UIStackView(arrangedSubviews: [urlTextField, showButton, clearButton])
        
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.widthAnchor.constraint(equalToConstant: 300),
            stackView.heightAnchor.constraint(equalToConstant: 150),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 50)
            ])
        
        imageView.image = asyncImage.image
    }
    
    @objc func showClicked(sender: UIButton) {
        guard let str = urlTextField.text, str.count > 0 else { return }
        asyncImage.urlString = str
        urlTextField.text = ""
    }
    
    @objc func clearClicked(sender: UIButton) {
        asyncImage.urlString = nil
        self.imageView.image = asyncImage.image
    }
    
}

