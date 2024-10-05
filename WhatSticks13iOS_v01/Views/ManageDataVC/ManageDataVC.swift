//
//  ManageDataVC.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 14/07/2024.
//

import UIKit

class ManageDataVC: TemplateVC, AreYouSureModalVcDelegateDeleteUserHealthData {
//    var userStore: UserStore!
//    var appleHealthDataFetcher:AppleHealthDataFetcher!
//    var healthDataStore: HealthDataStore!
    var vwManageDataVcHeader = ManageDataVcHeader()
    var vwManageDataVcOffline = InformationView()
    let datePicker = UIDatePicker()
    var dtUserHistory:Date?
    
    let btnSendData = UIButton()
    
    var arryStepsDict = [AppleHealthQuantityCategory](){
        didSet{
            actionGetSleepData()
        }
    }
    var arrySleepDict = [AppleHealthQuantityCategory](){
        didSet{
            actionGetHeartRateData()
        }
    }
    var arryHeartRateDict = [AppleHealthQuantityCategory](){
        didSet{
            actionGetExerciseTimeData()
        }
    }
    var arryExerciseTimeDict = [AppleHealthQuantityCategory](){
        didSet{
            actionGetWorkoutData()
        }
    }
    var arryWorkoutDict = [AppleHealthWorkout](){
        didSet{
            sendAppleWorkouts()
        }
    }
    
    var strStatusMessage=String()
    
    var btnDeleteData = UIButton()
    
    override func viewDidLoad() {
        print("* ManageDataVC viewDidLoad *")
//        userStore = UserStore.shared
        if !UserStore.shared.isGuestMode{
            print("- prompting for authorizeHealthKit() ")
            AppleHealthDataFetcher.shared.authorizeHealthKit()
        }
        setup_TopSafeBar()
        view.backgroundColor = UIColor(named: "ColorAppBackground")
        setupNonNormalMode()
        navigationController?.setNavigationBarHidden(true, animated: false)// This seems to really hide the UINavigationBar
    }
    func setupManageDataVcOffline(){
        datePicker.removeFromSuperview()
        btnSendData.removeFromSuperview()
        btnDeleteData.removeFromSuperview()
        vwManageDataVcOffline.lblTitle.text = "Ooops ...."
        vwManageDataVcOffline.lblDescription.text = "This app has not been able to connect with the What Sticks server. Either restart or try back later...  ¯\\_(ツ)_/¯"
        vwManageDataVcOffline.accessibilityIdentifier="vwDashboardHasNoData"
        vwManageDataVcOffline.translatesAutoresizingMaskIntoConstraints=false
        vwManageDataVcOffline.layer.cornerRadius = 12
        view.addSubview(vwManageDataVcOffline)
        NSLayoutConstraint.activate([
            self.vwManageDataVcOffline.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.vwManageDataVcOffline.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: smallPaddingSide),
            self.vwManageDataVcOffline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -smallPaddingTop),
        ])
    }
    func setupManageDataVcOnline(){
        vwManageDataVcOffline.removeFromSuperview()
        setupManageDataVcHeaderView()
//        setup_ManageDataVcTitle()
//        setup_UserVcAccountView()
        setupDatePicker()
        setup_btnSendData()
        print("- ManageDataVC setupManageDataVcOnline() -")
        print("UserStore.shared.arryaDataSourceObjects?: \(UserStore.shared.arryDataSourceObjects?.first)")
        print(UserStore.shared.arryDataSourceObjects?.first?.recordCount)
        if let recordCountString = UserStore.shared.arryDataSourceObjects?.first?.recordCount?.replacingOccurrences(of: ",", with: ""),
           let recordCount = Int(recordCountString),
           recordCount > 0 {
            setup_btnDeleteData()
        }
    }
    
    func setupManageDataVcHeaderView(){
        vwManageDataVcHeader.accessibilityIdentifier = "vwManageDataVcHeader"
        vwManageDataVcHeader.translatesAutoresizingMaskIntoConstraints = false
//        vwDashboardHeader.backgroundColor = UIColor(named: "ColorRow2")

        view.addSubview(vwManageDataVcHeader)
        NSLayoutConstraint.activate([
            vwManageDataVcHeader.topAnchor.constraint(equalTo: vwTopSafeBar.bottomAnchor),
            vwManageDataVcHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vwManageDataVcHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            vwManageDataVcHeader.bottomAnchor.constraint(equalTo: vwTopSafeBar.bottomAnchor, constant: heightFromPct(percent: 10))
        ])
    }

    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(datePicker)
        datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: vwManageDataVcHeader.bottomAnchor, constant: heightFromPct(percent: 2)).isActive = true
    }
    
    func setup_btnSendData(){
        btnSendData.accessibilityIdentifier = "btnSendData"
        btnSendData.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnSendData)
        btnSendData.setTitle("Analze Data", for: .normal)
        btnSendData.layer.borderColor = UIColor.systemBlue.cgColor
        btnSendData.layer.borderWidth = 2
        btnSendData.backgroundColor = .systemBlue
        btnSendData.layer.cornerRadius = 10
        
        btnSendData.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btnSendData.addTarget(self, action: #selector(touchUpInsideStartCollectingAppleHealth(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            btnSendData.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: heightFromPct(percent: 2)),
            btnSendData.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 3)),
            btnSendData.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -3))
        ])
    }
    
    func setup_btnDeleteData(){
        btnDeleteData.accessibilityIdentifier = "btnDeleteData"
        btnDeleteData.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnDeleteData)
        btnDeleteData.setTitle("Delete User Data", for: .normal)
