//
//  SignInViewController.swift
//  ZerseyAssignment
//
//  Created by Naman Sharma on 30/06/20.
//  Copyright © 2020 Naman Sharma. All rights reserved.
//
import UIKit
import FirebaseAuth
import Firebase

class SignInViewController: UIViewController {

    
    let phoneTextField: UITextField = {
      let textField = UITextField()
      textField.placeholder = "Enter Phone No"
      textField.font = UIFont.boldSystemFont(ofSize: 18)
      textField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
      return textField
    }()
    
    var getOTPButton: UIButton {
        let button = UIButton(type: .system)
        button.setTitle("getOTP", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(getOTP), for: .touchUpInside)
        return button
    }
    
    
    
    
    @objc private func getOTP() {
        //OTP req
        
        let countryCode = "+91"
        
        let phoneNumber = countryCode + phoneTextField.text!
        
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
            if error == nil {
                guard let verifyId = verificationID else {return}
                let svc = OTPVC()
                svc.verificationId = verifyId
                self.navigationController?.pushViewController(svc, animated: true)
                
            }else {
                let alert = UIAlertController(title: "Error !", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("Unable to fetch verification ID from firebase", error!.localizedDescription)
            }
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let stackView = UIStackView(arrangedSubviews: [phoneTextField, getOTPButton])
        view.addSubview(stackView)
        stackView.spacing = 5
        stackView.axis = .vertical
        self.hideKeyboardWhenTappedAround()
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        getOTPButton.isEnabled = false
        getOTPButton.alpha = 0.5
    }

    @objc fileprivate func editingChanged() {
        if phoneTextField.text?.count == 10{
                getOTPButton.isEnabled = true
                getOTPButton.alpha = 1.0
        } else {
            getOTPButton.isEnabled = false
            getOTPButton.alpha = 0.5
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - 200
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

}
