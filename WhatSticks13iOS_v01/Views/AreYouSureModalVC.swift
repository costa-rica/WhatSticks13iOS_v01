//
//  AreYouSureModalVC.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 26/08/2024.
//

import UIKit

class AreYouSureModalVC: TemplateVC {
    weak var delegate: AreYouSureModalVcDelegate?
//    let userStore = UserStore.shared
    
    var vwAreYouSureModalVC = UIView()
    var lblAreYouSureTitle = UILabel()
    var lblDetails:UILabel?
    
    let btnAreYouSure = UIButton()

    init(strForBtnTitle: String? = nil, strForLblDetails: String? = nil) {
        self.lblDetails = UILabel()
        self.lblDetails?.text = strForLblDetails
        self.btnAreYouSure.setTitle(strForBtnTitle, for: .normal)
//        self.optionalString = optionalString
        super.init(nibName: nil, bundle: nil)
    }
    init(){
        super.init(nibName: nil, bundle: nil)
        btnAreYouSure.setTitle("Delete", for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup_vwAreYouSureModalVC()
        setup_lblRegister()
        setup_btnRegister()
        addTapGestureRecognizer()
        
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        vwAreYouSureModalVC.layer.borderColor = borderColor(for: traitCollection)
    }
    

    func setup_vwAreYouSureModalVC() {
        // The semi-transparent background
        vwAreYouSureModalVC.backgroundColor = UIColor(named: "ColorTableTabModalBack")
        vwAreYouSureModalVC.layer.cornerRadius = 12
        vwAreYouSureModalVC.layer.borderColor = borderColor(for: traitCollection)
        vwAreYouSureModalVC.layer.borderWidth = 2
        vwAreYouSureModalVC.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vwAreYouSureModalVC )
        vwAreYouSureModalVC .centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        vwAreYouSureModalVC .centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        vwAreYouSureModalVC.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90).isActive=true
        vwAreYouSureModalVC.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive=true
    }

    func setup_lblRegister(){
        lblAreYouSureTitle.text = "Are you sure?"
        lblAreYouSureTitle.font = UIFont(name: "ArialRoundedMTBold", size: 35)
        lblAreYouSureTitle.numberOfLines = 0
        lblAreYouSureTitle.translatesAutoresizingMaskIntoConstraints=false
        vwAreYouSureModalVC.addSubview(lblAreYouSureTitle)
        lblAreYouSureTitle.accessibilityIdentifier="lblAreYouSureTitle"
        NSLayoutConstraint.activate([
            lblAreYouSureTitle.leadingAnchor.constraint(equalTo: vwAreYouSureModalVC.leadingAnchor, constant: smallPaddingSide),
            lblAreYouSureTitle.trailingAnchor.constraint(equalTo: vwAreYouSureModalVC.trailingAnchor, constant: -smallPaddingSide),
            lblAreYouSureTitle.topAnchor.constraint(equalTo: vwAreYouSureModalVC.topAnchor, constant: smallPaddingTop)
        ])
    }
    
    func setup_btnRegister(){
        btnAreYouSure.layer.borderColor = UIColor.systemRed.cgColor
        btnAreYouSure.layer.borderWidth = 2
        btnAreYouSure.backgroundColor = .systemRed
        btnAreYouSure.layer.cornerRadius = 10
        btnAreYouSure.translatesAutoresizingMaskIntoConstraints = false
        btnAreYouSure.accessibilityIdentifier="btnAreYouSure"
        vwAreYouSureModalVC.addSubview(btnAreYouSure)
        NSLayoutConstraint.activate([
//        btnAreYouSure.bottomAnchor.constraint(equalTo: vwAreYouSureModalVC.bottomAnchor, constant: -20),
        btnAreYouSure.centerYAnchor.constraint(equalTo: vwAreYouSureModalVC.centerYAnchor),
        btnAreYouSure.centerXAnchor.constraint(equalTo: vwAreYouSureModalVC.centerXAnchor),
        btnAreYouSure.widthAnchor.constraint(equalToConstant: widthFromPct(percent: 80)),
        ])
        
        btnAreYouSure.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btnAreYouSure.addTarget(self, action: #selector(touchUpInside(_:)), for: .touchUpInside)
    }

    
    @objc func touchUpInside(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)

            print("Delete account")
        showSpinner()
        UserStore.shared.callDeleteUser { result_dictString_or_error in
            switch result_dictString_or_error{
            case .success(let dictString):
                print("string dict: \(dictString)")
                self.delegate?.vwUserStatus.btnUsernameFilled.setTitle(UserStore.shared.user.username, for: .normal)
                self.delegate?.vwLocationDayWeather.swtchLocTrackReoccurring.isOn = false
                self.delegate?.vwLocationDayWeather.setLocationSwitchLabelText()
                UserStore.shared.deletedUser()
                OperationQueue.main.addOperation {
                    if !UserStore.shared.isOnline, UserStore.shared.user.email == nil {
                        self.delegate?.case_option_1_Offline_and_generic_name()
                        self.delegate?.templateAlert(alertTitle: "No connection", alertMessage: "", backScreen: false, dismissView: false)
                    }else if UserStore.shared.isOnline, UserStore.shared.user.email == nil{
                        print("UserVC offline connected!!! --")
                        self.delegate?.case_option_2_Online_and_generic_name()
                        self.delegate?.vwUserStatus.btnUsernameFilled.setTitle(UserStore.shared.user.username, for: .normal)
                    } else if UserStore.shared.isOnline, UserStore.shared.user.email != nil{
                        self.delegate?.case_option_3_Online_and_custom_email()
                        self.delegate?.vwUserStatus.btnUsernameFilled.setTitle(UserStore.shared.user.username, for: .normal)
                    } else if !UserStore.shared.isOnline, UserStore.shared.user.email != nil {
                        self.delegate?.templateAlert(alertTitle: "No connection", alertMessage: "", backScreen: false, dismissView: false)
                        self.delegate?.case_option_4_Offline_and_custom_email()
                    }
                    self.delegate?.removeSpinner()
                }
                
                
                
                self.templateAlert(alertTitle: "Successfully deleted user", alertMessage: "Your app's generic username has no data associated with it.",dismissView: true)
            case .failure(let error):
                print("error: \(error)")
                self.templateAlert(alertTitle: "Failed to delete", alertMessage: "")
            }
            self.removeSpinner()
        }

    }
    
    private func addTapGestureRecognizer() {
        // Create a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        print("add tap gester")
        // Add the gesture recognizer to the view
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
         let tapLocationInView = view.convert(tapLocation, to: vwAreYouSureModalVC)

         if let firstResponder = view.findFirstResponder() {
             // If the keyboard is present, dismiss it
             firstResponder.resignFirstResponder()
         } else if !vwAreYouSureModalVC.bounds.contains(tapLocationInView) {
             // If the keyboard is not present and the tap is outside of vwRegisterVC, dismiss the view controller
             dismiss(animated: true, completion: nil)
         }

    }
    
}


protocol AreYouSureModalVcDelegate: AnyObject {
    func removeSpinner()
    func showSpinner()
    func templateAlert(alertTitle:String,alertMessage: String,  backScreen: Bool, dismissView:Bool)
    func presentAlertController(_ alertController: UIAlertController)
    func touchDown(_ sender: UIButton)
    func presentNewView(_ uiViewController: UIViewController)
    var vwUserStatus: UserVcUserStatusView {get}
    var vwLocationDayWeather: UserVcLocationDayWeather {get}
    func case_option_1_Offline_and_generic_name()
    func case_option_2_Online_and_generic_name()
    func case_option_3_Online_and_custom_email()
    func case_option_4_Offline_and_custom_email()
}
