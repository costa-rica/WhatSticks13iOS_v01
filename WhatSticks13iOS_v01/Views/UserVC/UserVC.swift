//
//  UserVC.swift
//  TabBar07
//
//  Created by Nick Rodriguez on 28/06/2024.
//

import UIKit

//class UserVC: TemplateVC, UserVcLocationDayWeatherDelegate, UserVcOfflineDelegate, UserVcRegisterButtonDelegate, UserVcDeleteDelegate, RegisterVcDelegate, AreYouSureModalVcDelegate, UserStatusDevelopmentViewDelegate{

class UserVC: TemplateVC, UserVcLocationDayWeatherDelegate,  UserVcRegisterButtonDelegate, UserVcDeleteDelegate,   UserStatusDevelopmentViewDelegate{
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView()
        
    let vwFindAppleHealthPermissions = UserVcFindAppleHealthPermissionsView()

    let vwLocationDayWeather = UserVcLocationDayWeather(frame: CGRect.zero, showLine: true)

    let vwOffline = UserVcOffline(frame: CGRect.zero, showLine: true)
//    var constraints_Offline_NoEmail = [NSLayoutConstraint]()

    let vwUserStatus = UserVcUserStatusView(frame: CGRect.zero)
//    var constraints_Online_NoEmail = [NSLayoutConstraint]()
    
    let vwRegisterButton = UserVcRegisterButton()
    
    
    let vwUserDeleteAccount = UserVcDelete(frame: CGRect.zero, showLine: true)
//    var constraints_Online_YesEmail = [NSLayoutConstraint]()
    
//    var constraints_Offline_YesEmail = [NSLayoutConstraint]()
    
    let vwOtherSettings = UserVcOtherSettings()
    
    /* Dev view dependent properties */
    let vwUserStatusDeveloperView = UserStatusDevelopmentView(frame: CGRect.zero, showLine: true)
    var constraintsForBottomOfUserVcContentView = [NSLayoutConstraint]()
    var bottomAnchorForUserVcContentBottomAnchor:NSLayoutAnchor<NSLayoutYAxisAnchor>!


    override func viewDidLoad() {
        print("- in UserVC viewDidLoad 🙋🏻-")
        super.viewDidLoad()
//        vwOffline.delegate = self
        vwRegisterButton.delegate = self
        vwLocationDayWeather.delegate = self
        vwUserDeleteAccount.delegate = self

        self.setup_TopSafeBar()
        setupScrollView()
        setupContentView()
        setupStackView()
//        setup_old_viewDidLoad_end()
    }
    

    // Method to add a new view to the stackView
    func addView(_ newView: UIView) {
        var viewsCount = stackView.subviews.count
        stackView.insertArrangedSubview(newView, at: viewsCount)
//        print("stackView has \(viewsCount) 👀")
//        if let unwp_offline = newView as? UserVcOffline{
//            print("We got an offline view! 🎉")
//            stackView.insertArrangedSubview(unwp_offline, at: 1)
//        } else {
//            //        stackView.addArrangedSubview(newView)
//            stackView.insertArrangedSubview(newView, at: viewsCount)
//        }
    }
    
    // Method to remove a view from the stackView
    func removeView(_ viewToRemove: UIView) {
        stackView.removeArrangedSubview(viewToRemove)
        viewToRemove.removeFromSuperview()
    }
    
    
}
// New ManageUserVcViews
extension UserVC {
    func manageUserVcOptionalViews(){
        print("stackView subviews: \(self.stackView.subviews.count)")
        // vwFindAppleHealthPermissions
        addView(vwFindAppleHealthPermissions)
        
        // vwLocationDayWeather
        if UserStore.shared.isOnline{
            addView(vwLocationDayWeather)
        } else {
            removeView(vwLocationDayWeather)
        }
        
        // vwOffline
        if !UserStore.shared.isOnline{
            addView(vwOffline)
        } else {
            removeView(vwOffline)
        }
        
        // vwUserStatus
        addView(vwUserStatus)
        
        // vwRegisterButton
        if UserStore.shared.isOnline && (UserStore.shared.user.email == nil) {
            addView(vwRegisterButton)
        } else {
            removeView(vwRegisterButton)
        }
        
        // vwUserDeleteAccount
        if UserStore.shared.isOnline && (UserStore.shared.user.email != nil)  {
            addView(vwUserDeleteAccount)
        } else {
            removeView(vwUserDeleteAccount)
        }
        
        // vwOtherSettings
        addView(vwOtherSettings)
        
        // vwUserStatusDeveloperView
        if UserStore.shared.isInDevMode {
            addView(vwUserStatusDeveloperView)
        } else {
            removeView(vwUserStatusDeveloperView)
        }
        
        self.setupNonNormalMode()
        
    }
}