//        btnDeleteData.layer.borderColor = UIColor.systemBlue.cgColor
        btnDeleteData.layer.borderWidth = 2
        btnDeleteData.backgroundColor = UIColor(red: 0.8, green: 0.3, blue: 0.3, alpha: 1.0)
        btnDeleteData.layer.cornerRadius = 10
        
        btnDeleteData.addTarget(self, action: #selector(touchDown(_:)), for: .touchDown)
        btnDeleteData.addTarget(self, action: #selector(touchUpInsideCallDeleteData(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            btnDeleteData.topAnchor.constraint(equalTo: btnSendData.bottomAnchor, constant: heightFromPct(percent: 2)),
            btnDeleteData.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: widthFromPct(percent: 3)),
            btnDeleteData.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: widthFromPct(percent: -3))
        ])
    }
    
    
    @objc func touchUpInsideStartCollectingAppleHealth(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        print(" send data")
        if UserStore.shared.isGuestMode{
            let informationVc = InformationVC()
            informationVc.vwInformation.lblTitle.text = "Guest Mode"
            informationVc.vwInformation.lblDescription.text = "While in guest mode user's cannot send data. \n\n If you would like to analyze your data please close the app and restart in Normal mode."
            informationVc.modalPresentationStyle = .overCurrentContext
            informationVc.modalTransitionStyle = .crossDissolve
            self.presentNewView(informationVc)
        }
        else {
            dtUserHistory = datePicker.date
            
            let calendar = Calendar.current
            // Strip off time components from both dates
            let selectedDate = calendar.startOfDay(for: datePicker.date)
            let currentDate = calendar.startOfDay(for: Date())
            // Check if selectedDate is today or in the future
            if selectedDate >= currentDate {
                self.templateAlert(alertMessage: "You must pick a day in the past.")
                return
            }
            actionGetStepsData()
        }
    }
    
    @objc func touchUpInsideCallDeleteData(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        print(" send call to delete user data 📢❗🚨")
        //        let areYouSureVC = AreYouSureModalVC()
        let areYouSureVC = AreYouSureModalVC(strForDeleteUserHealthBtn: "Yes, delete")
        
        // Set the modal presentation style
        areYouSureVC.modalPresentationStyle = .overCurrentContext
        areYouSureVC.modalTransitionStyle = .crossDissolve
        areYouSureVC.delegateManageDataVc = self
//        self.delegate?.presentNewView(areYouSureVC)
        self.present(areYouSureVC, animated: true, completion: nil)
    }
}



