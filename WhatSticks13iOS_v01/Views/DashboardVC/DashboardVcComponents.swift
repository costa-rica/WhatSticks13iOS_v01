//
//  DashboardVcComponents.swift
//  WhatSticks13iOS
//
//  Created by Nick Rodriguez on 14/08/2024.
//

import UIKit


class DashboardHeader: UIView {
    
    weak var delegate: DashboardHeaderDelegate?
    var btnDashboardNamePicker = UIButton()
    var btnDashboardTitleInfo=UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // This triggers as soon as the app starts
        setup_view()
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup_view(){
        btnDashboardNamePicker.accessibilityIdentifier="btnDashboardNamePicker"
        btnDashboardNamePicker.translatesAutoresizingMaskIntoConstraints=false
        btnDashboardNamePicker.backgroundColor = .systemBlue
        btnDashboardNamePicker.layer.cornerRadius = 10
        btnDashboardNamePicker.setTitle(" Dashboards ", for: .normal)
        btnDashboardNamePicker.titleLabel?.numberOfLines = 0
        btnDashboardNamePicker.titleLabel?.lineBreakMode = .byWordWrapping
        
        btnDashboardNamePicker.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchDown)
        btnDashboardNamePicker.addTarget(self, action: #selector(touchUpInside_btnSelectDashboard(_:)), for: .touchUpInside)
        self.addSubview(btnDashboardNamePicker)
        
        
        // Info button //
        if let unwrapped_image = UIImage(named: "information") {

            let small_image = unwrapped_image.scaleImage(toSize: CGSize(width: 10, height: 10))
            btnDashboardTitleInfo.setImage(small_image, for: .normal)
            print("btnDashboardTitleInfo image: calendar.badge.exclamationmark")
        } else {
            btnDashboardTitleInfo.setImage(UIImage(systemName: "info.circle.fill"), for: .normal)
//            print("btnDashboardTitleInfo image: calendar.badge.exclamationmark")
        }
//        
        btnDashboardTitleInfo.accessibilityIdentifier="btnDashboardTitleInfo"
        btnDashboardTitleInfo.translatesAutoresizingMaskIntoConstraints=false
//        btnDashboardTitleInfo.setTitle("Info", for: .normal)
        btnDashboardTitleInfo.addTarget(self, action: #selector(self.touchDown(_:)), for: .touchDown)
        btnDashboardTitleInfo.addTarget(self, action: #selector(touchUpInside_btnDashboardTitleInfo(_:)), for: .touchUpInside)
        self.addSubview(btnDashboardTitleInfo)
        
        
        NSLayoutConstraint.activate([
            btnDashboardNamePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            btnDashboardNamePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: widthFromPct(percent: 2)),
            btnDashboardNamePicker.widthAnchor.constraint(lessThanOrEqualToConstant: widthFromPct(percent: 80)),
            
            btnDashboardTitleInfo.leadingAnchor.constraint(equalTo: btnDashboardNamePicker.trailingAnchor, constant: widthFromPct(percent: 1)),
            btnDashboardTitleInfo.centerYAnchor.constraint(equalTo: btnDashboardNamePicker.topAnchor)
        ])
    }
    @objc private func touchDown(_ sender: UIButton) {
        print("in touchDown (btnDashboardNamePicker) ")
        delegate?.touchDown(sender)
    }
    @objc private func touchUpInside_btnSelectDashboard(_ sender: UIRefreshControl){
        print("in touchUpInside_btnSelectDashboard (btnDashboardNamePicker) ")
        delegate?.touchUpInside_btnSelectDashboards(sender)
    }
    
    @objc private func touchUpInside_btnDashboardTitleInfo(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
            sender.transform = .identity
        }, completion: nil)
//        let title = UserStore.shared.currentDashboardObject?.dependentVarName
//        let description = UserStore.shared.currentDashboardObject?.definition
//        let vwInfo = InformationView(frame: CGRect.zero, title: title, description: description)
//        let infoVC = InformationVC()
//        infoVC.vwInformation = vwInfo
////        let infoVC = InfoVC(dashboardTableObject: UserStore.shared.currentDashboardObject)
//        infoVC.modalPresentationStyle = .overCurrentContext
//        infoVC.modalTransitionStyle = .crossDissolve
////        self.present(infoVC, animated: true, completion: nil)
//        delegate?.presentNewView(infoVC)
        delegate?.presentHeaderTitleInfo()
    }
    
    
}


