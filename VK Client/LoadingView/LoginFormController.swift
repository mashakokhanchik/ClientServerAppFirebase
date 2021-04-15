//
//  LoginFormController.swift
//  VK Client
//
//  Created by Мария Коханчик on 25.01.2021.
//

import UIKit

class LoginFormController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var loginInput: UITextField!
    @IBOutlet var passwordInput: UITextField!
    
    @IBOutlet var titleView: UILabel!
    @IBOutlet var loginTitleView: UILabel!
    @IBOutlet var passwordTitleView: UILabel!
    @IBOutlet weak var enterButton: UIButton!
    
    let networkService = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
        animateTitlesAppearing()
        animateTitleAppearing()
        animateFieldsAppearing()
        
    }
    @IBAction func loginButtomPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        let login = loginInput.text!
        let password = passwordInput.text!
        
        if login == "admin" && password == "1234" {
            print("Успешная авторизация")
        } else {
            print("Неуспешная авторизация")
        }
    }
    
    func animateTitlesAppearing() {
        let offset = view.bounds.width
        loginTitleView.transform = CGAffineTransform(translationX: -offset, y: 0)
        passwordTitleView.transform = CGAffineTransform(translationX: offset, y: 0)
        
        UIView.animate(withDuration: 1,
                       delay: 1,
                       options: .curveEaseOut,
                       animations: {
                            self.loginTitleView.transform = .identity
                            self.passwordTitleView.transform = .identity
                       },
                       completion: nil)
    }
    
    func animateTitleAppearing() {
        self.titleView.transform = CGAffineTransform(translationX: 0, y: -self.view.bounds.height/2)
        
        UIView.animate(withDuration: 1,
                       delay: 1,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        self.titleView.transform = .identity
                       },
                       completion: nil)
    }
    
    func animateFieldsAppearing() {
        let fadeInAnimation = CABasicAnimation(keyPath: "opasity")
        fadeInAnimation.fromValue = 0
        fadeInAnimation.toValue = 1
        fadeInAnimation.duration = 1
        fadeInAnimation.beginTime = CACurrentMediaTime() + 1
        fadeInAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        fadeInAnimation.fillMode = CAMediaTimingFillMode.backwards
        
        self.loginInput.layer.add(fadeInAnimation, forKey: nil)
        self.passwordInput.layer.add(fadeInAnimation, forKey: nil)
    }
    
    @objc func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        self.scrollView?.contentInset = contentInsets
        scrollView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        switch identifier {
        case "loginSegue":
            return checkUserData()
        default:
            return true
        }
    }

    func checkUserData() -> Bool {
        guard let login = loginInput.text, let password = passwordInput.text else { return false }
        if login == "admin" && password == "1234" {
            return true
        } else {
            showLoginError()
        }
        return false
    }
    
    func showLoginError() {
        let alert = UIAlertController(title: "Ошибка", message: "Введены не верные данные пользователя", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    /*
    
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

