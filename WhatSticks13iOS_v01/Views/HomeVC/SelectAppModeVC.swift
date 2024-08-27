//
//  SelectAppModeVC.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 21/08/2024.
//

import UIKit

class SelectAppModeVC: TemplateVC{
    weak var delegate: SelectAppModeVcDelegate?
    var vwSelectAppModeBackground = UIView()
    var lblSelectAppModeVcTitle = UILabel()
    var btnGuest = UIButton()
    var btnProduction = UIButton()
    var btnDevelopment = UIButton()
    
    init(){
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        setupView()
//        addTapGestureRecognizer()
    }

    private func setupView(){
        
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        vwSelectAppModeBackground.accessibilityIdentifier="vwSelectAppModeBackground"
        vwSelectAppModeBackground.backgroundColor = UIColor.systemBackground
        vwSelectAppModeBackground.layer.cornerRadius = 12
        vwSelectAppModeBackground.layer.borderColor = UIColor(named: "ColorTableTabModalBack")?.cgColor
        vwSelectAppModeBackground.layer.borderWidth = 2
        vwSelectAppModeBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vwSelectAppModeBackground)
        vwSelectAppModeBackground.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        vwSelectAppModeBackground.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        vwSelectAppModeBackground.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.95).isActive=true
        
        lblSelectAppModeVcTitle.accessibilityIdentifier="lblSelectAppModeVcTitle"
        lblSelectAppModeVcTitle.text = "Select Mode:"
        lblSelectAppModeVcTitle.font = UIFont(name: "ArialRoundedMTBold", size: 30)
        lblSelectAppModeVcTitle.translatesAutoresizingMaskIntoConstraints=false
        vwSelectAppModeBackground.addSubview(lblSelectAppModeVcTitle)

        
        btnGuest.accessibilityIdentifier="btnGuest"
        btnGuest.backgroundColor = UIColor(named: "ColorDevMode")
        btnGuest.setTitleColor(UIColor(named: "lineColor"), for: .normal)
        btnGuest.layer.borderWidth = 1
        btnGuest.layer.cornerRadius = 10
        btnGuest.translatesAutoresizingMaskIntoConstraints = false
        btnGuest.titleLabel?.numberOfLines = 0
        btnGuest.titleLabel?.lineBreakMode = .byWordWrapping
        btnGuest.titleLabel?.textAlignment = .center  // Center the text
        let firstLineAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "ArialRoundedMTBold", size: 24)!,
        ]
        let firstLineText = NSAttributedString(string: "Guest Mode\n", attributes: firstLineAttributes)
        let secondLineAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14),
        ]
        let secondLineText = NSAttributedString(string: "(populated with sample data)", attributes: secondLineAttributes)
        let combinedText = NSMutableAttributedString()
        combinedText.append(firstLineText)
        combinedText.append(secondLineText)
        btnGuest.setAttributedTitle(combinedText, for: .normal)
        btnGuest.addTarget(self, action: #selector(touchDown), for: .touchDown)
        btnGuest.addTarget(self, action: #selector(touchUpInsideGuest), for: .touchUpInside)

       
        btnProduction.accessibilityIdentifier="btnProduction"
        btnProduction.backgroundColor = .blue
        btnProduction.setTitleColor(UIColor(named: "lineColor"), for: .normal)
        btnProduction.layer.borderWidth = 1
        btnProduction.layer.cornerRadius = 10
        btnProduction.translatesAutoresizingMaskIntoConstraints = false
        btnProduction.setTitle("Normal Mode", for: .normal)
        btnProduction.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 24)
        btnProduction.addTarget(self, action: #selector(touchDown), for: .touchDown)
        btnProduction.addTarget(self, action: #selector(touchUpInsideProduction), for: .touchUpInside)
        
        btnDevelopment.accessibilityIdentifier="btnDevelopment"
        btnDevelopment.backgroundColor = .gray
        btnDevelopment.setTitleColor(UIColor(named: "lineColor"), for: .normal)
        btnDevelopment.layer.borderWidth = 1
        btnDevelopment.layer.cornerRadius = 10
        btnDevelopment.translatesAutoresizingMaskIntoConstraints = false
        btnDevelopment.setTitle("Development", for: .normal)
        btnDevelopment.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 24)
        btnDevelopment.addTarget(self, action: #selector(touchDown), for: .touchDown)
        btnDevelopment.addTarget(self, action: #selector(touchUpInsideDevelopment), for: .touchUpInside)
        
        vwSelectAppModeBackground.addSubview(btnGuest)
        vwSelectAppModeBackground.addSubview(btnProduction)
        if URLStore.shared.apiBase != .prod {
            vwSelectAppModeBackground.addSubview(btnDevelopment)
            NSLayoutConstraint.activate([
                lblSelectAppModeVcTitle.topAnchor.constraint(equalTo: vwSelectAppModeBackground.topAnchor,constant: heightFromPct(percent: 3)),
                lblSelectAppModeVcTitle.leadingAnchor.constraint(equalTo: vwSelectAppModeBackground.leadingAnchor, constant: widthFromPct(percent: 1)),
                
                btnGuest.topAnchor.constraint(equalTo: lblSelectAppModeVcTitle.bottomAnchor, constant: heightFromPct(percent: 3)),
                btnGuest.leadingAnchor.constraint(equalTo: vwSelectAppModeBackground.leadingAnchor, constant: widthFromPct(percent: 3)),
                btnGuest.trailingAnchor.constraint(equalTo: vwSelectAppModeBackground.trailingAnchor, constant: widthFromPct(percent: -3)),
//                btnGuest.heightAnchor.constraint(equalToConstant: 70),
                
                btnProduction.topAnchor.constraint(equalTo: btnGuest.bottomAnchor, constant: heightFromPct(percent: 3)),
                btnProduction.leadingAnchor.constraint(equalTo: vwSelectAppModeBackground.leadingAnchor, constant: widthFromPct(percent: 3)),
                btnProduction.trailingAnchor.constraint(equalTo: vwSelectAppModeBackground.trailingAnchor, constant: widthFromPct(percent: -3)),

                btnDevelopment.topAnchor.constraint(equalTo: btnProduction.bottomAnchor, constant: heightFromPct(percent: 3)),
                btnDevelopment.leadingAnchor.constraint(equalTo: vwSelectAppModeBackground.leadingAnchor, constant: widthFromPct(percent: 3)),
                btnDevelopment.trailingAnchor.constraint(equalTo: vwSelectAppModeBackground.trailingAnchor, constant: widthFromPct(percent: -3)),
                btnDevelopment.bottomAnchor.constraint(equalTo: vwSelectAppModeBackground.bottomAnchor, constant: heightFromPct(percent: -5)),
                
            ])
        } else {
            NSLayoutConstraint.activate([
                lblSelectAppModeVcTitle.topAnchor.constraint(equalTo: vwSelectAppModeBackground.topAnchor,constant: heightFromPct(percent: 3)),
                lblSelectAppModeVcTitle.leadingAnchor.constraint(equalTo: vwSelectAppModeBackground.leadingAnchor, constant: widthFromPct(percent: 1)),
                
                btnGuest.topAnchor.constraint(equalTo: lblSelectAppModeVcTitle.bottomAnchor, constant: heightFromPct(percent: 3)),
                btnGuest.leadingAnchor.constraint(equalTo: vwSelectAppModeBackground.leadingAnchor, constant: widthFromPct(percent: 3)),
                btnGuest.trailingAnchor.constraint(equalTo: vwSelectAppModeBackground.trailingAnchor, constant: widthFromPct(percent: -3)),
                
                btnProduction.topAnchor.constraint(equalTo: btnGuest.bottomAnchor, constant: heightFromPct(percent: 3)),
                btnProduction.leadingAnchor.constraint(equalTo: vwSelectAppModeBackground.leadingAnchor, constant: widthFromPct(percent: 3)),
                btnProduction.trailingAnchor.constraint(equalTo: vwSelectAppModeBackground.trailingAnchor, constant: widthFromPct(percent: -3)),
                
                btnProduction.bottomAnchor.constraint(equalTo: vwSelectAppModeBackground.bottomAnchor, constant: heightFromPct(percent: -5)),
                
            ])
        }
    }
    
//    private func addTapGestureRecognizer() {
//        // Create a tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
//        // Add the gesture recognizer to the view
//        view.addGestureRecognizer(tapGesture)
//    }
//    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
//            dismiss(animated: true, completion: nil)
//    }
    
    @objc private func touchUpInsideGuest() {
        delegate?.touchUpInsideGuest(btnGuest)
    }
    @objc private func touchUpInsideProduction() {
        delegate?.touchUpInsideProduction(btnProduction)
    }
    @objc private func touchUpInsideDevelopment() {
        delegate?.touchUpInsideDevelopment(btnDevelopment)
    }
}


protocol SelectAppModeVcDelegate: AnyObject {
    func touchUpInsideGuest(_ sender: UIButton)
    func touchUpInsideProduction(_ sender: UIButton)
    func touchUpInsideDevelopment(_ sender: UIButton)

}
