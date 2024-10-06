//
//  UserVC.swift
//  TabBar07
//
//  Created by Nick Rodriguez on 28/06/2024.
//

import UIKit

//class UserVC: TemplateVC, UserVcLocationDayWeatherDelegate, UserVcOfflineDelegate, UserVcRegisterButtonDelegate, UserVcDeleteDelegate, RegisterVcDelegate, AreYouSureModalVcDelegate, UserStatusDevelopmentViewDelegate{

class UserVC: TemplateVC, UserVcLocationDayWeatherDelegate,  UserVcRegisterButtonDelegate, UserVcDeleteDelegate, UserStatusDevelopmentViewDelegate, RegisterVcDelegate, AreYouSureModalVcDelegate, UserVcOtherSettingsDelegate, UserVcOfflineDelegate{
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let stackView = UIStackView()
        
    let vwFindAppleHealthPermissions = UserVcFindAppleHealthPermissionsView()

    let vwLocationDayWeather = UserVcLocationDayWeather(frame: CGRect.zero, showLine: true)

    let vwOffline = UserVcOffline(frame: CGRect.zero, showLine: true)

    let vwUserStatus = UserVcUserStatusView(frame: CGRect.zero)
    
    let vwRegisterButton = UserVcRegisterButton()
        
    let vwUserDeleteAccount = UserVcDelete(frame: CGRect.zero, showLine: true)
    
    let vwOtherSettings = UserVcOtherSettings()
    
    /* Dev view dependent properties */
    let vwUserStatusDeveloperView = UserStatusDevelopmentView(frame: CGRect.zero, showLine: true)
    var constraintsForBottomOfUserVcContentView = [NSLayoutConstraint]()
    var bottomAnchorForUserVcContentBottomAnchor:NSLayoutAnchor<NSLayoutYAxisAnchor>!


    override func viewDidLoad() {
        print("- in UserVC viewDidLoad 🙋🏻-")
        super.viewDidLoad()
        vwOffline.delegate = self
        vwRegisterButton.delegate = self
        vwLocationDayWeather.delegate = self
        vwUserDeleteAccount.delegate = self
        vwOtherSettings.delegate = self
        vwUserStatusDeveloperView.delegate = self

        
        self.setup_TopSafeBar()
        setupScrollView()
        setupContentView()
        setupStackView()
        
        print("--->>>> what is UserStore.shared.isOnline: \(UserStore.shared.isOnline)")
        print("--->>>> what is UserStore.shared.isGuestMode: \(UserStore.shared.isGuestMode)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("--- START UserVC.viewWillApear > inspect Location 📍🗺️ booleans:")
        print("UserDefaults 🙋‍♂️:")
        print("UserDefaults location_permission_ws: \(UserDefaults.standard.bool(forKey: "location_permission_ws"))")
        print("UserDefaults location_permission_device: \(UserDefaults.standard.bool(forKey: "location_permission_device"))")
        print("UserStore.user 📲")
        print("🗺️ location_permission_ws: \(UserStore.shared.user.location_permission_ws)")
        print("🗺️ location_permission_device: \(UserStore.shared.user.location_permission_device)")
        print("--- END UserVC.UserVcLocaitonDayWeather -----------")
    }

    // Method to add a new view to the stackView
    func addView(_ newView: UIView) {
//        var viewsCount = stackView.subviews.count
//        stackView.insertArrangedSubview(newView, at: viewsCount)
        stackView.addArrangedSubview(newView)
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

        // NOTE: The order in this method is important. If the order stays the same the subviews will always be placed in the right order.
        // vwFindAppleHealthPermissions
        addView(vwFindAppleHealthPermissions)
        
        // vwLocationDayWeather
        if UserStore.shared.isOnline{
            addView(vwLocationDayWeather)
        } else {
            removeView(vwLocationDayWeather)
        }
        
        // vwOffline
        if !UserStore.shared.isOnline && !UserStore.shared.isGuestMode{
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



