//
//  DashboardVC.swift
//  TabBar07
//
//  Created by Nick Rodriguez on 28/06/2024.
//

import UIKit

class DashboardVC: TemplateVC, DashboardHeaderDelegate, SelectDashboardVCDelegate,InformationViewDelegate {
    
//    var userStore:UserStore!
    let vwDashboardHeader = DashboardHeader()
    var tblDashboard:UITableView?
    var vwDashboardHasNoData = InformationView()
    
    var refreshControlTblDashboard:UIRefreshControl?
    override func viewDidLoad() {
        super.viewDidLoad()
//        userStore = UserStore.shared
        vwDashboardHeader.delegate = self
        
        setup_TopSafeBar()
        
        navigationController?.setNavigationBarHidden(true, animated: false)// This seems to really hide the UINavigationBar
    }
    
    func setupUserHasNODashboard(){
        vwDashboardHeader.removeFromSuperview()
        tblDashboard?.removeFromSuperview()
        vwDashboardHasNoData.delegate = self
        vwDashboardHasNoData.setup_btnRefreshDashboard()
        vwDashboardHasNoData.lblTitle.text = "No Data"
        vwDashboardHasNoData.lblDescription.text = "Go to Manage Data to submit your data for analysis"
        vwDashboardHasNoData.accessibilityIdentifier="vwDashboardHasNoData"
        vwDashboardHasNoData.translatesAutoresizingMaskIntoConstraints=false
        vwDashboardHasNoData.layer.cornerRadius = 12
        view.addSubview(vwDashboardHasNoData)
        NSLayoutConstraint.activate([
            self.vwDashboardHasNoData.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            self.vwDashboardHasNoData.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: smallPaddingSide),
            self.vwDashboardHasNoData.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -smallPaddingTop),
        ])
    }
    
    func setupUserHasDashboard(){
        vwDashboardHasNoData.removeFromSuperview()
        setup_vwDashboardHeader()
        setup_tblDashboard()
    }
    
    private func setup_vwDashboardHeader(){
        vwDashboardHeader.accessibilityIdentifier = "vwDashboardHeader"
        vwDashboardHeader.translatesAutoresizingMaskIntoConstraints = false
        vwDashboardHeader.btnDashboardNamePicker.backgroundColor = UIColor(named: "ColorRow3Textfields")
        vwDashboardHeader.btnDashboardNamePicker.titleLabel?.font = UIFont(name: "ArialRoundedMTBold", size: 27)
        view.addSubview(vwDashboardHeader)
        NSLayoutConstraint.activate([
            vwDashboardHeader.topAnchor.constraint(equalTo: vwTopSafeBar.bottomAnchor),
            vwDashboardHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vwDashboardHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            vwDashboardHeader.bottomAnchor.constraint(equalTo: vwTopSafeBar.bottomAnchor, constant: heightFromPct(percent: 10))
        ])
    }
    func setup_tblDashboard(){
        
        self.tblDashboard = UITableView()
        self.tblDashboard!.accessibilityIdentifier = "tblDashboard"
        self.tblDashboard!.translatesAutoresizingMaskIntoConstraints=false
        self.tblDashboard!.delegate = self
        self.tblDashboard!.dataSource = self
        self.tblDashboard!.register(DashboardTableCell.self, forCellReuseIdentifier: "DashboardTableCell")
        self.tblDashboard!.rowHeight = UITableView.automaticDimension
        self.tblDashboard!.estimatedRowHeight = 100
        view.addSubview(self.tblDashboard!)
        NSLayoutConstraint.activate([
            tblDashboard!.topAnchor.constraint(equalTo: vwDashboardHeader.bottomAnchor, constant: heightFromPct(percent: 2)),
            tblDashboard!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tblDashboard!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tblDashboard!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])
        
        self.refreshControlTblDashboard = UIRefreshControl()
        refreshControlTblDashboard!.addTarget(self, action: #selector(self.refresh_tblDashboardData(_:)), for: .valueChanged)
        self.tblDashboard!.refreshControl = refreshControlTblDashboard!
    }
    
    //    func updateDataSourceAndDashboardReferences(){
    //        print("- in DashboardVC / updateDataSourceAndDashboardReferences() --")
    //        print(userStore.arryDataSourceObjects)
    //    }
    //
    
    @objc private func touchUpInside_btnRefreshDashboard(_ sender: UIButton){
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        //        self.update_arryDashboardTableObjects()
        print("Check for User Dashboard data")
    }
    
    /* Protocol methods */
    func didSelectDashboard(currentDashboardObjPos:Int){
        print("- didSelectDashboard")
        let dash_tab_obj = UserStore.shared.arryDashboardTableObjects[currentDashboardObjPos]
        print("-- > user selected \(currentDashboardObjPos) - \(dash_tab_obj.dependentVarName!)")
        
        for i in dash_tab_obj.arryIndepVarObjects!{
            print("--- > Ind var name: \(i.independentVarName!), corr: \(i.correlationValue!)")
        }
        
        DispatchQueue.main.async{
            UserStore.shared.currentDashboardObjPos = currentDashboardObjPos
            UserStore.shared.currentDashboardObject = UserStore.shared.arryDashboardTableObjects[currentDashboardObjPos]
            print("-- > this should change here")
            if let unwp_dashTitle = UserStore.shared.arryDashboardTableObjects[currentDashboardObjPos].dependentVarName {
                let btnTitle = " " + unwp_dashTitle + " "
                self.vwDashboardHeader.btnDashboardNamePicker.setTitle(btnTitle, for: .normal)
            }
            self.tblDashboard?.reloadData()
        }
    }
    
    
    
    @objc func touchUpInside_btnSelectDashboards(_ sender: UIRefreshControl){
        print("present SelectDashboardVC")
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
        let selectDashboardVC = SelectDashboardVC()
        selectDashboardVC.delegate = self
        selectDashboardVC.modalPresentationStyle = .overCurrentContext
        selectDashboardVC.modalTransitionStyle = .crossDissolve
        self.present(selectDashboardVC, animated: true, completion: nil)
    }
    
    // This is for the title/name of the dashboard (NOT refresh button)
    func presentHeaderTitleInfo(){
        let title = UserStore.shared.currentDashboardObject?.dependentVarName
        let description = UserStore.shared.currentDashboardObject?.definition
        //        let vwInfo = InformationView(frame: CGRect.zero, title: title, description: description)
        let infoVC = InformationVC()
        infoVC.vwInformation.lblTitle.text = title
        infoVC.vwInformation.lblDescription.text = description
        //        infoVC.setup_btnRefreshDashboard()
        infoVC.modalPresentationStyle = .overCurrentContext
        infoVC.modalTransitionStyle = .crossDissolve
        self.present(infoVC, animated: true, completion: nil)
        
    }
    
    
}


