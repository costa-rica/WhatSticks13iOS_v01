//
//  UserVcUserStatusView.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 18/08/2024.
//

import UIKit

class UserVcUserStatusView: UIView {
    
    var showLine:Bool!
    let vwUserStatusLine = UIView()
    var viewTopAnchor:NSLayoutAnchor<NSLayoutYAxisAnchor>!
    
    var userStore: UserStore!
    let lblTitleUserStatus = UILabel()
    
    let stckVwUser = UIStackView()
    
    let stckVwUsername = UIStackView()
    let lblUsername = UILabel()
    let btnUsernameFilled = UIButton()
    
    let stckVwRecordCount = UIStackView()
    let lblRecordCount = UILabel()
    let btnRecordCountFilled = UIButton()
    
    var constraints_NO_VwRegisterButton = [NSLayoutConstraint]()
    
    let vwRegisterButton = UserVcRegisterButton()
    var constraints_YES_VwRegisterButton = [NSLayoutConstraint]()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showLine = false
        setup_UserVcAccountView()
    }
    init(frame: CGRect, showLine: Bool) {
        self.showLine = showLine
        super.init(frame: frame)
        setup_UserVcAccountView_lineOption()
        setup_UserVcAccountView()
    }
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup_UserVcAccountView()
//    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup_UserVcAccountView_lineOption(){
        vwUserStatusLine.accessibilityIdentifier = "vwUserStatusLine"
        vwUserStatusLine.translatesAutoresizingMaskIntoConstraints = false
        vwUserStatusLine.backgroundColor = UIColor(named: "lineColor")
        self.addSubview(vwUserStatusLine)
        NSLayoutConstraint.activate([
            vwUserStatusLine.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            vwUserStatusLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vwUserStatusLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vwUserStatusLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    private func setup_UserVcAccountView(){
        userStore = UserStore.shared
        
        lblTitleUserStatus.accessibilityIdentifier="lblTitleUserStatus"
        lblTitleUserStatus.text = "Current account status"
        lblTitleUserStatus.translatesAutoresizingMaskIntoConstraints=false
        lblTitleUserStatus.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        lblTitleUserStatus.numberOfLines = 0
        self.addSubview(lblTitleUserStatus)
        
        stckVwUser.accessibilityIdentifier = "stckVwUser"
        stckVwUser.translatesAutoresizingMaskIntoConstraints=false
        
        stckVwUser.axis = .vertical
        stckVwUser.alignment = .fill
        stckVwUser.distribution = .fillEqually
        stckVwUser.spacing = 10
        
        stckVwUsername.accessibilityIdentifier = "stckVwUser"
        stckVwUsername.translatesAutoresizingMaskIntoConstraints=false
        stckVwUsername.axis = .horizontal
        stckVwUsername.alignment = .fill
        stckVwUsername.distribution = .fill
        stckVwUsername.spacing = 10
        
        stckVwRecordCount.accessibilityIdentifier = "stckVwRecordCount"
        stckVwRecordCount.translatesAutoresizingMaskIntoConstraints=false
        stckVwRecordCount.axis = .horizontal
        stckVwRecordCount.alignment = .fill
        stckVwRecordCount.distribution = .fill
        stckVwRecordCount.spacing = 10
        
        lblUsername.accessibilityIdentifier="lblUsername"
        lblUsername.text = "username"
        lblUsername.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        lblUsername.translatesAutoresizingMaskIntoConstraints=false
        lblUsername.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        /* there is also setContentCompressionResistancePriority */
        
        btnUsernameFilled.accessibilityIdentifier="btnUsernameFilled"
        //        print("?????? 2 --- > \(userStore.user.username)")
        //        btnUsernameFilled.setTitle(userStore.user.username, for: .normal)
        if let font = UIFont(name: "ArialRoundedMTBold", size: 17) {
            btnUsernameFilled.titleLabel?.font = font
        }
        btnUsernameFilled.backgroundColor = UIColor(named: "ColorRow3Textfields")
        btnUsernameFilled.setTitleColor(UIColor(named: "lineColor"), for: .normal)
        btnUsernameFilled.layer.borderWidth = 1
        btnUsernameFilled.layer.cornerRadius = 5
        btnUsernameFilled.translatesAutoresizingMaskIntoConstraints = false
        btnUsernameFilled.accessibilityIdentifier="btnUsernameFilled"
        
        stckVwUsername.addArrangedSubview(lblUsername)
        stckVwUsername.addArrangedSubview(btnUsernameFilled)
        
        stckVwRecordCount.accessibilityIdentifier = "stckVwUser"
        stckVwRecordCount.translatesAutoresizingMaskIntoConstraints=false
        
        lblRecordCount.accessibilityIdentifier="lblRecordCount"
        lblRecordCount.text = "record count"
        lblRecordCount.font = UIFont(name: "ArialRoundedMTBold", size: 15)
        lblRecordCount.translatesAutoresizingMaskIntoConstraints=false
        lblRecordCount.setContentHuggingPriority(UILayoutPriority(251), for: .horizontal)
        
        btnRecordCountFilled.accessibilityIdentifier="btnRecordCountFilled"
        btnRecordCountFilled.setTitle("0", for: .normal)
        if let font = UIFont(name: "ArialRoundedMTBold", size: 17) {
            btnRecordCountFilled.titleLabel?.font = font
        }
        btnRecordCountFilled.setTitleColor(UIColor(named: "lineColor"), for: .normal)
        btnRecordCountFilled.backgroundColor = UIColor(named: "ColorRow3Textfields")
        btnRecordCountFilled.layer.borderWidth = 1
        btnRecordCountFilled.layer.cornerRadius = 5
        btnRecordCountFilled.translatesAutoresizingMaskIntoConstraints = false
        btnRecordCountFilled.accessibilityIdentifier="btnRecordCountFilled"
        
        stckVwRecordCount.addArrangedSubview(lblRecordCount)
        stckVwRecordCount.addArrangedSubview(btnRecordCountFilled)
        
        stckVwUser.addArrangedSubview(stckVwUsername)
        stckVwUser.addArrangedSubview(stckVwRecordCount)
        
        self.addSubview(stckVwUser)
        
        if showLine{
            viewTopAnchor = vwUserStatusLine.bottomAnchor
        } else {
            viewTopAnchor = self.topAnchor
        }
        
        NSLayoutConstraint.activate([
            lblTitleUserStatus.topAnchor.constraint(equalTo: viewTopAnchor, constant: heightFromPct(percent: 3)),
            lblTitleUserStatus.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthFromPct(percent: 2)),
            lblTitleUserStatus.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 2)),
            
            stckVwUser.topAnchor.constraint(equalTo: lblTitleUserStatus.bottomAnchor,constant: heightFromPct(percent: 2)),
            stckVwUser.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthFromPct(percent: -1)),
            stckVwUser.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 3)),
            
            btnUsernameFilled.widthAnchor.constraint(lessThanOrEqualTo: btnRecordCountFilled.widthAnchor)
        ])
        
        
        constraints_NO_VwRegisterButton = [
            stckVwUser.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: heightFromPct(percent: -3)),
        ]
        constraints_YES_VwRegisterButton = [
            vwRegisterButton.topAnchor.constraint(equalTo: stckVwUser.bottomAnchor, constant: heightFromPct(percent: 2)),
            vwRegisterButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 2)),
            vwRegisterButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthFromPct(percent: -2)),
            vwRegisterButton.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: heightFromPct(percent: -3)),
        ]
        
        //        if userStore.user.email != nil {
        //            vwRegisterButton.removeFromSuperview()
        //            NSLayoutConstraint.activate(constraints_NO_VwRegisterButton)
        //        } else {
        //            setup_vcRegistrationButton()
        //        }
        
    }
    
    func setup_vcRegistrationButton(){
        vwRegisterButton.accessibilityIdentifier = "vwRegisterButton"
        vwRegisterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate(constraints_NO_VwRegisterButton)
        self.addSubview(vwRegisterButton)
        btnUsernameFilled.setTitle(userStore.user.username, for: .normal)
        NSLayoutConstraint.activate(constraints_YES_VwRegisterButton)
    }
    
    func remove_vcRegistrationButton(){
        NSLayoutConstraint.deactivate(constraints_YES_VwRegisterButton)
        vwRegisterButton.removeFromSuperview()
        btnUsernameFilled.setTitle(userStore.user.username, for: .normal)
        NSLayoutConstraint.activate(constraints_NO_VwRegisterButton)
    }
    
    
    
    
}