/* Sending Apple Health Data */
extension ManageDataVC{
    @objc func actionGetStepsData() {

//        if swtchAllHistoryIsOn {
//            dtUserHistory = nil
//        } else {
            dtUserHistory = datePicker.date
            
            let calendar = Calendar.current
            // Strip off time components from both dates
            let selectedDate = calendar.startOfDay(for: datePicker.date)
            let currentDate = calendar.startOfDay(for: Date())
            // Check if selectedDate is today or in the future
            if selectedDate >= currentDate {
                self.templateAlert(alertMessage: "You must pick a day in the past.")
                return
            }
//        }
        self.showSpinner()
        AppleHealthDataFetcher.shared.fetchStepsAndOtherQuantityType(quantityTypeIdentifier: .stepCount, startDate: self.dtUserHistory) { fetcherResult in
            switch fetcherResult{
            case let .success(arryStepsDict):
                print("succesfully collected - arryStepsDict - from healthFetcher class")
                self.arryStepsDict = arryStepsDict
                let formatted_arryStepsDictCount = formatWithCommas(number: self.arryStepsDict.count)
                self.spinnerScreenLblMessage(message: "Retrieved \(formatted_arryStepsDictCount) Steps records")

            case let .failure(error):
                self.templateAlert(alertTitle: "Alert", alertMessage: "This app will not function correctly without steps data. Go to Settings > Health > Data Access & Devices > WhatSticks11iOS to grant access")
                print("There was an error getting steps: \(error)")
                self.removeSpinner()
            }
        }
    }
    func actionGetSleepData(){
        AppleHealthDataFetcher.shared.fetchSleepDataAndOtherCategoryType(categoryTypeIdentifier:.sleepAnalysis, startDate: self.dtUserHistory) { fetcherResult in
            switch fetcherResult{
            case let .success(arrySleepDict):
                print("succesfully collected - arrySleepDict - from healthFetcher class")
                self.arrySleepDict = arrySleepDict
                let formatted_arrySleepDictCount = formatWithCommas(number: arrySleepDict.count)
                if let unwp_message = self.lblMessage.text {
                    self.lblMessage.text = unwp_message + "," + "\n \(formatted_arrySleepDictCount) Sleep records"
                }

            case let .failure(error):
                self.templateAlert(alertTitle: "Alert", alertMessage: "This app will not function correctly without sleep data. Go to Settings > Health > Data Access & Devices > WhatSticks11iOS to grant access")
                print("There was an error getting sleep: \(error)")
                self.removeSpinner()
                
            }
        }
    }
    func actionGetHeartRateData(){
        AppleHealthDataFetcher.shared.fetchStepsAndOtherQuantityType(quantityTypeIdentifier: .heartRate, startDate: self.dtUserHistory) { fetcherResult in
            switch fetcherResult{
            case let .success(arryHeartRateDict):
                print("succesfully collected - arryHeartRateDict - from healthFetcher class")
                self.arryHeartRateDict = arryHeartRateDict
                let formatted_arryHeartRateDictCount = formatWithCommas(number: arryHeartRateDict.count)
                if let unwp_message = self.lblMessage.text {
                    self.lblMessage.text = unwp_message + "," + "\n \(formatted_arryHeartRateDictCount) Heart Rate records"
                }
            case let .failure(error):
                print("There was an error getting heart rate: \(error)")
                self.removeSpinner()
            }
        }
    }
    func actionGetExerciseTimeData(){
        AppleHealthDataFetcher.shared.fetchStepsAndOtherQuantityType(quantityTypeIdentifier: .appleExerciseTime, startDate: self.dtUserHistory) { fetcherResult in
            switch fetcherResult{
            case let .success(arryExerciseTimeDict):
                print("succesfully collected - arryExerciseTimeDict - from healthFetcher class")
                self.arryExerciseTimeDict = arryExerciseTimeDict
//                self.removeLblMessage()
                let formatted_arryExerciseTimeDictCount = formatWithCommas(number: arryExerciseTimeDict.count)
//                self.spinnerScreenLblMessage(message: "Retrieved \(formatted_arryExerciseTimeDictCount) Exercise Time records")
                if let unwp_message = self.lblMessage.text {
                    self.lblMessage.text = unwp_message + "," + "\n \(formatted_arryExerciseTimeDictCount) Exerciese records"
                }
            case let .failure(error):
                print("There was an error getting heart rate: \(error)")
                self.removeSpinner()
            }
        }
    }
    func actionGetWorkoutData(){
        AppleHealthDataFetcher.shared.fetchWorkoutData( startDate: self.dtUserHistory) { fetcherResult in
            switch fetcherResult{
            case let .success(arryWorkoutDict):
                print("succesfully collected - arryWorkoutDict - from healthFetcher class")
                self.arryWorkoutDict = arryWorkoutDict
//                self.removeLblMessage()
                let formatted_arryWorkoutDictCount = formatWithCommas(number: arryWorkoutDict.count)
//                self.spinnerScreenLblMessage(message: "Retrieved \(formatted_arryWorkoutDictCount) Workout records")
                if let unwp_message = self.lblMessage.text {
                    self.lblMessage.text = unwp_message + "," + "\n \(formatted_arryWorkoutDictCount) Workout records"
                }
            case let .failure(error):
                print("There was an error getting heart rate: \(error)")
                self.removeSpinner()
            }
        }
    }
    