// Old Stuff OBE
//extension UserVC{
//    
//    func setup_old_viewDidLoad_end(){
//        setup_vwFindAppleHealthPermissions()
//
//        constraints_Offline_NoEmail = [
//            vwOffline.topAnchor.constraint(equalTo: vwFindAppleHealthPermissions.bottomAnchor),
//            vwOffline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            vwOffline.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            // Bottom Anchor is selected in manageUserVcOptionalViews() method
//        ]
//        constraints_Online_NoEmail = [
//            vwLocationDayWeather.topAnchor.constraint(equalTo: vwFindAppleHealthPermissions.bottomAnchor),
//            vwLocationDayWeather.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            vwLocationDayWeather.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            
//            vwUserStatus.topAnchor.constraint(equalTo: vwLocationDayWeather.bottomAnchor),
//            vwUserStatus.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            vwUserStatus.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            // Bottom Anchor is selected in manageUserVcOptionalViews() method
//        ]
//        constraints_Online_YesEmail = [
//            vwLocationDayWeather.topAnchor.constraint(equalTo: vwFindAppleHealthPermissions.bottomAnchor),
//            vwLocationDayWeather.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            vwLocationDayWeather.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            
//            vwUserStatus.topAnchor.constraint(equalTo: vwLocationDayWeather.bottomAnchor),
//            vwUserStatus.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            vwUserStatus.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            
//            vwUserDeleteAccount.topAnchor.constraint(equalTo: vwUserStatus.bottomAnchor),
//            vwUserDeleteAccount.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            vwUserDeleteAccount.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            // Bottom Anchor is selected in manageUserVcOptionalViews() method
//        ]
//        constraints_Offline_YesEmail = [
//            vwUserStatus.topAnchor.constraint(equalTo: vwFindAppleHealthPermissions.bottomAnchor),
//            vwUserStatus.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            vwUserStatus.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            
//            vwOffline.topAnchor.constraint(equalTo: vwUserStatus.bottomAnchor),
//            vwOffline.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            vwOffline.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            // Bottom Anchor is selected in manageUserVcOptionalViews() method
//        ]
//        self.setupNonNormalMode()
//    }
//    
//    func setup_vwFindAppleHealthPermissions(){
//        vwFindAppleHealthPermissions.accessibilityIdentifier = "vwFindAppleHealthPermissions"
//        vwFindAppleHealthPermissions.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(vwFindAppleHealthPermissions)
//        NSLayoutConstraint.activate([
//            vwFindAppleHealthPermissions.topAnchor.constraint(equalTo: contentView.topAnchor),
//            vwFindAppleHealthPermissions.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            vwFindAppleHealthPermissions.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//        ])
//    }
//    func setup_vwLocationDayWeather(){
//        vwLocationDayWeather.accessibilityIdentifier = "vwLocationDayWeather"
//        vwLocationDayWeather.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(vwLocationDayWeather)
//    }
//    func setup_vwOffline(){
//        print("-- adding vwOffline")
//        vwOffline.accessibilityIdentifier = "vwOffline"
//        vwOffline.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(vwOffline)
//    }
//    func setup_vwUserStatus(){
//        print("-- adding vwUserStatus")
//        vwUserStatus.accessibilityIdentifier = "vwUserStatus"
//        vwUserStatus.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(vwUserStatus)
//    }
//    func setup_vwUserDeleteAccount(){
//        print("-- adding vwUserStatus")
//        vwUserDeleteAccount.accessibilityIdentifier = "vwUserDeleteAccount"
//        vwUserDeleteAccount.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(vwUserDeleteAccount)
//    }
//    func setup_vwUserStatusDeveloperView(){
//        print("-- adding vwOffline")
//        vwUserStatusDeveloperView.accessibilityIdentifier = "vwStatusTemporary"
//        vwUserStatusDeveloperView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.addSubview(vwUserStatusDeveloperView)
//    }
//    
//    /*Manage Views */
//    func manageUserVcOptionalViews(){
//        
//        
//        // Choose the bottomAnchor depending on isOnline and email status
//        if UserStore.shared.isGuestMode{
//            bottomAnchorForUserVcContentBottomAnchor = vwUserStatus.bottomAnchor// same as case_option_2_
//        }
//        else if !UserStore.shared.isOnline, UserStore.shared.user.email == nil {
//            bottomAnchorForUserVcContentBottomAnchor = vwOffline.bottomAnchor
//        }else if UserStore.shared.isOnline, UserStore.shared.user.email == nil{
//            bottomAnchorForUserVcContentBottomAnchor = vwUserStatus.bottomAnchor
//        } else if UserStore.shared.isOnline, UserStore.shared.user.email != nil{
//            bottomAnchorForUserVcContentBottomAnchor = vwUserDeleteAccount.bottomAnchor
//        } else if !UserStore.shared.isOnline, UserStore.shared.user.email != nil {
//            bottomAnchorForUserVcContentBottomAnchor = vwOffline.bottomAnchor
//        }
//        
//        // Choose App's Mode: Dev or Prod and create set of constraints to attached to the bottom of the contentView
//        if UserStore.shared.isInDevMode{
//            constraintsForBottomOfUserVcContentView = [
//                vwUserStatusDeveloperView.topAnchor.constraint(equalTo: bottomAnchorForUserVcContentBottomAnchor, constant: heightFromPct(percent: 3)),
//                vwUserStatusDeveloperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
//                vwUserStatusDeveloperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
//                vwUserStatusDeveloperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: heightFromPct(percent: -10)),
//            ]
//        } else {
//            constraintsForBottomOfUserVcContentView = [
//                bottomAnchorForUserVcContentBottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: heightFromPct(percent: -10)),
//            ]
//        }
//        
//        // Choose case depending on isGuestMode, isOnline and email
//        if UserStore.shared.isGuestMode{
//            case_option_2_Online_and_generic_name()
//        }
//        else if !UserStore.shared.isOnline, UserStore.shared.user.email == nil {
//            case_option_1_Offline_and_generic_name()
//        }else if UserStore.shared.isOnline, UserStore.shared.user.email == nil{
//            case_option_2_Online_and_generic_name()
//        } else if UserStore.shared.isOnline, UserStore.shared.user.email != nil{
//            case_option_3_Online_and_custom_email()
//        } else if !UserStore.shared.isOnline, UserStore.shared.user.email != nil {
//            case_option_4_Offline_and_custom_email()
//        }
//        
//        // If Dev add the UserStatusDeveloperView
//        if UserStore.shared.isInDevMode{
//            vwUserStatusDeveloperView.delegate = self
//            setup_vwUserStatusDeveloperView()
//        }
//        
//        // Activate bottom constraint which is dependent of whether or not UserStatusDeveloperView is present
//        NSLayoutConstraint.activate(constraintsForBottomOfUserVcContentView)
//    }
//    
//    func remove_optionalViews(){
//        NSLayoutConstraint.deactivate(constraintsForBottomOfUserVcContentView)
//        NSLayoutConstraint.deactivate(constraints_Offline_NoEmail)
//        NSLayoutConstraint.deactivate(constraints_Online_NoEmail)
//        NSLayoutConstraint.deactivate(constraints_Offline_YesEmail)
//        NSLayoutConstraint.deactivate(constraints_Online_YesEmail)
//        vwLocationDayWeather.removeFromSuperview()
//        vwOffline.removeFromSuperview()
//        vwUserStatus.removeFromSuperview()
//        vwUserDeleteAccount.removeFromSuperview()
//        vwUserStatusDeveloperView.removeFromSuperview()
//        print("--- finished remove_optionalViews -")
//    }
//    
//    func case_option_1_Offline_and_generic_name(){
//        remove_optionalViews()
//        setup_vwOffline()
//        NSLayoutConstraint.activate(constraints_Offline_NoEmail)
//    }
//    func case_option_2_Online_and_generic_name(){
//        remove_optionalViews()
//        setup_vwLocationDayWeather()
//        setup_vwUserStatus()
//        vwUserStatus.btnUsernameFilled.setTitle(UserStore.shared.user.username, for: .normal)
//        
//        let recordCount = UserStore.shared.arryDataSourceObjects?.first?.recordCount ?? "0"
//        vwUserStatus.btnRecordCountFilled.setTitle(recordCount, for: .normal)
//        NSLayoutConstraint.deactivate(vwUserStatus.constraints_NO_VwRegisterButton)
//        vwUserStatus.setup_vcRegistrationButton()
//        NSLayoutConstraint.activate(vwUserStatus.constraints_YES_VwRegisterButton)
//        NSLayoutConstraint.activate(constraints_Online_NoEmail)
//    }
//    func case_option_3_Online_and_custom_email(){
//        remove_optionalViews()
//        setup_vwLocationDayWeather()
//        setup_vwUserStatus()
//        vwUserStatus.btnUsernameFilled.setTitle(UserStore.shared.user.username, for: .normal)
//        let recordCount = UserStore.shared.arryDataSourceObjects?.first?.recordCount ?? "0"
//        vwUserStatus.btnRecordCountFilled.setTitle(recordCount, for: .normal)
//        NSLayoutConstraint.deactivate(vwUserStatus.constraints_YES_VwRegisterButton)
//        vwUserStatus.vwRegisterButton.removeFromSuperview()
//        NSLayoutConstraint.activate(vwUserStatus.constraints_NO_VwRegisterButton)
//        setup_vwUserDeleteAccount()
//        NSLayoutConstraint.activate(constraints_Online_YesEmail)
//    }
//    func case_option_4_Offline_and_custom_email(){
//        remove_optionalViews()
//        setup_vwUserStatus()
//        vwUserStatus.remove_vcRegistrationButton()
//        vwUserStatus.btnUsernameFilled.setTitle(UserStore.shared.user.username, for: .normal)
//        let recordCount = UserStore.shared.arryDataSourceObjects?.first?.recordCount ?? "0"
//        vwUserStatus.btnRecordCountFilled.setTitle(recordCount, for: .normal)
//        setup_vwOffline()
//        NSLayoutConstraint.activate(constraints_Offline_YesEmail)
//    }
//}

// UIScrollView, ContentView, UIStackView
extension UserVC {
    func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: vwTopSafeBar.bottomAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func setupContentView() {
        contentView.accessibilityIdentifier = "contentView"
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
         NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor) // This ensures vertical scrolling
        ])
    }
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}



