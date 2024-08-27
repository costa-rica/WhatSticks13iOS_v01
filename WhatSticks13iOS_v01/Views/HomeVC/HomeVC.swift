//
//  ViewController.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 28/06/2024.
//

import UIKit

class HomeVC: TemplateVC, SelectAppModeVcDelegate {
    
    let vwHomeVcHeader = HomeVcHeaderView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    var didPresentAppModeOption = false
    let selectAppModeVc = SelectAppModeVC()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        URLStore.shared.apiBase = .prod
        URLStore.shared.apiBase = .dev
//        URLStore.shared.apiBase = .local
        
//        let userStore = UserStore.shared
//        let locationFetcher = LocationFetcher.shared
        LocationFetcher.shared.locationManager.requestAlwaysAuthorization()
//        let parentRequestStore = RequestStore.shared
//        UserStore.shared.requestStore = RequestStore.shared
        
//        let healthDataStore = HealthDataStore.shared
//        healthDataStore.requestStore = parentRequestStore
        
        self.setup_TopSafeBar()
        setupHomeVcHeader()


    }
    override func viewIsAppearing(_ animated: Bool) {
        print("- HomeVc viewIsAppearing")
        if !didPresentAppModeOption{
            // deactivate Tab Bar items while present
            tabBarController?.tabBar.isUserInteractionEnabled = false
            //            let selectAppModeVc = SelectAppModeVC()
            selectAppModeVc.delegate = self
            selectAppModeVc.modalPresentationStyle = .overCurrentContext
            selectAppModeVc.modalTransitionStyle = .crossDissolve
            self.present(selectAppModeVc, animated: true, completion: nil)
            self.didPresentAppModeOption = true
            
        }
    }
    
    //    override func view
    func setupHomeVcHeader(){
        vwHomeVcHeader.accessibilityIdentifier = "vwHomeVcHeader"
        vwHomeVcHeader.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(vwHomeVcHeader)
        NSLayoutConstraint.activate([
            vwHomeVcHeader.topAnchor.constraint(equalTo: vwTopSafeBar.bottomAnchor),
            vwHomeVcHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vwHomeVcHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    @objc func touchUpInsideGuest(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        self.showSpinner()
        tabBarController?.tabBar.isUserInteractionEnabled = true// re-activate the Tab Bar items
        UserStore.shared.isGuestMode = true
        self.setupNonNormalMode()
        UserStore.shared.connectDevice {
            self.removeSpinner()
            self.selectAppModeVc.dismiss(animated: true)
        }
    }
    
    @objc func touchUpInsideProduction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        self.showSpinner()
        tabBarController?.tabBar.isUserInteractionEnabled = true// re-activate the Tab Bar items
        self.setupNonNormalMode()
        UserStore.shared.connectDevice {
            self.selectAppModeVc.dismiss(animated: true)
            self.removeSpinner()
            
        }
    }
    
    @objc func touchUpInsideDevelopment(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        self.showSpinner()
        tabBarController?.tabBar.isUserInteractionEnabled = true// re-activate the Tab Bar items
        self.templateAlert(alertTitle: "⚠️", alertMessage: "Remember: development setting has no restrictions on collecting/sending locations") {
            UserStore.shared.connectDevice {
                UserStore.shared.isInDevMode = true
//                self.vwTopSafeBar.backgroundColor = UIColor(named:"ColorDevMode")
                self.setupNonNormalMode()
                self.selectAppModeVc.dismiss(animated: true)
                LocationFetcher.shared.updateInterval = 1
                self.removeSpinner()
            }
        }
    }
}

