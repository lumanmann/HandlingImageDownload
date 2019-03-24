//
//  ViewController.swift
//  DownloadImg
//
//  Created by WY NG on 15/3/2019.
//  Copyright © 2019 lumanmann. All rights reserved.
//

import UIKit
/*
 https://cdn.pixabay.com/photo/2017/06/05/20/10/blue-2375119_1280.jpg
 https://cdn.pixabay.com/photo/2015/09/27/20/12/women-961208_1280.jpg
 */
class ViewController: UIViewController {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .yellow
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "placeholder")
        return iv
    }()
    
    let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "URL"
        tf.autocapitalizationType = UITextAutocapitalizationType.none
        tf.borderStyle = .roundedRect
        tf.textContentType = UITextContentType.URL
        return tf
    }()

    lazy var showButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Show", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.lightGray
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(showButtonAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var clearButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Clear", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.backgroundColor = UIColor.lightGray
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(clearButtonAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 300),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50)
            ])
        
        setupView()
    }
    
    private func setupView() {
        let stackView = UIStackView(arrangedSubviews: [textField, showButton, clearButton])
        
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

    }
    
    @objc func showButtonAction(sender : UIButton){
        guard let urlString = textField.text else { return }
        imageView.setURLString(urlString: urlString)
    }
    
    @objc func clearButtonAction(sender : UIButton){
        textField.text = ""
        imageView.image = UIImage(named: "placeholder")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
}

extension UIImageView {
    
    func setURLString(urlString : String){
        let imageCallBack : (UIImage) -> () = { image in
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }
        
//        DownloadManager.downloadData(urlString: urlString, finish: imageCallBack)
        DownloadManager.downloadData(urlString: urlString, finish: imageCallBack) { (error) in
            print(error.localizedDescription)
        }
 
    }
    
}

final public class DownloadManager {
    
    private init() {}
    
    static func downloadData<T>(urlString : String,finish : @escaping (T) -> (),failed : ((Error) -> ())? = nil){
        if let image : T = CacheManager.share.getCache(key: urlString) {
            print("get cache")
            finish(image)
        }else {
            guard let url = URL(string: urlString) else {
                failed?(APIError.getURLFailed)
                return
            }
            print("startDownload")
            
            URLSession.shared.dataTask(with: url) { (data, nil, error) in
                print("downloaded")
                if let error = error {
                    failed?(APIError.requestFailed(reason: error.localizedDescription))
                }else {
                    guard let data = data, data.count > 0 else {
                        failed?(APIError.noData)
                        return
                    }
                    if let image = UIImage(data: data), UIImage.self == T.self {
                        finish(image as! T)
                        CacheManager.share.setObject(image as AnyObject, forKey: urlString)
                    }else {
                        finish(data as! T)
                        CacheManager.share.setObject(data as AnyObject, forKey: urlString)
                    }
                }
            }.resume()
        }
    }
}

final public class CacheManager: NSObject, NSCacheDelegate {
    static let share = CacheManager()
    private let cache = NSCache<AnyObject,AnyObject>()
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(removeCacheMemory), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        cache.delegate = self
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        print(obj)
    }
    
    func setObject(_ obj: AnyObject, forKey key: String) {
        cache.setObject(obj, forKey: key as AnyObject)
    }
    
    func getCache<T>(key: String) -> T? {
        return cache.object(forKey: key as AnyObject) as? T
    }
    
    @objc func removeCacheMemory(){
        cache.removeAllObjects()
    }
    
}


// MARK: - Error
enum APIError: Swift.Error {
    case getURLFailed
    case requestFailed(reason: String)
    case noData
}

// MARK: - Error localization
extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .getURLFailed: return "Can’t get valid URL"
        case .requestFailed(let reason): return reason
        case .noData: return "No data returned with response"
        }
    }
}
