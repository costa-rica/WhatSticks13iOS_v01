//
//  SentDataModalVC.swift
//  WhatSticks13iOS_v01
//
//  Created by Nick Rodriguez on 19/10/2024.
//

import UIKit


class SentDataModalVC: TemplateVC {
    
    let lblTitle=UILabel()
    let lblTooLittleDataMessage=UILabel()
    
    let vwMain=UIView()
    let stckVwMain = UIStackView()
    let stckVwData = UIStackView()
    let btnOk = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        setupView()
//        addTapGestureRecognizer()
    }
    init(){
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
//    init(dictAppleHealthDataForInfoVc:[String:String]){
//        super.init(nibName: nil, bundle: nil)
//        self.dictAppleHealthDataForInfoVc = dictAppleHealthDataForInfoVc
//    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        // Re-enable tab bar interaction when modal is dismissed
//        if let parentVC = presentingViewController as? ManageDataVC {
//            parentVC.tabBarController?.tabBar.isUserInteractionEnabled = true
//        }
//    }
    private func setupView(){
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        vwMain.accessibilityIdentifier="vwMain"
        vwMain.backgroundColor = UIColor.systemBackground
        vwMain.layer.cornerRadius = 12
        vwMain.layer.borderColor = UIColor(named: "ColorTableTabModalBack")?.cgColor
        vwMain.layer.borderWidth = 2
        vwMain.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vwMain)
        
//        stckVwMain
        stckVwMain.accessibilityIdentifier = "stckVwMain"
        stckVwMain.translatesAutoresizingMaskIntoConstraints=false

        stckVwMain.axis = .vertical
        stckVwMain.alignment = .fill
        stckVwMain.spacing = 10
        vwMain.addSubview(stckVwMain)
//        stckVwMain.backgroundColor = .gray
        
        lblTitle.text = "Data Summary"
        lblTitle.font = UIFont(name:"ArialRoundedMTBold", size: 35)
        lblTitle.translatesAutoresizingMaskIntoConstraints=false
        stckVwMain.addArrangedSubview(lblTitle)
        lblTitle.accessibilityIdentifier = "lblTitle"
        
        lblTooLittleDataMessage.text = ""
        lblTooLittleDataMessage.numberOfLines=0
        lblTooLittleDataMessage.translatesAutoresizingMaskIntoConstraints=false
        stckVwMain.addArrangedSubview(lblTooLittleDataMessage)
        lblTooLittleDataMessage.accessibilityIdentifier = "lblTooLittleDataMessage"
        
        stckVwData.axis = .vertical
        stckVwData.alignment = .fill
        stckVwData.spacing = 2
        stckVwMain.addArrangedSubview(stckVwData)
        
        btnOk.layer.borderColor = UIColor.systemBlue.cgColor
        btnOk.layer.borderWidth = 2
        btnOk.backgroundColor = .systemBlue
        btnOk.layer.cornerRadius = 10
        btnOk.translatesAutoresizingMaskIntoConstraints = false
        btnOk.accessibilityIdentifier="btnOk"
        btnOk.setTitle("Ok", for: .normal)
        stckVwMain.addArrangedSubview(btnOk)

        btnOk.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btnOk.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            vwMain.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vwMain.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            vwMain.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95),
//            vwMain.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            
            stckVwMain.topAnchor.constraint(equalTo: vwMain.topAnchor,constant: heightFromPct(percent: 2)),
            stckVwMain.trailingAnchor.constraint(equalTo: vwMain.trailingAnchor, constant: widthFromPct(percent: -3)),
            stckVwMain.leadingAnchor.constraint(equalTo: vwMain.leadingAnchor, constant: widthFromPct(percent: 3)),
            stckVwMain.bottomAnchor.constraint(equalTo: vwMain.bottomAnchor,constant: heightFromPct(percent: -3)),
        ])
    }
    
    func addAppleHealthDataDict (dictAppleHealthDataForInfoVc:[String:String]){
        print("- in addAppleHealthDataDict() 🧐")
        var counter = 0
        dictAppleHealthDataForInfoVc.forEach { (key, value) in
            print("in loop for \(key): \(value)")
            if value != "0"{
                counter += 1
            }
            let vwYourData = createHealthDataView(leftText: key, rightText: value)
            stckVwData.addArrangedSubview(vwYourData)

        }
        if counter < 2{
            lblTooLittleDataMessage.text = "Your Apple Health data contains \(counter) non-zero variable\(counter == 1 ? "" : "s"). This is not enough to build a dashboard. You can add weather variables by going Manage User and turning on Track Location."
        }
    }
    
    @objc func touchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        // Removes need for delegate methods
        // Re-enable tab bar interaction when modal is dismissed
        if let parentVC = self.presentingViewController{
            parentVC.tabBarController!.tabBar.isUserInteractionEnabled = true
        }
        for view in stckVwData.arrangedSubviews {
            stckVwData.removeArrangedSubview(view)
            view.removeFromSuperview() // Ensure the view is removed from the hierarchy
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}


extension SentDataModalVC {
    
    
    // Method to create a UIView (vwYourData) with two labels inside
    func createHealthDataView(leftText: String, rightText: String) -> UIView {
        // Create the container view
        let vwYourData = UIView()
        vwYourData.backgroundColor = UIColor(named: "ColorRow2")
        vwYourData.layer.cornerRadius = 10
        vwYourData.layer.masksToBounds = true
        vwYourData.translatesAutoresizingMaskIntoConstraints = false
        
        // Create the left label
        let leftLabel = UILabel()
        leftLabel.text = leftText
        leftLabel.translatesAutoresizingMaskIntoConstraints = false

        // Create the right label
        let rightLabel = UILabel()
        rightLabel.text = rightText
        rightLabel.textAlignment = .right
        rightLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add the labels to the container view
        vwYourData.addSubview(leftLabel)
        vwYourData.addSubview(rightLabel)

        // Set padding and constraints for labels within the view
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: vwYourData.leadingAnchor, constant: widthFromPct(percent: 2)),
            leftLabel.centerYAnchor.constraint(equalTo: vwYourData.centerYAnchor),
            rightLabel.trailingAnchor.constraint(equalTo: vwYourData.trailingAnchor, constant: widthFromPct(percent: -2)),
            rightLabel.centerYAnchor.constraint(equalTo: vwYourData.centerYAnchor),
            leftLabel.trailingAnchor.constraint(lessThanOrEqualTo: rightLabel.leadingAnchor, constant: widthFromPct(percent: -2)),
            leftLabel.topAnchor.constraint(equalTo: vwYourData.topAnchor, constant: heightFromPct(percent: 1)),
            leftLabel.bottomAnchor.constraint(equalTo: vwYourData.bottomAnchor, constant: heightFromPct(percent: -1)),
        ])

//        // Add height constraint to vwYourData for consistent size
//        vwYourData.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        return vwYourData
    }
}
