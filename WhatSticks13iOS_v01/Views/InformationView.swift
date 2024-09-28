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
    
    var btnRefreshDashboard = UIButton()
    weak var delegate: InformationViewDelegate?
    
    
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
            
//            lblDescription.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: heightFromPct(percent: -5))
            lblDescription.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: heightFromPct(percent: -5))
        ])
    }
    
    func setup_btnRefreshDashboard(){
//        if let btnRefreshDashboard = btnRefreshDashboard {
        btnRefreshDashboard.setTitle("Refresh Dashboard", for: .normal)
        btnRefreshDashboard.layer.borderColor = UIColor.systemBlue.cgColor
        btnRefreshDashboard.layer.borderWidth = 2
        btnRefreshDashboard.backgroundColor = .blue
        btnRefreshDashboard.layer.cornerRadius = 10
        btnRefreshDashboard.translatesAutoresizingMaskIntoConstraints = false
        btnRefreshDashboard.accessibilityIdentifier="btnRefreshDashboard"
//        view.addSubview(btnRefreshDashboard)
        self.addSubview(btnRefreshDashboard)
        NSLayoutConstraint.activate([
            btnRefreshDashboard.topAnchor.constraint(equalTo: lblDescription.bottomAnchor, constant: heightFromPct(percent: 2)),
            btnRefreshDashboard.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            btnRefreshDashboard.widthAnchor.constraint(equalToConstant: widthFromPct(percent: 80)),
            btnRefreshDashboard.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: heightFromPct(percent: -5))
        ])
        
        btnRefreshDashboard.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btnRefreshDashboard.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
//        }
    }
    @objc func touchDown(_ sender: UIButton) {
//        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
//            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
//        }, completion: nil)
        delegate?.touchDown(sender)
    }
    @objc func touchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        
        print("🚀 referesh dashboard 🚀 🚀 🚀")
        UserStore.shared.callSendDashboardTableObjects { resultJsonDict in
            switch resultJsonDict{
            case .success(_):
                print("- we recieved data source and dashboard data")
            case let .failure(userStoreError):
                print("- failed to get data from send_both_data_source_and_dashboard_objects endpoint, error is: \(userStoreError.localizedDescription)")
            }
        }
    }

}

protocol InformationViewDelegate: AnyObject {
    func touchDown(_ sender: UIButton)
    func update_arryDashboardTableObjects()
}


