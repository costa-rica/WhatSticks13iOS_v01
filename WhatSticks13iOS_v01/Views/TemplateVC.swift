//
//  TemplateVC.swift
//  TabBar07
//
//  Created by Nick Rodriguez on 28/06/2024.
//

import UIKit

class TemplateVC: UIViewController {
    
    let vwTopSafeBar = UIView()
    let vwTopBar = UIView()
//    let lblScreenName = UILabel()
    var lblAppMode = UILabel()
    var bottomConstraintVwTopSafeBar: NSLayoutConstraint!
    var bodySidePaddingPercentage = Float(5.0)
    var bodyTopPaddingPercentage = Float(20.0)
    var smallPaddingTop = heightFromPct(percent: 2)
    var smallPaddingSide = widthFromPct(percent: 2)
    var spinnerView: UIView?
    var activityIndicator:UIActivityIndicatorView!
    var lblMessage = UILabel()

    var isInitialViewController: Bool = false
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ColorAppBackground")
        navigationController?.setNavigationBarHidden(true, animated: false)// This seems to really hide the UINavigationBar
    }

    
    func setup_TopSafeBar(){
        vwTopSafeBar.backgroundColor = UIColor(named: "ColorTableTabModalBack")
        view.addSubview(vwTopSafeBar)
        vwTopSafeBar.translatesAutoresizingMaskIntoConstraints = false
        vwTopSafeBar.accessibilityIdentifier = "vwTopSafeBar"
        bottomConstraintVwTopSafeBar = vwTopSafeBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.075)
        NSLayoutConstraint.activate([
            vwTopSafeBar.topAnchor.constraint(equalTo: view.topAnchor),
            vwTopSafeBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            vwTopSafeBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraintVwTopSafeBar
        ])

    }
    func setupNonNormalMode(){
        if UserStore.shared.isInDevMode {
            lblAppMode.text = "Development"
            vwTopSafeBar.backgroundColor = .orange
            
            NSLayoutConstraint.deactivate([bottomConstraintVwTopSafeBar])
            bottomConstraintVwTopSafeBar = vwTopSafeBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        }
        else if UserStore.shared.isGuestMode {
            lblAppMode.text = "Guest"
            vwTopSafeBar.backgroundColor = UIColor(named:"ColorDevMode")
            NSLayoutConstraint.deactivate([bottomConstraintVwTopSafeBar])
            bottomConstraintVwTopSafeBar = vwTopSafeBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        }
        else {
            NSLayoutConstraint.deactivate([bottomConstraintVwTopSafeBar])
            bottomConstraintVwTopSafeBar = vwTopSafeBar.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.075)
        }
        
        lblAppMode.accessibilityIdentifier="lblAppMode"
        lblAppMode.font = UIFont(name: "ArialRoundedMTBold", size: 24)
        lblAppMode.translatesAutoresizingMaskIntoConstraints=false
        vwTopSafeBar.addSubview(lblAppMode)
        NSLayoutConstraint.activate([
            lblAppMode.bottomAnchor.constraint(equalTo: vwTopSafeBar.bottomAnchor,constant: heightFromPct(percent: -0.1)),
            lblAppMode.centerXAnchor.constraint(equalTo: vwTopSafeBar.centerXAnchor),
            bottomConstraintVwTopSafeBar
        ])
        
    }


    @objc func touchDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    // I want to delete
    func templateAlert(alertTitle:String = "Alert",alertMessage: String,  backScreen: Bool = false, dismissView:Bool = false) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        // This is used to go back
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.removeSpinner()
            if backScreen {
                self.navigationController?.popViewController(animated: true)
            }  else if dismissView {
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func templateAlert(alertTitle:String?,alertMessage:String?,completion: (() ->Void)?){
        
        let alert = UIAlertController(title: alertTitle ?? "", message: alertMessage ?? "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            completion?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func templateAlertMultipleChoice(alertTitle:String,alertMessage:String,choiceOne:String,choiceTwo:String, completion: ((String) -> Void)?){
        // Create the alert controller
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        // Add "Production" action
        let choiceOneAction = UIAlertAction(title: choiceOne, style: .default) { _ in
            // Call the completion handler with "Production"
            completion?(choiceOne)
        }
        
        // Add "Development" action
        let choiceTwoAction = UIAlertAction(title: choiceTwo, style: .default) { _ in
            // Call the completion handler with "Development"
            completion?(choiceTwo)
        }
        
        // Add the actions to the alert controller
        alertController.addAction(choiceOneAction)
        alertController.addAction(choiceTwoAction)
        
        // Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showSpinner() {
        print("- TemplateVC showSpinnner - ")
        spinnerView = UIView()
        spinnerView!.translatesAutoresizingMaskIntoConstraints = false
        spinnerView!.backgroundColor = UIColor(white: 0, alpha: 0.5)
        spinnerView!.accessibilityIdentifier = "spinnerView-TemplateVC"
        self.view.addSubview(spinnerView!)
        
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints=false
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)// makes spinner bigger
        activityIndicator.center = spinnerView!.center
        activityIndicator.startAnimating()
        spinnerView!.addSubview(activityIndicator)
        activityIndicator.accessibilityIdentifier = "activityIndicator"
        
        NSLayoutConstraint.activate([
            spinnerView!.topAnchor.constraint(equalTo: view.topAnchor),
            spinnerView!.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinnerView!.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spinnerView!.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: spinnerView!.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: spinnerView!.centerYAnchor),
        ])
    }
    func spinnerScreenLblMessage(message:String){
//        lblMessage.text = "This is a lot of data so it may take more than a minute"
        lblMessage.text = message
//        messageLabel.font = UIFont(name: "ArialRoundedMTBold", size: 20)
        lblMessage.numberOfLines = 0
        lblMessage.lineBreakMode = .byWordWrapping
        lblMessage.textColor = .white
        lblMessage.textAlignment = .center
//        lblMessage.frame = CGRect(x: 0, y: activityIndicator.frame.maxY + 20, width: spinnerView!.bounds.width, height: 50)
//        lblMessage.isHidden = true
        spinnerView?.addSubview(lblMessage)
        lblMessage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        lblMessage.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: heightFromPct(percent: 2)),
        lblMessage.leadingAnchor.constraint(equalTo: spinnerView!.leadingAnchor,constant: widthFromPct(percent: 5)),
        lblMessage.trailingAnchor.constraint(equalTo: spinnerView!.trailingAnchor,constant: widthFromPct(percent: -5)),
        ])
//      Timer to show the label after 3 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
//            self.messageLabel.isHidden = false
//        }
    }
    func removeSpinner() {
        spinnerView?.removeFromSuperview()
        spinnerView = nil
        print("removeSpinner() completed")
    }
    func removeLblMessage(){
        lblMessage.removeFromSuperview()
    }
    
    // Implement the delegate method
    func presentAlertController(_ alertController: UIAlertController) {
        present(alertController, animated: true, completion: nil)
    }
    func presentNewView(_ uiViewController: UIViewController) {
        present(uiViewController, animated: true, completion: nil)
    }

}