    func sendAppleWorkouts(){
        
        print("- in sendAppleWorkouts")
        let dateStringTimeStamp = timeStampsForFileNames()
        // dateStringTimeStamp --> important for file name used by WSAPI/WSAS
        guard let user_id = UserStore.shared.user.id else {
            self.templateAlert(alertMessage: "No user id. check ManageAppleHealthVC sendAppleHealthData.")
            return}
        let qty_cat_and_workouts_count = arrySleepDict.count + arryStepsDict.count + arryHeartRateDict.count + arryExerciseTimeDict.count + arryWorkoutDict.count
        if qty_cat_and_workouts_count > 0 {
            self.removeLblMessage()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let formatted_qty_cat_and_workouts_count = formatWithCommas(number: qty_cat_and_workouts_count)
                self.spinnerScreenLblMessage(message: "Preparing \(formatted_qty_cat_and_workouts_count) Apple Health records for analysis.")
            }
        }
        HealthDataStore.shared.callReceiveAppleWorkoutsData(userId: user_id,dateStringTimeStamp:dateStringTimeStamp, arryAppleWorkouts: arryWorkoutDict) { resultResponse in
                switch resultResponse{
                case .success(_):
                    self.sendAppleHealthData(userMessage:"updated apple workouts", dateStringTimeStamp:dateStringTimeStamp)
                    self.strStatusMessage = "1) Workouts sent succesfully"
                case .failure(_):
                    self.strStatusMessage = "1) Workouts NOT sent successfully"
                    self.sendAppleHealthData(userMessage:"updated apple workouts", dateStringTimeStamp:dateStringTimeStamp)
                }
            }
        
    }
    func sendAppleHealthData(userMessage:String, dateStringTimeStamp:String){
        print("- in sendAppleHealthData")
        guard let user_id = UserStore.shared.user.id else {
            self.templateAlert(alertMessage: "No user id. check ManageAppleHealthVC sendAppleHealthData.")
            return}
//        let qty_cat_data_count = arrySleepDict.count + arryStepsDict.count + arryHeartRateDict.count + arryExerciseTimeDict.count
            let arryQtyCatData = arrySleepDict + arryStepsDict + arryHeartRateDict + arryExerciseTimeDict

            /* Send apple works outs first */
        HealthDataStore.shared.sendChunksToWSAPI(userId:user_id,dateStringTimeStamp:dateStringTimeStamp ,arryAppleHealthData: arryQtyCatData) { responseResult in
                self.removeSpinner()
                switch responseResult{
                case .success(_):
                    self.strStatusMessage = self.strStatusMessage + "\n" + "2) Quantity and Category data sent successfully."
                    self.templateAlert(alertTitle: "Success!",alertMessage: "")
                    print("*** MangeAppleHealhtVC.sendAppleHealthData successful! ** ")

                case .failure(_):
                    print("---- MangeAppleHealhtVC.sendAppleHealthData failed :( ---- ")
                    self.strStatusMessage = self.strStatusMessage + "\n" + "2) Quantity and Category data NOT sent successfully."

                    self.templateAlert(alertTitle: "Failed to Send",alertMessage: self.strStatusMessage)
                }
            }
    }
}
