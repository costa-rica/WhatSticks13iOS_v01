//
//  UserVcOffline.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 18/08/2024.
//

import UIKit

class UserVcOffline: UIView {
    weak var delegate: UserVcOfflineDelegate?
    let userStore = UserStore.shared
    var showLine:Bool!
    let vwOfflineLine = UIView()
    var viewTopAnchor:NSLayoutAnchor<NSLayoutYAxisAnchor>!
    let lblOfflineTitle = UILabel()
    let btnConnectDevice = UIButton()
    let lblDescriptionTitle = UILabel()
    let lblDescription = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        // This triggers as soon as the app starts
        self.showLine = false
        setup_UserVcOfflineViews()
    }
    init(frame: CGRect, showLine: Bool) {
        self.showLine = showLine
        super.init(frame: frame)
        setup_UserVcOfflineViews_lineOption()
        setup_UserVcOfflineViews()
    }
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup_UserVcOfflineViews()
//    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup_UserVcOfflineViews_lineOption(){
        vwOfflineLine.accessibilityIdentifier = "vwOfflineLine"
        vwOfflineLine.translatesAutoresizingMaskIntoConstraints = false
        vwOfflineLine.backgroundColor = UIColor(named: "lineColor")
        self.addSubview(vwOfflineLine)
        NSLayoutConstraint.activate([
            vwOfflineLine.topAnchor.constraint(equalTo: self.topAnchor),
            vwOfflineLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vwOfflineLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vwOfflineLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    
    private func setup_UserVcOfflineViews(){
        lblOfflineTitle.accessibilityIdentifier="lblOfflineTitle"
        lblOfflineTitle.translatesAutoresizingMaskIntoConstraints = false
        lblOfflineTitle.text = "Currently offline"
        lblOfflineTitle.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        lblOfflineTitle.numberOfLines=0
        self.addSubview(lblOfflineTitle)
        
        btnConnectDevice.accessibilityIdentifier = "btnConnectDevice"
        btnConnectDevice.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(btnConnectDevice)
        btnConnectDevice.setTitle("Connect device", for: .normal)
        btnConnectDevice.layer.borderColor = UIColor.systemBlue.cgColor
        btnConnectDevice.layer.borderWidth = 2
        btnConnectDevice.backgroundColor = .systemBlue
        btnConnectDevice.layer.cornerRadius = 10
        
        btnConnectDevice.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        btnConnectDevice.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        
        lblDescriptionTitle.accessibilityIdentifier="lblDescriptionTitle"
        lblDescriptionTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDescriptionTitle.text = "Why do I want to connect device?"
        lblDescriptionTitle.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        lblDescriptionTitle.numberOfLines=0
        self.addSubview(lblDescriptionTitle)
        
        lblDescription.accessibilityIdentifier="lblDescription"
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        lblDescription.text = "If you would like to see your dashboard you will need to connect your device so your data can be processed."
        lblDescription.numberOfLines=0
        self.addSubview(lblDescription)
        
        if showLine{
            viewTopAnchor = vwOfflineLine.bottomAnchor
        } else {
            viewTopAnchor = self.topAnchor
        }
        
        NSLayoutConstraint.activate([
            lblOfflineTitle.topAnchor.constraint(equalTo: viewTopAnchor, constant: heightFromPct(percent: 3)),
            lblOfflineTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 2)),
            lblOfflineTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthFromPct(percent: -1)),
            
            btnConnectDevice.topAnchor.constraint(equalTo: lblOfflineTitle.bottomAnchor, constant: heightFromPct(percent: 3)),
            btnConnectDevice.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: widthFromPct(percent: 3)),
            btnConnectDevice.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: widthFromPct(percent: -3)),
            
            lblDescriptionTitle.topAnchor.constraint(equalTo: btnConnectDevice.bottomAnchor, constant: heightFromPct(percent: 3)),
            lblDescriptionTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: widthFromPct(percent: 2)),
            lblDescriptionTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            lblDescription.topAnchor.constraint(equalTo: lblDescriptionTitle.bottomAnchor, constant: heightFromPct(percent: 2)),
            lblDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: widthFromPct(percent: 3)),
            lblDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: widthFromPct(percent: -1)),
            lblDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: heightFromPct(percent: -5))
            
        ])
        
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        delegate?.touchDown(sender)
    }
    
    @objc func touchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        delegate?.showSpinner()
        userStore.connectDevice {
            OperationQueue.main.addOperation {
                if !self.userStore.isOnline, self.userStore.user.email == nil {
                    self.delegate?.case_option_1_Offline_and_generic_name()
                    self.delegate?.templateAlert(alertTitle: "No connection", alertMessage: "", backScreen: false, dismissView: false)
                }else if self.userStore.isOnline, self.userStore.user.email == nil{
                    print("UserVC offline connected!!! --")
                    self.delegate?.case_option_2_Online_and_generic_name()
                } else if self.userStore.isOnline, self.userStore.user.email != nil{
                    self.delegate?.case_option_3_Online_and_custom_email()
                } else if !self.userStore.isOnline, self.userStore.user.email != nil {
                    self.delegate?.templateAlert(alertTitle: "No connection", alertMessage: "", backScreen: false, dismissView: false)
                    self.delegate?.case_option_4_Offline_and_custom_email()
                }
                self.delegate?.removeSpinner()
            }
        }
        
    }
    
}

protocol UserVcOfflineDelegate: AnyObject {
    func removeSpinner()
    func showSpinner()
    func templateAlert(alertTitle:String,alertMessage: String,  backScreen: Bool, dismissView:Bool)
    func presentAlertController(_ alertController: UIAlertController)
    func touchDown(_ sender: UIButton)
    func case_option_1_Offline_and_generic_name()
    func case_option_2_Online_and_generic_name()
    func case_option_3_Online_and_custom_email()
    func case_option_4_Offline_and_custom_email()
}
