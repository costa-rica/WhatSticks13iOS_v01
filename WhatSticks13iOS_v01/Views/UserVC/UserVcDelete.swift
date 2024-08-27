//
//  UserVcDelete.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 18/08/2024.
//
import UIKit

class UserVcDelete: UIView {
    weak var delegate: UserVcDeleteDelegate?
    var showLine:Bool!
    let vwDeleteLine = UIView()
    var viewTopAnchor:NSLayoutAnchor<NSLayoutYAxisAnchor>!
    let lblDeleteTitle = UILabel()
    let lblDeleteDescription = UILabel()
    let btnDelete = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.showLine=false
        setup_UserVcRegisterButtonViewDisclaimer()
        setup_UserVcRegisterButton()
    }
    
    init(frame: CGRect, showLine: Bool) {
        self.showLine = showLine
        super.init(frame: frame)
        setup_UserVcRegisterButtonViewDisclaimer_with_vwDeleteLine()
        setup_UserVcRegisterButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup_UserVcRegisterButtonViewDisclaimer_with_vwDeleteLine(){
        vwDeleteLine.accessibilityIdentifier = "vwDeleteLine"
        vwDeleteLine.translatesAutoresizingMaskIntoConstraints = false
        vwDeleteLine.backgroundColor = UIColor(named: "lineColor")
        self.addSubview(vwDeleteLine)
        NSLayoutConstraint.activate([
            vwDeleteLine.topAnchor.constraint(equalTo: self.topAnchor, constant:heightFromPct(percent: 1)),
            vwDeleteLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vwDeleteLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vwDeleteLine.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        lblDeleteTitle.accessibilityIdentifier="lblDeleteTitle"
        lblDeleteTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDeleteTitle.text = "Delete Account"
        lblDeleteTitle.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        lblDeleteTitle.numberOfLines=0
        self.addSubview(lblDeleteTitle)
        
        lblDeleteDescription.accessibilityIdentifier="lblDeleteDescription"
        lblDeleteDescription.translatesAutoresizingMaskIntoConstraints = false
        lblDeleteDescription.text = "This will delete your credentials and the data you have linked from your phone."
        lblDeleteDescription.numberOfLines=0
        self.addSubview(lblDeleteDescription)
        
        if showLine{
            viewTopAnchor=vwDeleteLine.bottomAnchor
        } else{
            viewTopAnchor=self.topAnchor
        }
        
        NSLayoutConstraint.activate([
            lblDeleteTitle.topAnchor.constraint(equalTo: viewTopAnchor, constant: heightFromPct(percent: 3)),
            lblDeleteTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: widthFromPct(percent: 2)),
            lblDeleteTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            lblDeleteDescription.topAnchor.constraint(equalTo: lblDeleteTitle.bottomAnchor, constant: heightFromPct(percent: 3)),
            lblDeleteDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: widthFromPct(percent: 3)),
            lblDeleteDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private func setup_UserVcRegisterButtonViewDisclaimer(){
        lblDeleteTitle.accessibilityIdentifier="lblDeleteTitle"
        lblDeleteTitle.translatesAutoresizingMaskIntoConstraints = false
        lblDeleteTitle.text = "Delete Account"
        lblDeleteTitle.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        lblDeleteTitle.numberOfLines=0
        self.addSubview(lblDeleteTitle)
        
        lblDeleteDescription.accessibilityIdentifier="lblDeleteDescription"
        lblDeleteDescription.translatesAutoresizingMaskIntoConstraints = false
        lblDeleteDescription.text = "This will delete your credentials and the data you have linked from your phone."
        lblDeleteDescription.numberOfLines=0
        self.addSubview(lblDeleteDescription)
        
        NSLayoutConstraint.activate([
            lblDeleteTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: heightFromPct(percent: 5)),
            lblDeleteTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblDeleteTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            lblDeleteDescription.topAnchor.constraint(equalTo: lblDeleteTitle.bottomAnchor, constant: heightFromPct(percent: 5)),
            lblDeleteDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            lblDeleteDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
        ])
    }
    
    private func setup_UserVcRegisterButton(){
        
        btnDelete.accessibilityIdentifier = "btnDelete"
        btnDelete.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(btnDelete)
        btnDelete.setTitle("Delete", for: .normal)
        btnDelete.layer.borderColor = UIColor.systemRed.cgColor
        btnDelete.layer.borderWidth = 2
        btnDelete.backgroundColor = .systemRed
        btnDelete.layer.cornerRadius = 10
        
        btnDelete.addTarget(self, action: #selector(buttonTouchDown), for: .touchDown)
        btnDelete.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        
        
        
        NSLayoutConstraint.activate([
            
            btnDelete.topAnchor.constraint(equalTo: lblDeleteDescription.bottomAnchor, constant: heightFromPct(percent: 5)),
            btnDelete.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: widthFromPct(percent: 3)),
            btnDelete.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: widthFromPct(percent: -3)),
            btnDelete.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: heightFromPct(percent: -5))
            
        ])
        
    }
    
    @objc private func buttonTouchDown(_ sender: UIButton) {
        delegate?.touchDown(sender)
    }
    
    @objc func touchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        
        print("Touch up inside --> vwRegisterButton")
        
        //        let areYouSureVC = AreYouSureModalVC()
        let areYouSureVC = AreYouSureModalVC(strForBtnTitle: "Yes, let's delete")
        
        // Set the modal presentation style
        areYouSureVC.modalPresentationStyle = .overCurrentContext
        areYouSureVC.modalTransitionStyle = .crossDissolve
        areYouSureVC.delegate = self.delegate as? any AreYouSureModalVcDelegate
        self.delegate?.presentNewView(areYouSureVC)
        
    }
    
}

protocol UserVcDeleteDelegate: AnyObject {
    //    func didUpdateWeatherInfo(_ weatherInfo: String)
    func removeSpinner()
    func showSpinner()
    func templateAlert(alertTitle:String,alertMessage: String,  backScreen: Bool, dismissView:Bool)
    func presentAlertController(_ alertController: UIAlertController)
    func touchDown(_ sender: UIButton)
    //    func touchDownProxy(_ sender: UIButton)
    func presentNewView(_ uiViewController: UIViewController)
}

