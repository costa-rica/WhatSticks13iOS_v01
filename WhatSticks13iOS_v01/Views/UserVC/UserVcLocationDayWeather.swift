////
//  NEW_userVcLocationDayWeather.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 18/08/2024.
//

import UIKit

class UserVcLocationDayWeather: UIView {
    
    weak var delegate: UserVcLocationDayWeatherDelegate?// instantiated in UserVC.viewDidLoad()
    var showLine:Bool!
    let vwLocationDayWeatherLine = UIView()
    var viewTopAnchor:NSLayoutAnchor<NSLayoutYAxisAnchor>!
    
    let lblLocationDayWeatherTitle = UILabel()
    let lblLocationDayWeatherDetails = UILabel()

    let stckVwLocTrackReoccurring = UIStackView()
    let lblLocTrackReoccurringSwitch=UILabel()
    let swtchLocTrackReoccurring = UISwitch()
    
    let lblDeviceLocationStatus = UILabel()
    
    init(frame: CGRect, showLine: Bool) {
        self.showLine = showLine
        super.init(frame: frame)
        setupLocationDayWeatherView()
        setLocationSwitchLabelText()
        setupDeviceLocationStatus()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* UI Methods */
    func setupLocationDayWeatherView(){
        if showLine{
            setupLineOption()
        }
        lblLocationDayWeatherTitle.accessibilityIdentifier="lblLocationDayWeatherTitle"
        lblLocationDayWeatherTitle.text = "Location Weather Tracking"
        lblLocationDayWeatherTitle.translatesAutoresizingMaskIntoConstraints=false
        lblLocationDayWeatherTitle.font = UIFont(name: "ArialRoundedMTBold", size: 25)
        lblLocationDayWeatherTitle.numberOfLines = 0
        self.addSubview(lblLocationDayWeatherTitle)
        
        lblLocationDayWeatherDetails.accessibilityIdentifier="lblLocationDayWeatherDetails"
        lblLocationDayWeatherDetails.text = "Allow What Sticks (WS) to collect your location to provide weather and timezone calculations for impacts on sleep and exercise. \n\nTurning this on will allow WS to collect your location daily."
        lblLocationDayWeatherDetails.translatesAutoresizingMaskIntoConstraints=false
        lblLocationDayWeatherDetails.numberOfLines = 0
        self.addSubview(lblLocationDayWeatherDetails)
        
        stckVwLocTrackReoccurring.accessibilityIdentifier="stckVwLocationDayWeather"
        stckVwLocTrackReoccurring.translatesAutoresizingMaskIntoConstraints=false
        stckVwLocTrackReoccurring.spacing = 5
        stckVwLocTrackReoccurring.axis = .horizontal
        self.addSubview(stckVwLocTrackReoccurring)
        
        lblLocTrackReoccurringSwitch.accessibilityIdentifier="lblLocationDayWeatherSwitch"
        lblLocTrackReoccurringSwitch.translatesAutoresizingMaskIntoConstraints=false
        stckVwLocTrackReoccurring.addArrangedSubview(lblLocTrackReoccurringSwitch)
        
        swtchLocTrackReoccurring.accessibilityIdentifier = "swtchLocationDayWeather"
        swtchLocTrackReoccurring.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        
        stckVwLocTrackReoccurring.addArrangedSubview(swtchLocTrackReoccurring)
        setLocationSwitchBasedOnUserPermissions()
        setLocationSwitchLabelText()
        
        if showLine{
            viewTopAnchor = vwLocationDayWeatherLine.bottomAnchor
        } else {
            viewTopAnchor = self.topAnchor
        }
        
        NSLayoutConstraint.activate([
            lblLocationDayWeatherTitle.topAnchor.constraint(equalTo: viewTopAnchor, constant: heightFromPct(percent: 3)),
            lblLocationDayWeatherTitle.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lblLocationDayWeatherTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 2)),
            
            lblLocationDayWeatherDetails.topAnchor.constraint(equalTo: lblLocationDayWeatherTitle.bottomAnchor, constant: heightFromPct(percent: 2)),
            lblLocationDayWeatherDetails.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lblLocationDayWeatherDetails.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 3)),
            
