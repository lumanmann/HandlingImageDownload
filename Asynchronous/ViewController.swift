//
//  ViewController.swift
//  Asynchronous
//
//  Created by 泉 on 2019/3/20.
//  Copyright © 2019 mapd17. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var checkURL = ""
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBAction func showBtn(_ sender: Any) {
        let textURL = textField.text
        
        if checkURL != textURL{
        if let imageURL = URL(string:textURL ?? ""){
           
                DispatchQueue.global().async {
                    do{
                        let downloadImage = UIImage(data: try Data(contentsOf: imageURL))
                        DispatchQueue.main.async {
                            self.ImageView.image = downloadImage
                            print("Downloaded")
                            }
                        self.checkURL = textURL!
                        print("\(self.checkURL)")
                    }catch{
                        print(error.localizedDescription)
                    }
                
            }
            }
        else{
            }
        }
    }    

    @IBAction func clearBtn(_ sender: Any) {
        ImageView.image = nil
        textField.text = ""
        self.checkURL = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let imageAddress:String? = textField.text
//        if let imageURL = URL(string: imageAddress ?? ""){

        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

