//
//  ViewController.swift
//  App
//
//  Created by mac on 2024/9/26.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func noFriendViewClick(_ sender: Any) {
        var mainController = self.storyboard?.instantiateViewController(withIdentifier: "mainController") as! MainController
        mainController.myMode = 1
        present(mainController, animated:true, completion: nil)
    }

    @IBAction func haveFriendViewClick(_ sender: Any) {
        var mainController = self.storyboard?.instantiateViewController(withIdentifier: "mainController") as! MainController
        mainController.myMode = 2
        present(mainController, animated:true, completion: nil)    }
    
    @IBAction func haveFriendAndInviteViewClick(_ sender: Any) {
        var mainController = self.storyboard?.instantiateViewController(withIdentifier: "mainController") as! MainController
        mainController.myMode = 3
        present(mainController, animated:true, completion: nil)
    }
    
}

