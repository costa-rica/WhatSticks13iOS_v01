//
//  UserVcRegisterButton.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 18/08/2024.
//

import UIKit

class UserVcRegisterButton: UIView {
    
    weak var delegate: UserVcRegisterButtonDelegate?
    
    let lblWhyUsernameTitle = UILabel()
    let lblWhyUsernameDescription = UILabel()
    
    let btnRegister = UIButton()
    
    let lblWhyRegisterTitle = UILabel()
    let lblWhyRegisterDescription = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // This triggers as soon as the app starts
        setup_UserVcRegisterButton()
    }
    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup_UserVcRegisterButton()
//    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup_UserVcRegisterButtonViewDisclaimer(){
        lblWhyUsernameTitle.accessibilityIdentifier="lblWhyUsernameTitle"
        lblWhyUsernameTitle.translatesAutoresizingMaskIntoConstraints = false
        lblWhyUsernameTitle.text = "Why do I have a username?"
        lblWhyUsernameTitle.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        lblWhyUsernameTitle.numberOfLines=0
        self.addSubview(lblWhyUsernameTitle)
        
        lblWhyUsernameDescription.accessibilityIdentifier="lblWhyUsernameDescription"
        lblWhyUsernameDescription.translatesAutoresizingMaskIntoConstraints = false
        lblWhyUsernameDescription.text = "This ID is used to keep track of the analyzed data. It does not have any personal information."
        lblWhyUsernameDescription.numberOfLines=0
        self.addSubview(lblWhyUsernameDescription)
        NSLayoutConstraint.activate([
            lblWhyUsernameTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: heightFromPct(percent: 3)),
            lblWhyUsernameTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblWhyUsernameTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            lblWhyUsernameDescription.topAnchor.constraint(equalTo: lblWhyUsernameTitle.bottomAnchor, constant: heightFromPct(percent: 5)),
            lblWhyUsernameDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblWhyUsernameDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
        ])
    }
    
    private func setup_UserVcRegisterButton(){
        
        btnRegister.setTitle("Register", for: .normal)
        btnRegister.setImage(UIImage(systemName: "person"), for: .normal)
        btnRegister.tintColor = .white
        btnRegister.layer.borderColor = UIColor.systemBlue.cgColor
        btnRegister.layer.borderWidth = 2
        btnRegister.backgroundColor = .systemBlue
        btnRegister.layer.cornerRadius = 10
        btnRegister.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(btnRegister)
        // Add space between the image and the text
        btnRegister.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        // Change size of image
        btnRegister.imageView?.layer.transform = CATransform3DMakeScale(1.5,1.5,1.5)
        btnRegister.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 27)
        
        btnRegister.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        btnRegister.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        
        lblWhyRegisterTitle.accessibilityIdentifier="lblWhyRegisterTitle"
        lblWhyRegisterTitle.translatesAutoresizingMaskIntoConstraints = false
        lblWhyRegisterTitle.text = "Why Register?"
        lblWhyRegisterTitle.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        lblWhyRegisterTitle.numberOfLines=0
        self.addSubview(lblWhyRegisterTitle)
        
        lblWhyRegisterDescription.accessibilityIdentifier="lblWhyRegisterDescription"
        lblWhyRegisterDescription.translatesAutoresizingMaskIntoConstraints = false
        lblWhyRegisterDescription.text = "Creating an account will allow you to access your user page on the what-sticks.com website where you can download files with the daily values for each variable used to calculate your correlations."
        lblWhyRegisterDescription.numberOfLines=0
        self.addSubview(lblWhyRegisterDescription)
        
        NSLayoutConstraint.activate([
            
            btnRegister.topAnchor.constraint(equalTo: self.topAnchor, constant: heightFromPct(percent: 3)),
            btnRegister.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: widthFromPct(percent: 3)),
            btnRegister.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthFromPct(percent: -3)),
            
            lblWhyRegisterTitle.topAnchor.constraint(equalTo: btnRegister.bottomAnchor, constant: heightFromPct(percent: 5)),
            lblWhyRegisterTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblWhyRegisterTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            lblWhyRegisterDescription.topAnchor.constraint(equalTo: lblWhyRegisterTitle.bottomAnchor, constant: heightFromPct(percent: 3)),
            lblWhyRegisterDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: widthFromPct(percent: 3)),
            lblWhyRegisterDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: widthFromPct(percent: -1)),
            lblWhyRegisterDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: heightFromPct(percent: -5))
            
        ])
        
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        delegate?.touchDown(sender)
    }
    
    @objc func touchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        
        if UserStore.shared.isGuestMode{
            let informationVc = InformationVC()
            informationVc.vwInformation.lblTitle.text = "Guest Mode"
            informationVc.vwInformation.lblDescription.text = "While in guest mode user's cannot send data. \n\n If you would like to analyze your data please close the app and restart in Normal mode."
            informationVc.modalPresentationStyle = .overCurrentContext
            informationVc.modalTransitionStyle = .crossDissolve
            self.delegate?.presentNewView(informationVc)
        }
        else {
            let regModalVC = RegModalVC()
            // Set the modal presentation style
            regModalVC.modalPresentationStyle = .overCurrentContext
            regModalVC.modalTransitionStyle = .crossDissolve
            self.delegate?.presentNewView(regModalVC)
            regModalVC.delegate = self.delegate as? any RegModalVcDelegate
        }
    }
    
}

protocol UserVcRegisterButtonDelegate: AnyObject {
    func removeSpinner()
    func showSpinner()
    func templateAlert(alertTitle:String,alertMessage: String,  backScreen: Bool, dismissView:Bool)
    func presentAlertController(_ alertController: UIAlertController)
    func touchDown(_ sender: UIButton)
    func presentNewView(_ uiViewController: UIViewController)
}