            stckVwLocTrackReoccurring.topAnchor.constraint(equalTo: lblLocationDayWeatherDetails.bottomAnchor, constant: heightFromPct(percent: 2)),
            stckVwLocTrackReoccurring.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: widthFromPct(percent: -2)),
//            stckVwLocTrackReoccurring.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: heightFromPct(percent: -2))
        ])
    }
    func setupLineOption(){
        vwLocationDayWeatherLine.accessibilityIdentifier = "vwLocationDayWeatherLine"
        vwLocationDayWeatherLine.translatesAutoresizingMaskIntoConstraints = false
        vwLocationDayWeatherLine.backgroundColor = UIColor(named: "lineColor")
        self.addSubview(vwLocationDayWeatherLine)
        NSLayoutConstraint.activate([
            vwLocationDayWeatherLine.topAnchor.constraint(equalTo: self.topAnchor),
            vwLocationDayWeatherLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            vwLocationDayWeatherLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            vwLocationDayWeatherLine.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    // Consider deleting or replacing
    func setupDeviceLocationStatus(){
        lblDeviceLocationStatus.accessibilityIdentifier="lblDeviceLocationStatus"
        lblDeviceLocationStatus.text = "Device Authorization: \(LocationFetcher.shared.locationManager.authorizationStatus.localizedDescription)"
        lblDeviceLocationStatus.translatesAutoresizingMaskIntoConstraints=false
        lblDeviceLocationStatus.numberOfLines = 0
        self.addSubview(lblDeviceLocationStatus)
        
        
        NSLayoutConstraint.activate([
            lblDeviceLocationStatus.topAnchor.constraint(equalTo: stckVwLocTrackReoccurring.bottomAnchor, constant: heightFromPct(percent: 2)),
            lblDeviceLocationStatus.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            lblDeviceLocationStatus.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            lblDeviceLocationStatus.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant:heightFromPct(percent: -2)),
        ])
        
    }
    
    /* Operational Methods */
    func setLocationSwitchBasedOnUserPermissions(){
        if UserStore.shared.isGuestMode{
            swtchLocTrackReoccurring.isOn = false
        }
        else if UserStore.shared.user.location_permission_ws == true {
            swtchLocTrackReoccurring.isOn = true
        } else {
            swtchLocTrackReoccurring.isOn = false
        }
    }
    func setLocationSwitchLabelText(){
        if swtchLocTrackReoccurring.isOn{
            lblLocTrackReoccurringSwitch.text = "Track Location (Once Daily): "
        } else {
            lblLocTrackReoccurringSwitch.text = "Track Location (off): "
        }
    }
    private func switchErrorSwitchBack(){
        if self.swtchLocTrackReoccurring.isOn==true{
            self.swtchLocTrackReoccurring.isOn=false
        } else {
            self.swtchLocTrackReoccurring.isOn=true
        }
        self.setLocationSwitchLabelText()
    }
    
    
    
    
    
    /* Obj-C Methods */
    @objc func switchValueChanged(_ sender: UISwitch) {
        print("- in switchValueChanged")
        delegate?.showSpinner()
        if UserStore.shared.isGuestMode{
            let informationVc = InformationVC()
            informationVc.vwInformation.lblTitle.text = "Guest Mode"
            informationVc.vwInformation.lblDescription.text = "While in guest mode user's cannot send data. \n\n If you would like to analyze your data please close the app and restart in Normal mode."
            informationVc.modalPresentationStyle = .overCurrentContext
            informationVc.modalTransitionStyle = .crossDissolve
            self.delegate?.presentNewView(informationVc)
            self.switchErrorSwitchBack()
            delegate?.removeSpinner()
        }// CLOSE: if UserStore.shared.isGuestMode{
        
        else if sender.isOn{
            UserStore.shared.user.location_permission_ws = true
            LocationFetcher.shared.fetchLocationOnce { clLocation in
                if let unwp_clLocation = clLocation{
                    UserStore.shared.user.location_permission_device = true // This is for good measure, because if ever a CLLocation object is recieved that means the device has granted WS permission.
                    LocationFetcher.shared.appendLocationToArryHistUserLocation(lastLocation: unwp_clLocation)
                    UserStore.shared.callUpdateUserLocationDetails(endPoint: .update_user_location_details, sendUserLocations: true) { resultStringOrError in
                        switch resultStringOrError {
                        case .success(_):
                            self.delegate?.templateAlert(alertTitle: "Success!",alertMessage: nil, completion: {
                                self.delegate?.removeSpinner()
                            })
                            
                        default:
                            self.delegate?.templateAlert(alertTitle: "",alertMessage: "Unable to reach What Sticks servers to analyze this update. \n\n Try again or contact what-sticks.com@gmail.com.", completion: {
                                self.delegate?.removeSpinner()
                                self.switchErrorSwitchBack()
                            })
                            
                        }
                    }// CLOSE: self.userStore.callUpdateUserLocationDetails(
                }// CLOSE: if let unwp_clLocation = clLocation {
                else {// This is the case when the User Location has already been sent
                    // This else is somewhat unncessary - API can receive as many locations updates, but ws_utilities screens for existing UserLocationDay, therefore, it won't add an additional loc even if iOS sends one.
                    UserStore.shared.callUpdateUserLocationDetails(endPoint: .update_user_location_details, sendUserLocations: false) { resultStringOrError in
                        switch resultStringOrError {
                        case .success(_):
                            self.delegate?.templateAlert(alertTitle: "Success!",alertMessage: nil, completion: {
                                self.delegate?.removeSpinner()
                            })
                            
                        default:
                            self.delegate?.templateAlert(alertTitle: "",alertMessage: "Unable to reach What Sticks servers to analyze this update. \n\n Try again or contact what-sticks.com@gmail.com.", completion: {
                                self.delegate?.removeSpinner()
                                self.switchErrorSwitchBack()
                            })
                            
                        }// CLOSE: UserStore.shared.callUpdateUserLocationDetails(endPoint: .update_user_location_details, sendUserLocations: false)
                    }// CLOSE: self.userStore.callUpdateUserLocationDetails(
                    
//                    self.delegate?.templateAlert(alertTitle: "",alertMessage: "Unable to update user location. \n\n This could be the resulte of already having sent your location once in the past 24hrs. \n\n If this is not the case try again or contact what-sticks.com@gmail.com.", completion: {
//                        self.delegate?.removeSpinner()
//                        self.switchErrorSwitchBack()
//                    })
                }// CLOSE: if let unwp_clLocation = clLocation {} else
            }// CLOSE: locationFetcher.fetchLocationOnce { clLocation in
            LocationFetcher.shared.locationManager.startMonitoringSignificantLocationChanges()
        }
        else {
            UserStore.shared.user.location_permission_ws = false
            UserStore.shared.callUpdateUserLocationDetails(endPoint: .update_user_location_details, sendUserLocations: false) { resultStringOrError in
                switch resultStringOrError{
                case .success(_):
                    self.setLocationSwitchLabelText()
                    LocationFetcher.shared.locationManager.stopMonitoringSignificantLocationChanges()
                    self.delegate?.removeSpinner()
                    
                default:
                    self.delegate?.templateAlert(alertTitle: "Failure", alertMessage: "Probably a problem connecting to What Sticks Servers. Try again later or contact what-sticks.com@gmail.com", completion: {
                        self.switchErrorSwitchBack()
                        self.delegate?.removeSpinner()
                    })
                }// CLOSE: switch resultStringOrError{
            }// CLOSE: self.userStore.callUpdateUserLocationDetails(
        }// CLOSE: if sender.isOn{} else {
    }// CLOSE: @objc func switchValueChanged(
    
}

protocol UserVcLocationDayWeatherDelegate: AnyObject {
    func removeSpinner()
    func showSpinner()
    func templateAlert(alertTitle:String?,alertMessage: String?, completion:(()->Void)?)
    func presentNewView(_ uiViewController: UIViewController)
}


