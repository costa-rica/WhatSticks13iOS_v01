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
        print("* HomeVC viewDidLoad*")
        super.viewDidLoad()
//        URLStore.shared.apiBase = .prod
        URLStore.shared.apiBase = .dev
//        URLStore.shared.apiBase = .local
        
        self.setup_TopSafeBar()
        setupHomeVcHeader()


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
    
    func presentAppModeOption(){
        // deactivate Tab Bar items while present
        tabBarController?.tabBar.isUserInteractionEnabled = false
        selectAppModeVc.delegate = self
        selectAppModeVc.modalPresentationStyle = .overCurrentContext
        selectAppModeVc.modalTransitionStyle = .crossDissolve
        self.present(selectAppModeVc, animated: true, completion: nil)
        self.didPresentAppModeOption = true
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
            DispatchQueue.main.async {
                self.removeSpinner()
                self.selectAppModeVc.dismiss(animated: true)
            }
        }
    }
    
    @objc func touchUpInsideProduction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        LocationFetcher.shared.locationManager.requestAlwaysAuthorization()
        self.showSpinner()
        tabBarController?.tabBar.isUserInteractionEnabled = true// re-activate the Tab Bar items
        self.setupNonNormalMode()
        UserStore.shared.connectDevice {
            DispatchQueue.main.async {
                self.selectAppModeVc.dismiss(animated: true)
                self.removeSpinner()
            }
        }
    }
    
    @objc func touchUpInsideDevelopment(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        LocationFetcher.shared.locationManager.requestAlwaysAuthorization()
        self.showSpinner()
        tabBarController?.tabBar.isUserInteractionEnabled = true// re-activate the Tab Bar items
        self.templateAlert(alertTitle: "⚠️", alertMessage: "Remember: development setting has no restrictions on collecting/sending locations") {
            UserStore.shared.connectDevice {
                UserStore.shared.isInDevMode = true
//                self.vwTopSafeBar.backgroundColor = UIColor(named:"ColorDevMode")
                self.setupNonNormalMode()
                DispatchQueue.main.async {
                    self.selectAppModeVc.dismiss(animated: true)
                    LocationFetcher.shared.updateInterval = 1
                    self.removeSpinner()
                }
            }
        }
    }
}

extension HomeVC {
    override func viewIsAppearing(_ animated: Bool) {
        print("- HomeVc viewIsAppearing 🏡")
        if !didPresentAppModeOption {
            didPresentAppModeOption = true
            guard let showGuestModeOption = UserDefaults.standard.value(forKey: "showGuestModeOption") as? Bool else {
                presentAppModeOption()
                return
            }
            
            if showGuestModeOption {
                presentAppModeOption()
            } else {
                handleNormalMode()
            }
        }
    }

    private func handleNormalMode() {
        print("---> Normal Mode with no SelectModeModal presented")
        self.showSpinner()
        tabBarController?.tabBar.isUserInteractionEnabled = true
        self.setupNonNormalMode()
        UserStore.shared.connectDevice {
            DispatchQueue.main.async {
                self.removeSpinner()
            }
        }
    }
}

// OBE
extension HomeVC {
    
    
    
//    override func viewIsAppearing(_ animated: Bool) {
//        print("- HomeVc viewIsAppearing 🏡")
//        if let showGuestModeOption = UserDefaults.standard.value(forKey: "showGuestModeOption") as? Bool {
//            print("--> found UserDefaults.standard.value(forKey: showGuestModeOption)")
//            if showGuestModeOption {
//                presentAppModeOption()
//            } else {
//                print("---> Normal Mode with no SelectModeModal presented #2")
//                self.showSpinner()
//                tabBarController?.tabBar.isUserInteractionEnabled = true// re-activate the Tab Bar items
//                self.setupNonNormalMode()
//                UserStore.shared.connectDevice {
//                    DispatchQueue.main.async {
//    //                    self.selectAppModeVc.dismiss(animated: true)
//                        self.removeSpinner()
//                    }
//                }
//            }
//        } else if !didPresentAppModeOption {
//            print("--> else if !didPresentAppModeOption {")
//            presentAppModeOption()
//        } else {
//            print("---> Normal Mode with no SelectModeModal presented")
//            self.showSpinner()
//            tabBarController?.tabBar.isUserInteractionEnabled = true// re-activate the Tab Bar items
//            self.setupNonNormalMode()
//            UserStore.shared.connectDevice {
//                DispatchQueue.main.async {
////                    self.selectAppModeVc.dismiss(animated: true)
//                    self.removeSpinner()
//                }
//            }
//        }
//    }
}