// Pull Down Refresh
extension DashboardVC {
    
    @objc private func refresh_tblDashboardData(_ sender: UIRefreshControl){
        self.update_arryDashboardTableObjects()
    }
    
    
    func update_arryDashboardTableObjects(){
        UserStore.shared.callSendDashboardTableObjects { resultHasNewLastUpdateDate in
            switch resultHasNewLastUpdateDate{
            case let .success(hasNewLastUpdateDate):
                
                if hasNewLastUpdateDate{
                    DispatchQueue.main.async {
                        self.templateAlert(alertTitle: "New data analyzed 📊📈", alertMessage: nil, completion: nil)
                    }
                }
                
                
//                if let arryDataSourceObjsArray = jsonDict["arryDataSourceObjects"] as? [[String: Any]] {
//                    //                if let arryDataSourceObjs =  jsonDict["arryDataSourceObjects"] as? DataSourceObject{
//                    do {
//                        let jsonData = try JSONSerialization.data(withJSONObject: arryDataSourceObjsArray, options: [])
//                        let arryDataSourceObjs = try JSONDecoder().decode([DataSourceObject].self, from: jsonData)
//                        print("- got Object 🔥")
//                        if let userStoreArryDataSourceObjs = UserStore.shared.arryDataSourceObjects{
//                            print("-- unpacked optionals #1")
//                            if arryDataSourceObjs[0].lastUpdate == userStoreArryDataSourceObjs[0].lastUpdate{
//                                print("-- unpacked optionals #1 - lastUpdate are samsies -")
//
//                            } else {
//                                DispatchQueue.main.async {
//                                    self.templateAlert(alertTitle: "New data analyzed 📊📈", alertMessage: nil, completion: nil)
//                                }
//                            }
//                        }
//                        else{
//                            print("-- unpacked optionals #1 - lastUpdate are NOT samsies -")
//                        }
//                        print("-- Ended/After uppack sequence -")
//                    }
//                    
//                    catch{
//                        print("Failed to decode DataSourceObject: \(error)")
//                        self.templateAlert(alertTitle: "No new data received", alertMessage: nil, completion: nil)
//                    }
//                }
//                
                
                
                
                if let unwp_refreshControlTblDashboard = self.refreshControlTblDashboard {
                    DispatchQueue.main.async {
                        print("- unwp_refreshControlTblDashboard.endRefreshing() ")
                        unwp_refreshControlTblDashboard.endRefreshing()
                    }
                }
                if let unwp_tblDashboard = self.tblDashboard {
                    DispatchQueue.main.async {
                        unwp_tblDashboard.reloadData()
                    }
                }
                print("- End of success update_arrayDAsh...")
            case let .failure(error):
                print("failure: DashboardVC trying to update dashboard via func update_arryDashboardTableObjects; the error is \(error)")
                if let unwp_refreshControlTblDashboard = self.refreshControlTblDashboard {
                    DispatchQueue.main.async {
                        unwp_refreshControlTblDashboard.endRefreshing()
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.templateAlert(alertTitle: "No Data Found Dashboard", alertMessage: "If you just added data, it could take a couple minutes to process. \n\nOtherwise try adding data.")
                }
                
            }
        }
    }
}



extension DashboardVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? DashboardTableCell else { return }
        cell.isVisible.toggle()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}

extension DashboardVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dashTableObj = UserStore.shared.currentDashboardObject,
              let unwp_arryIndepVarObj = dashTableObj.arryIndepVarObjects else {
            return 0
        }
        return unwp_arryIndepVarObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableCell", for: indexPath) as! DashboardTableCell
        guard let currentDashObj = UserStore.shared.currentDashboardObject,
              let arryIndepVarObjects = currentDashObj.arryIndepVarObjects,
              let unwpVerb = currentDashObj.verb else {return cell}
        
        cell.indepVarObject = arryIndepVarObjects[indexPath.row]
        cell.depVarVerb = unwpVerb
        cell.configureCellWithIndepVarObject()
        return cell
    }
    
}

