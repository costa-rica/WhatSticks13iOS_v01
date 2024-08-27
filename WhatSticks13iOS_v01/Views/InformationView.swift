//
//  InformationView.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 20/08/2024.
//

import UIKit


class InformationVC: TemplateVC {
    var vwInformation = InformationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        setupView()
        addTapGestureRecognizer()
    }
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView(){
        
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        vwInformation.accessibilityIdentifier="vwInformation"
        vwInformation.backgroundColor = UIColor.systemBackground
        vwInformation.layer.cornerRadius = 12
        vwInformation.layer.borderColor = UIColor(named: "ColorTableTabModalBack")?.cgColor
        vwInformation.layer.borderWidth = 2
        vwInformation.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vwInformation)
        vwInformation.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        vwInformation.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        vwInformation.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive=true
        
//        lblSelectAppModeVcTitle.accessibilityIdentifier="lblSelectAppModeVcTitle"
//        lblSelectAppModeVcTitle.text = "Select Mode:"
//        lblSelectAppModeVcTitle.font = UIFont(name: "ArialRoundedMTBold", size: 30)
//        lblSelectAppModeVcTitle.translatesAutoresizingMaskIntoConstraints=false
//        vwSelectAppModeBackground.addSubview(lblSelectAppModeVcTitle)
    }
    
    private func addTapGestureRecognizer() {
        // Create a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        // Add the gesture recognizer to the view
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
            dismiss(animated: true, completion: nil)
    }
}


class InformationView: UIView {
    let lblTitle = UILabel()
    let lblDescription = UILabel()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    init(frame: CGRect, title:String?, description:String?){
        super.init(frame: frame)
        self.lblTitle.text = title
        self.lblDescription.text = description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        self.backgroundColor = UIColor(named: "ColorTableTabModalBack")
        lblTitle.accessibilityIdentifier="lblTitle"
//        lblTitle.text = "No Data"
        lblTitle.translatesAutoresizingMaskIntoConstraints=false
        lblTitle.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        lblTitle.numberOfLines = 0
        self.addSubview(lblTitle)
        
        lblDescription.accessibilityIdentifier="lblDescription"
//        lblDescription.text = "If you have not already sent data to analyze, go to Manage Data"
        lblDescription.translatesAutoresizingMaskIntoConstraints=false
//        lblDescription.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        lblDescription.numberOfLines = 0
        self.addSubview(lblDescription)
        
        NSLayoutConstraint.activate([
            lblTitle.topAnchor.constraint(equalTo: self.topAnchor, constant: heightFromPct(percent: 3)),
            lblTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 2)),
//            lblTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
            lblDescription.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: heightFromPct(percent: 1)),
            lblDescription.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 2)),
            lblDescription.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthFromPct(percent: -2)),
            
            lblDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: heightFromPct(percent: -5))
        ])
    }
}
