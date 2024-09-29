//
//  badge.swift
//  App
//
//  Created by ios on 2024/9/29.
//

import UIKit

class BadgeUIView: UIView {
    let badgeView = UIView()
    let badgeLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func setBadgeView(num:Int, parentView: UIView){
        var numString = "0"
        if(num>99){numString = "99+"}
        else {numString = String(num)}
        setupBadgeView(numString: numString)
        parentView.addSubview(badgeView)
        setupBadgeConstraints()
    }
    
    func setupBadgeView(numString:String){
        badgeView.backgroundColor = UIColor(named: "hotPink")
        badgeView.layer.cornerRadius = 10
        badgeView.translatesAutoresizingMaskIntoConstraints = false
        
        //設定徽章的數字
        badgeLabel.text = numString
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont.boldSystemFont(ofSize: 14)
        badgeLabel.textAlignment = .center
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        badgeView.addSubview(badgeLabel)
        
        //設定高度
        badgeView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //設定徽章大小
        badgeLabel.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 5).isActive = true
        badgeLabel.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -5).isActive = true
        badgeLabel.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor).isActive = true
        
        
        //根據文字的內容來設定徽章高度
        badgeLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        
    }
    func setupBadgeConstraints(){
        guard let superview = badgeView.superview else {return}
        var constant = 20
        let LabelCount = badgeLabel.text?.count
        if(LabelCount == 3){constant = 20}
        else if(LabelCount == 2){constant = 13}
        else if(LabelCount == 1){constant = 5}
        //設定徽章位置
        NSLayoutConstraint.activate([
            badgeView.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: CGFloat(constant)),
            badgeView.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0)
        ])
    }}
