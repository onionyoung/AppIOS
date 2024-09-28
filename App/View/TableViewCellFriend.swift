//
//  TableViewCellFriend.swift
//  App
//
//  Created by ios on 2024/9/27.
//

import UIKit

class TableViewCellFriend: UITableViewCell {
    
    @IBOutlet weak var transferMoneyButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var transferMoneyTrailing: NSLayoutConstraint!
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    
    @IBOutlet weak var friendImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(data:DataFriend){
        friendNameLabel.text = data.name
        //星星
        if (data.isTop){
            starImageView.isHidden = false
        } else {
            starImageView.isHidden = true
        }
        //狀態
        if (data.status == 0){
            //邀請送出
            //不應該進來這裡
        } else if (data.status == 1){
            //已完成
            inviteButton.isHidden = true
            moreButton.isHidden = false
            transferMoneyTrailing.constant = moreButton.bounds.width + 20
        } else if (data.status == 2){
            //邀請中
            inviteButton.isHidden = false
            moreButton.isHidden = true
            transferMoneyTrailing.constant = inviteButton.bounds.width + 20
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func inviteClick(_ sender: Any) {
        print("invite")
    }
    @IBAction func moreClick(_ sender: Any) {
        print("more")
    }
    @IBAction func transferMoneyClick(_ sender: Any) {
        print("transferMoney")
    }
    
}
