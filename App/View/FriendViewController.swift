//
//  FriendViewController.swift
//  App
//
//  Created by ios on 2024/9/27.
//

import UIKit

class FriendViewController: UIViewController {

    @IBOutlet weak var FriendTableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var kokoid: UILabel!
    @IBOutlet weak var chatView: UIView!
    @IBOutlet weak var noFriendView: UIView!
    @IBOutlet weak var haveFriendView: UIView!
    @IBOutlet weak var friendUnderLineView: UIView!
    @IBOutlet weak var chatUnderLineView: UIView!
    
    var dataUserViewModel = DataUserViewModel()
    var dataFriendViewModel = DataFriendViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        //初始畫面
        initViewModel()
        
    }

    //初始畫面->無朋友狀態->檢查有無朋友
    func initViewModel(){
        //聊天按鈕
        chatUnderLineView.isHidden = true
        chatView.isHidden = true
        
        //朋友按鈕
        friendUnderLineView.isHidden = false
        haveFriendView.isHidden = true
        noFriendView.isHidden = false
        
        //Get User Data
        dataUserViewModel.reloadData = {
            DispatchQueue.main.async {
                self.userName.text = self.dataUserViewModel.datas.name
                self.kokoid.text = self.dataUserViewModel.datas.kokoid
            }
        }
        dataUserViewModel.getData()
        
        //Get Friend Data
        FriendTableView.delegate = self
        FriendTableView.dataSource = self
        FriendTableView.register(UINib(nibName: "TableViewCellFriend", bundle: nil), forCellReuseIdentifier: "TableViewCellFriend")
        dataFriendViewModel.reloadTableView = {
            DispatchQueue.main.async {
                if(self.dataFriendViewModel.numberOfCells > 0){
                    self.friendViewReload()
                    self.FriendTableView.reloadData()
                }
            }
        }
        dataFriendViewModel.showError = {
            DispatchQueue.main.async {
                
            }
        }
        dataFriendViewModel.showLoading = {
            DispatchQueue.main.async {
                
            }
        }
        dataFriendViewModel.hideLoading = {
            DispatchQueue.main.async {
                
            }
        }
        dataFriendViewModel.getData()
    }
    //朋友按鈕事件
    func menuFriendClickEvent(){
        //聊天介面隱藏
        chatUnderLineView.isHidden = true
        chatView.isHidden = true
        
        //朋友介面顯示
        friendUnderLineView.isHidden = false
        friendViewReload()
    }
    
    //聊天是按鈕事件
    func menuChatClickEvent(){
        //聊天介面隱藏
        chatUnderLineView.isHidden = false
        chatView.isHidden = false
        
        //朋友介面顯示
        haveFriendView.isHidden = true
        friendUnderLineView.isHidden = true
        noFriendView.isHidden = true
    }
    
    func friendViewReload(){
        if(self.dataFriendViewModel.numberOfCells > 0){
            haveFriendView.isHidden = false
            noFriendView.isHidden = true
        } else {
            haveFriendView.isHidden = true
            noFriendView.isHidden = false
        }
    }
    
    @IBAction func menuFriendClick(_ sender: Any) {
        menuFriendClickEvent()
    }
    @IBAction func menuChatClick(_ sender: Any) {
        menuChatClickEvent()
    }
    
}
extension FriendViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellFriend", for: indexPath) as? TableViewCellFriend else {
            fatalError("Cell not exists in storyBoard")
        }
        cell.setData(data: dataFriendViewModel.getCellViewModel(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataFriendViewModel.numberOfCells
    }
}
