//
//  UserVcOtherSettings.swift
//  WhatSticks13iOS_v01
//
//  Created by Nick Rodriguez on 05/10/2024.
//

import UIKit

class UserVcOtherSettings: UIView {
    
    weak var delegate: UserVcOtherSettingsDelegate?
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
                
        stckVwGuestOption.accessibilityIdentifier="stckVwGuestOption"
        stckVwGuestOption.translatesAutoresizingMaskIntoConstraints=false
        stckVwGuestOption.spacing = 5
        stckVwGuestOption.axis = .horizontal
        self.addSubview(stckVwGuestOption)
        
        lblGuestOption.accessibilityIdentifier="lblGuestOption"
        lblGuestOption.translatesAutoresizingMaskIntoConstraints=false
        lblGuestOption.text = "Show guest option on launch:"
        stckVwGuestOption.addArrangedSubview(lblGuestOption)
        
        stckVwGuestOption.addArrangedSubview(swtchGuestOption)
        swtchGuestOption.accessibilityIdentifier = "swtchGuestOption"
        swtchGuestOption.addTarget(self, action: #selector(swtchGuestOptionValueChanged(_:)), for: .valueChanged)
        
        
        // Retrieve the value from UserDefaults
        if let showGuestModeOption = UserDefaults.standard.value(forKey: "showGuestModeOption") as? Bool {
            // If the value exists, set the switch accordingly
            swtchGuestOption.isOn = showGuestModeOption
        } else {
            // If the value doesn't exist, set the switch to on and save this initial state
            swtchGuestOption.isOn = true
            UserDefaults.standard.set(true, forKey: "showGuestModeOption")
        }
        
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
        ])
    }
    
    
    @objc func swtchGuestOptionValueChanged(_ sender: UISwitch) {
        print("- in swtchGuestOptionValueChanged 🙋🏻")
        if UserStore.shared.isGuestMode{
            print("- UserVCOtherSEttings > swtchGuestOptionValueChanged > if UserStore.shared.isGuestMode{")
            self.delegate?.templateAlert(alertTitle: "Must be in Normal Mode to toggle this off", alertMessage: "⚠️", completion: {
                self.swtchGuestOption.isOn=true
            })
        } else {
            UserDefaults.standard.set(sender.isOn, forKey: "showGuestModeOption")
        }
    }
    
}

protocol UserVcOtherSettingsDelegate: AnyObject {
    func templateAlert(alertTitle:String?,alertMessage: String?, completion:(()->Void)?)

}
