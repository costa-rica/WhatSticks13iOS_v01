//
//  TabController.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 28/06/2024.
//

import UIKit

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var lineSelectedTab = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("- in TabController -")
        self.setupTabs()
        self.tabBar.backgroundColor = UIColor(named: "ColorTableTabModalBack")
        self.tabBar.tintColor = UIColor(named: "ColorTabBarSelected")
        self.tabBar.unselectedItemTintColor = UIColor(named: "ColorTabBarUnselected")
        self.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor(named: "ColorTabBarSelected")!, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:  tabBar.frame.height), lineWidth: 4.0)
        self.delegate = self
        
    }
    

    private func setupTabs(){
        let home = self.createNav(with: "Home", and: UIImage(systemName: "house"), vc: HomeVC())
        let dash = self.createNav(with: "Dashboard", and: UIImage(systemName: "clock"), vc: DashboardVC())
        let manage_data = self.createNav(with: "Manage Data", and: UIImage(systemName: "square.and.arrow.up"), vc: ManageDataVC())// <--- altered for TEST DAta
        let user = self.createNav(with: "Manage User", and: UIImage(systemName: "person"), vc: UserVC())

        home.tabBarItem.tag = 0
        dash.tabBarItem.tag = 1
        manage_data.tabBarItem.tag = 2
        user.tabBarItem.tag = 3
        
        self.setViewControllers([home,dash, manage_data, user], animated: true)
        
    }
    
    private func createNav(with title: String, and image: UIImage?, vc: UIViewController) -> UINavigationController{
        let nav = UINavigationController(rootViewController: vc)
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.tabBarItem.tag = 0
        return nav
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let nav_vc = viewController as? UINavigationController else {
            print("- Item is not a UINavigationController")
            return
        }
        if let _ = nav_vc.children[0] as? HomeVC {
            
        }
        
        if let user_vc = nav_vc.children[0] as? UserVC {
            user_vc.vwLocationDayWeather.setLocationSwitchBasedOnUserPermissions()
            user_vc.vwLocationDayWeather.setLocationSwitchLabelText()
            
            if let unwp_username = UserStore.shared.user.username{
                user_vc.vwUserStatus.btnUsernameFilled.setTitle(unwp_username, for: .normal)
            }
            if let unwp_arryDataSourceObjects = UserStore.shared.arryDataSourceObjects, let unwp_count = unwp_arryDataSourceObjects.first?.recordCount{
                user_vc.vwUserStatus.btnRecordCountFilled.setTitle(unwp_count, for: .normal)
            } else{
                user_vc.vwUserStatus.btnRecordCountFilled.setTitle("0", for: .normal)
            }
            
            if user_vc.view.subviews.count > 0 {
                user_vc.manageUserVcOptionalViews()
            }
            
        }

        if let manage_data_vc = nav_vc.children[0] as? ManageDataVC {// <--- altered for TEST DAta
            
            if UserStore.shared.isOnline || UserStore.shared.isGuestMode {
                manage_data_vc.setupManageDataVcOnline()
                var records = "0"
                var earliestRecordDate = "no data"
                if let unwp_array = UserStore.shared.arryDataSourceObjects{
                    if unwp_array.count > 0 {
                        records = UserStore.shared.arryDataSourceObjects?[0].recordCount ?? "0"
                        earliestRecordDate = UserStore.shared.arryDataSourceObjects?[0].earliestRecordDate ?? "no data"
                    }
                }
                manage_data_vc.vwManageDataVcHeader.btnRecordCountFilled.setTitle(records, for: .normal)
                manage_data_vc.vwManageDataVcHeader.btnEarliestDateFilled.setTitle(earliestRecordDate, for: .normal)
            }
            else if !UserStore.shared.isOnline{
                manage_data_vc.setupManageDataVcOffline()
            }
        }
        
        if let dash_vc = nav_vc.children[0] as? DashboardVC {
            if UserStore.shared.arryDashboardTableObjects.count > 0{
                dash_vc.setupUserHasDashboard()
                let currentDashboardObjPos = UserStore.shared.currentDashboardObjPos ?? 0
                if let unwp_dashTitle = UserStore.shared.arryDashboardTableObjects[currentDashboardObjPos].dependentVarName {
                    let btnTitle = " " + unwp_dashTitle + " "
                    dash_vc.vwDashboardHeader.btnDashboardNamePicker.setTitle(btnTitle, for: .normal)
                }
            } else {
                print("- No dashboard set up")
                dash_vc.setupUserHasNODashboard()
            }
            
        }
    }

}


//// Protocol definition
//protocol MainTabBarControllerDelegate: AnyObject {
//    func removeSpinner()
//    func showSpinner()
//    func templateAlert(alertTitle:String,alertMessage: String,  backScreen: Bool)
//    func presentAlertController(_ alertController: UIAlertController)
//    func touchDown(_ sender: UIButton)
//    var constraints_Offline_NoEmail:[NSLayoutConstraint] {get}
//    var constraints_Online_NoEmail:[NSLayoutConstraint] {get}
//    var constraints_Offline_YesEmail:[NSLayoutConstraint] {get}
//    func case_option_1_Offline_and_generic_name()
//    func case_option_2_Online_and_generic_name()
//    func case_option_3_Online_and_custom_email()
//    func case_option_4_Offline_and_custom_email()
//    var vwUserStatus:UserVcUserStatusView {get}
//    func test_delegate_method()
//}
//


