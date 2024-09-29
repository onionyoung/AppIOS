//
//  FriendViewController.swift
//  App
//
//  Created by ios on 2024/9/27.
//

import UIKit

class FriendViewController: UIViewController, UISearchBarDelegate {

    //邀請介面－暫定
    @IBOutlet weak var topViewWidth: NSLayoutConstraint!
    @IBOutlet weak var bottomViewWidth: NSLayoutConstraint!
    @IBOutlet weak var inviteViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topViewName: UILabel!
    @IBOutlet weak var bottomViewName: UILabel!
    
    var isExpanded = false
    //loading
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var FriendTableView: UITableView!
    var refreshControl = UIRefreshControl()
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
        refreshControl.attributedTitle = NSAttributedString(string: "更新")
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        refreshControl.tintColor = .black
        FriendTableView.addSubview(refreshControl)
        FriendTableView.delegate = self
        FriendTableView.dataSource = self
        FriendTableView.register(UINib(nibName: "TableViewCellFriend", bundle: nil), forCellReuseIdentifier: "TableViewCellFriend")
        dataFriendViewModel.reloadTableView = {
            DispatchQueue.main.async {
                if(self.dataFriendViewModel.datas.count > 0){
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
                self.activityIndicator.startAnimating()
            }
        }
        dataFriendViewModel.hideLoading = {
            DispatchQueue.main.async {
                sleep(2)
                self.activityIndicator.stopAnimating()
            }
        }
        dataFriendViewModel.reloadInviteView = {
            DispatchQueue.main.async{
                self.inviteViewSetData()
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
    //有無朋友介面互換
    func friendViewReload(){
        if(self.dataFriendViewModel.datas.count > 0){
            haveFriendView.isHidden = false
            noFriendView.isHidden = true
            
            //talbeview
            FriendTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y:0, width: 0, height:CGFloat.leastNonzeroMagnitude))
            //searchbar ui setting
            searchBar.delegate = self
            let steel = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1)
            let searchField = searchBar.value(forKey: "searchField") as? UITextField
            searchField?.textColor = steel
            searchField?.attributedPlaceholder = NSAttributedString(string: "想轉一筆給誰呢？", attributes: [NSAttributedString.Key.foregroundColor : steel])
            searchField?.leftView?.tintColor = steel
            let clearButton = searchField?.value(forKey: "_clearButton") as? UIButton
            clearButton?.tintColor = steel
        } else {
            haveFriendView.isHidden = true
            noFriendView.isHidden = false
        }
    }
    //friend tableview 下拉更新
    @objc func refreshTableView(){
        //init searchbar
        searchBar.text = ""
        self.searchBar.endEditing(true)
        //getdata and refresh
        dataFriendViewModel.getData()
        refreshControl.endRefreshing()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        if searchText.isEmpty{
            dataFriendViewModel.searchData(keyword: "")
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        dataFriendViewModel.searchData(keyword:searchBar.text ?? "")
        self.searchBar.endEditing(true)
    }
    
    
    @IBAction func menuFriendClick(_ sender: Any) {
        menuFriendClickEvent()
    }
    @IBAction func menuChatClick(_ sender: Any) {
        menuChatClickEvent()
    }
    
    @IBAction func topViewExpandClick(_ sender: Any) {
        inviteViewExpandEvent()
    }
    @IBAction func bottomViewExpandClick(_ sender: Any) {
        inviteViewExpandEvent()
    }
    @IBAction func topViewConfirm(_ sender: Any) {
        
    }
    //邀請清單展開縮放動畫
    func inviteViewExpandEvent(){
        var count = dataFriendViewModel.numberOfInviteCells
        if(count < 2){ return }
        UIView.animate(withDuration: 0.5){
            if self.isExpanded{
                self.inviteViewHeight.constant = 100
                self.bottomViewWidth.constant = -30
            } else {
                self.inviteViewHeight.constant = 170
                self.bottomViewWidth.constant = 0
            }
            self.view.layoutIfNeeded()
            self.isExpanded.toggle()
        }
    }
    //inviteView setData
    func inviteViewSetData(){
        let count = dataFriendViewModel.numberOfInviteCells
        if(count == 0){
            inviteViewHeight.constant = 0
            bottomView.isHidden = true
            topView.isHidden = true
        } else if(count == 1){
            inviteViewHeight.constant = 100
            topViewName.text = dataFriendViewModel.getInviteCellViewModel(index: 0).name
            bottomView.isHidden = true
            topView.isHidden = false
        } else if(count == 2){
            inviteViewHeight.constant = 100
            topViewName.text = dataFriendViewModel.getInviteCellViewModel(index: 0).name
            bottomViewName.text = dataFriendViewModel.getInviteCellViewModel(index: 1).name
            bottomView.isHidden = false
            topView.isHidden = false
        }
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
