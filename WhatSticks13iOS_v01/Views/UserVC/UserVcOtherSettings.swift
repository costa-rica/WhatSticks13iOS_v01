//
//  UserVcOtherSettings.swift
//  WhatSticks13iOS_v01
//
//  Created by Nick Rodriguez on 05/10/2024.
//

import UIKit

class UserVcOtherSettings: UIView {
    
//    weak var delegate: UserVcRegisterButtonDelegate?
    let vwLine = UIView()
    let lblTitle = UILabel()
    let lblDescription = UILabel()
    
    let stckVwGuestOption = UIStackView()
    let lblGuestOption = UILabel()
    let swtchGuestOption = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // This triggers as soon as the app starts
        setup_labels()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup_labels()
    }
    func setup_labels(){

        vwLine.accessibilityIdentifier = "vwLocationDayWeatherLine"
        vwLine.translatesAutoresizingMaskIntoConstraints = false
        vwLine.backgroundColor = UIColor(named: "lineColor")
        self.addSubview(vwLine)
       
        
        
        lblTitle.accessibilityIdentifier="lblTitle-UserVcOtherSettings"
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        lblTitle.text = "Other Settings"
        lblTitle.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        lblTitle.numberOfLines=0
        self.addSubview(lblTitle)
        
//        lblDescription.accessibilityIdentifier="lblDescription-UserVcOtherSettings"
//        lblDescription.translatesAutoresizingMaskIntoConstraints=false
//        let text_for_message = "Go to Settings > Health > Data Access & Devices > WhatSticks to grant access.\n\nFor this app to work properly please make sure all data types are allowed."
//        lblDescription.text = text_for_message
//        lblDescription.numberOfLines = 0
//        self.addSubview(lblDescription)
        
        
        
        stckVwGuestOption.accessibilityIdentifier="stckVwGuestOption"
        stckVwGuestOption.translatesAutoresizingMaskIntoConstraints=false
        stckVwGuestOption.spacing = 5
        stckVwGuestOption.axis = .horizontal
        self.addSubview(stckVwGuestOption)
        
        lblGuestOption.accessibilityIdentifier="lblGuestOption"
        lblGuestOption.translatesAutoresizingMaskIntoConstraints=false
        lblGuestOption.text = "Show guest option on launch:"
        stckVwGuestOption.addArrangedSubview(lblGuestOption)
        
//        swtchLocTrackReoccurring.accessibilityIdentifier = "swtchLocationDayWeather"
//        swtchLocTrackReoccurring.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        stckVwGuestOption.addArrangedSubview(swtchGuestOption)
        
        
        swtchGuestOption.accessibilityIdentifier = "swtchGuestOption"
        swtchGuestOption.addTarget(self, action: #selector(swtchGuestOptionValueChanged(_:)), for: .valueChanged)
        
        
        
        NSLayoutConstraint.activate([
            
            vwLine.topAnchor.constraint(equalTo: self.topAnchor),
            vwLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vwLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vwLine.heightAnchor.constraint(equalToConstant: 1),
            
            lblTitle.topAnchor.constraint(equalTo: vwLine.bottomAnchor, constant: heightFromPct(percent: 3)),
            lblTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthFromPct(percent: -2)),
            lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 2)),
            
            stckVwGuestOption.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: heightFromPct(percent: 3)),
            stckVwGuestOption.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 2)),
            stckVwGuestOption.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthFromPct(percent: -2)),
            stckVwGuestOption.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: heightFromPct(percent: -3))
//            lblDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: heightFromPct(percent: 2)),
//            lblDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthFromPct(percent: -2)),
//            lblDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 3)),
//            lblDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: heightFromPct(percent: -5))
        ])
    }
    
    
    @objc func swtchGuestOptionValueChanged(_ sender: UISwitch) {
        print("- in swtchGuestOptionValueChanged 🙋🏻")
//        delegate?.showSpinner()
    }
    
}
