//
//  HomeVcHeaderView.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 20/08/2024.
//

import UIKit

class HomeVcHeaderView: UIView {
    var imgLogo:UIImage?
    let imgVwLogo = UIImageView()
    let lblWhatSticks = UILabel()
    let lblDescription = UILabel()
    
//    let vwHomeVcLine = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // This triggers as soon as the app starts
        setupHomeVcHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupHomeVcHeaderView(){
        guard let imgLogo = UIImage(named: "logo") else {
            print("Missing logo")
            return
        }
        imgVwLogo.image = imgLogo.scaleImage(toSize: CGSize(width: 50, height: 50))
        imgVwLogo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imgVwLogo)
        imgVwLogo.accessibilityIdentifier = "imgVwLogo"

        lblWhatSticks.text = "What Sticks"
        lblWhatSticks.font = UIFont(name: "ArialRoundedMTBold", size: 30)
        //        lblWhatSticks.numberOfLines = 0
        lblWhatSticks.translatesAutoresizingMaskIntoConstraints=false
        self.addSubview(lblWhatSticks)
        lblWhatSticks.accessibilityIdentifier="lblWhatSticks"

        lblDescription.text = "The app designed to use data already being collected by your devices and other apps to help you understand your tendencies and habits."
        lblDescription.numberOfLines = 0
        lblDescription.translatesAutoresizingMaskIntoConstraints=false
        self.addSubview(lblDescription)
        lblDescription.accessibilityIdentifier="lblDescription"
        
//        vwHomeVcLine.accessibilityIdentifier = "vwHomeVcLine"
//        vwHomeVcLine.translatesAutoresizingMaskIntoConstraints = false
//        vwHomeVcLine.backgroundColor = UIColor(named: "lineColor")
//        self.addSubview(vwHomeVcLine)
        
        NSLayoutConstraint.activate([
            imgVwLogo.heightAnchor.constraint(equalTo: imgVwLogo.widthAnchor, multiplier: 1.0),
            imgVwLogo.topAnchor.constraint(equalTo: self.topAnchor, constant: heightFromPct(percent: 5)),
            imgVwLogo.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: widthFromPct(percent: -1)),
            
            lblWhatSticks.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 1)),
            lblWhatSticks.topAnchor.constraint(equalTo: imgVwLogo.bottomAnchor,constant: heightFromPct(percent: -3)),
            
            lblDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 3)),
            lblDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthFromPct(percent: -1)),
            lblDescription.topAnchor.constraint(equalTo: lblWhatSticks.bottomAnchor, constant: widthFromPct(percent: 3)),
            
//            vwHomeVcLine.topAnchor.constraint(equalTo: lblDescription.bottomAnchor, constant: heightFromPct(percent: 3)),
//            vwHomeVcLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            vwHomeVcLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//            vwHomeVcLine.heightAnchor.constraint(equalToConstant: 1),
//            vwHomeVcLine.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
        
        
    }
}