protocol DashboardHeaderDelegate: AnyObject {
    func touchDown(_ sender: UIButton)
    func touchUpInside_btnSelectDashboards(_ sender: UIRefreshControl)
    func presentNewView(_ uiViewController: UIViewController)
    func presentHeaderTitleInfo()
}






class SelectDashboardVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate: SelectDashboardVCDelegate?
//    var arryDashboardTableObject: [DashboardTableObject]?
    var userStore: UserStore!
    var lblTitle = UILabel()
    var pickerDashboard = UIPickerView()
    var btnSubmit = UIButton()
    var vwSelectDashboard = UIView()

    init(){
//        self.userStore=userStore
        userStore = UserStore.shared
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.frame = UIScreen.main.bounds.inset(by: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        setupView()
        addTapGestureRecognizer()
        // Set the picker to the current dashboard position
        if let dashboardPos = userStore?.currentDashboardObjPos, dashboardPos < (userStore?.arryDashboardTableObjects.count ?? 0) {
            pickerDashboard.selectRow(dashboardPos, inComponent: 0, animated: false)
        }
    }

    private func setupView(){
        
        view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.6)
        vwSelectDashboard.backgroundColor = UIColor.systemBackground
        vwSelectDashboard.layer.cornerRadius = 12
        vwSelectDashboard.layer.borderColor = UIColor(named: "gray-500")?.cgColor
        vwSelectDashboard.layer.borderWidth = 2
        vwSelectDashboard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(vwSelectDashboard)
        vwSelectDashboard.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive=true
        vwSelectDashboard.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        vwSelectDashboard.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90).isActive=true
        vwSelectDashboard.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 20)).isActive=true
        
        // lblTitle setup
        lblTitle.text = " Select Your Dashboard "
        lblTitle.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        vwSelectDashboard.addSubview(lblTitle)
        lblTitle.centerXAnchor.constraint(equalTo: vwSelectDashboard.centerXAnchor).isActive = true
        lblTitle.topAnchor.constraint(equalTo: vwSelectDashboard.topAnchor, constant: heightFromPct(percent: 5)).isActive = true

        // pickerDashboard setup
        pickerDashboard.translatesAutoresizingMaskIntoConstraints = false
        vwSelectDashboard.addSubview(pickerDashboard)
        pickerDashboard.centerXAnchor.constraint(equalTo: vwSelectDashboard.centerXAnchor).isActive = true
        pickerDashboard.topAnchor.constraint(equalTo: lblTitle.bottomAnchor, constant: heightFromPct(percent: -0.5)).isActive = true
        pickerDashboard.heightAnchor.constraint(equalToConstant: heightFromPct(percent: 12)).isActive=true
        pickerDashboard.leadingAnchor.constraint(equalTo: vwSelectDashboard.leadingAnchor, constant: widthFromPct(percent: 0.5)).isActive=true
        pickerDashboard.trailingAnchor.constraint(equalTo: vwSelectDashboard.trailingAnchor, constant: widthFromPct(percent: -0.5)).isActive=true
        pickerDashboard.dataSource = self
        pickerDashboard.delegate = self

    }

    // UIPickerViewDataSource and UIPickerViewDelegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return userStore?.arryDashboardTableObjects.count ?? 0
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (userStore?.arryDashboardTableObjects[row]) != nil {
//        if let selectedDashboard = arryDashboardTableObject?[row] {
            delegate?.didSelectDashboard(currentDashboardObjPos: row)
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return arryDashboardTableObject?[row].dependentVarName
        return userStore?.arryDashboardTableObjects[row].dependentVarName
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

protocol SelectDashboardVCDelegate{
    func didSelectDashboard(currentDashboardObjPos: Int)
}





