//
//  SigninViewController.swift
//  HelloFirebaseChat
//
//  Created by Uran on 2018/4/11.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit
import Firebase

class SigninViewController: UIViewController {
    
    
    private var leadConstraint : CGFloat = 0
    private let notification = NotificationCenter.default
    /// 註冊訊息的背景 View
    let inputsContainView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        // 關閉 constraints
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        }()
    /// inputsContainView 的高度 constraint
    var inputsContainViewHeightAnchor : NSLayoutConstraint?
    /// inputsContainView 的中心Ｙ constraint
    var inputsContainViewCenterYAnchor : NSLayoutConstraint?
    var centY : CGFloat? = 0
    /// nameTextField 的高度 constraint
    var nameTextFieldHeightAnchor : NSLayoutConstraint?
    /// emailTextField 的高度 constraint
    var emailTextFieldHeightAnchor : NSLayoutConstraint?
    /// passwordTextField 的高度 constraint
    var passTextFieldHeightAnchor : NSLayoutConstraint?
    /// 暱稱輸入欄
    let nameTextField : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Name"
        textfield.layer.cornerRadius = 5
        textfield.layer.masksToBounds = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    /// 暱稱分隔 View
    let nameSparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// Email 輸入欄
    let emailTextField : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Email Address"
        textfield.layer.cornerRadius = 5
        textfield.layer.masksToBounds = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    /// Email 分隔 View
    let emailSparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    /// 密碼輸入欄
    let passwordTextField : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.layer.cornerRadius = 5
        textfield.layer.masksToBounds = true
        textfield.isSecureTextEntry = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    /// 登入/註冊按鈕
    let loginRegisterButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor(r: 80, g: 101, b: 161)
        button.setTitle("Register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(loginRegisterHandle(_:)), for: .touchUpInside)
        return button
    }()
    /// LogoImageView
    lazy var profileImageView : UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = UIColor.clear
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        imgView.image = UIImage(named: "sakura.jpg")
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.isUserInteractionEnabled = true
        // 讓 imageView 可以與使用者互動
        imgView.isUserInteractionEnabled = true
        
        return imgView
        
    }()
    
    /// 註冊或登入的 Segment
    let signInRegisterSegmentedController : UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Sign In","Register"])
        segment.selectedSegmentIndex = 1
        segment.tintColor = UIColor.white
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.addTarget( self, action: #selector(handleSignInRegister(_:)), for: .valueChanged)
        return segment
    }()
    @objc func handleSignInRegister(_ segment: UISegmentedControl){
        let title = signInRegisterSegmentedController.titleForSegment(at: signInRegisterSegmentedController.selectedSegmentIndex)
        self.loginRegisterButton.setTitle(title, for: .normal)
        // 隨者 SegmentController 改變 重新設定 inputContainView 高度Constraint 的值
        self.inputsContainViewHeightAnchor?.constant = self.signInRegisterSegmentedController.selectedSegmentIndex == 0 ? 100 : 150
        // 隨者 SegmentController 改變 重新設定 nameTextField 高度Constraint 的值
        self.nameTextFieldHeightAnchor?.isActive = false
        self.nameTextFieldHeightAnchor = self.nameTextField.heightAnchor.constraint(equalTo: self.inputsContainView.heightAnchor, multiplier: self.signInRegisterSegmentedController.selectedSegmentIndex == 0 ? 0 : 1/3)
        self.nameTextFieldHeightAnchor?.isActive = true
        // 隨者 SegmentController 改變 重新設定 emailTextField 高度Constraint 的值
        self.emailTextFieldHeightAnchor?.isActive = false
        self.emailTextFieldHeightAnchor = self.emailTextField.heightAnchor.constraint(equalTo: self.inputsContainView.heightAnchor, multiplier: self.signInRegisterSegmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        self.emailTextFieldHeightAnchor?.isActive = true
        // 隨者 SegmentController 改變 重新設定 passwordTextField 高度Constraint 的值
        self.passTextFieldHeightAnchor?.isActive = false
        self.passTextFieldHeightAnchor = self.passwordTextField.heightAnchor.constraint(equalTo: self.inputsContainView.heightAnchor, multiplier: self.signInRegisterSegmentedController.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        self.passTextFieldHeightAnchor?.isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(r: 61, g: 91, b: 151)
        
        self.notification.addObserver(self, selector: #selector(keyboardWillShow(note:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        self.notification.addObserver(self, selector: #selector(keyboardWillhide(note:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.view.addSubview(inputsContainView)
        self.view.addSubview(loginRegisterButton)
        self.view.addSubview(signInRegisterSegmentedController)
        self.view.addSubview(profileImageView)
        self.setInpustsCinstraint()
        self.setLoginRegisterButton()
        self.setSignInRegisterSegmentedController()
        self.setProfileImageView()
    }
    /// 顯示 Navigation Viewcontroller
    func presentChatNavigationVC(){
        // 跳轉到 登入頁面
        let bundle = Bundle(for: type(of: self))
        let mainStoryboard = UIStoryboard(name: "Main", bundle: bundle)
        let naviVC = mainStoryboard.instantiateViewController(withIdentifier: "ChatNaviViewController") as! ChatNaviViewController
        self.present(naviVC, animated: true, completion: {
            let signStoryBoard = UIStoryboard(name: "SigninStoryboard", bundle: bundle)
            let signVC = signStoryBoard.instantiateViewController(withIdentifier: "SigninViewController")
            signVC.dismiss(animated: false, completion: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: - 一些畫面的處理
extension SigninViewController{
    
    /// 設定 inputsContainView
    func setInpustsCinstraint(){
        // 設定 constraint
        // 將 View 放在畫面正中央
        inputsContainView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.inputsContainViewCenterYAnchor = inputsContainView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        self.inputsContainViewCenterYAnchor?.isActive = true
        self.centY = self.inputsContainViewCenterYAnchor?.constant
        
        // 距離左右 safearea 各 12
        inputsContainView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, constant: -24).isActive = true
        // 為了隨時改變高的 constraint 所以 HeightAnchor 要為全域變數
        self.inputsContainViewHeightAnchor = self.inputsContainView.heightAnchor.constraint(equalToConstant: 150)
        self.inputsContainViewHeightAnchor?.isActive = true
        
        self.inputsContainView.addSubview(self.nameTextField)
        self.setNameTextField()
        self.inputsContainView.addSubview(self.nameSparatorView)
        self.setNameSparatorView()
        self.inputsContainView.addSubview(self.emailTextField)
        self.setEmailTextField()
        self.inputsContainView.addSubview(self.emailSparatorView)
        self.setEmailSparatorView()
        self.inputsContainView.addSubview(self.passwordTextField)
        self.setPasswordTextField()
    }
    /// 設定 LoginRegisterButton
    func setLoginRegisterButton(){
        
        self.loginRegisterButton.topAnchor.constraint(equalTo: self.inputsContainView.bottomAnchor, constant: 12).isActive = true
        self.loginRegisterButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.loginRegisterButton.widthAnchor.constraint(equalTo: self.inputsContainView.widthAnchor).isActive = true
        self.loginRegisterButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    /// 設定 NameTextField
    func setNameTextField(){
        // 設定 nameTextField Constraint
        nameTextField.leftAnchor.constraint(equalTo: self.inputsContainView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: self.inputsContainView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: self.inputsContainView.widthAnchor).isActive = true
        // 設定 nameTextFieldHeightConstraint
        self.nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: self.inputsContainView.heightAnchor, multiplier: 1/3)
        self.nameTextFieldHeightAnchor?.isActive = true
        
    }
    /// 設定 nameSparatorView
    func setNameSparatorView(){
        // 設定 nameSparatorView Constraint
        nameSparatorView.leftAnchor.constraint(equalTo: self.inputsContainView.leftAnchor).isActive = true
        nameSparatorView.topAnchor.constraint(equalTo: self.nameTextField.bottomAnchor).isActive = true
        nameSparatorView.widthAnchor.constraint(equalTo: self.inputsContainView.widthAnchor).isActive = true
        nameSparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    /// 設定 EmailTextField
    func setEmailTextField(){
        // 設定 EmailTextField Constraint
        emailTextField.leftAnchor.constraint(equalTo: self.inputsContainView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: self.nameSparatorView.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: self.inputsContainView.widthAnchor).isActive = true
        // 用 全域變數 儲存 TextField 高度的 constraint
        self.emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: self.inputsContainView.heightAnchor, multiplier: 1/3)
        self.emailTextFieldHeightAnchor?.isActive = true
    }
    /// 設定 emailSparatorView
    func setEmailSparatorView(){
        // 設定 EmailSparatorView Constraint
        emailSparatorView.leftAnchor.constraint(equalTo: self.inputsContainView.leftAnchor).isActive = true
        emailSparatorView.topAnchor.constraint(equalTo: self.emailTextField.bottomAnchor).isActive = true
        emailSparatorView.widthAnchor.constraint(equalTo: self.inputsContainView.widthAnchor).isActive = true
        // 設定 Email 分隔線的高
        emailSparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    /// 設定 PasswordTextField
    func setPasswordTextField(){
        // 設定 PasswordTextField Constraint
        passwordTextField.leftAnchor.constraint(equalTo: self.inputsContainView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: self.emailSparatorView.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: self.inputsContainView.widthAnchor).isActive = true
        // 將高度 Constrant 設為 全域變數
        self.passTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: self.inputsContainView.heightAnchor, multiplier: 1/3)
        self.passTextFieldHeightAnchor?.isActive = true
    }
    /// 設定 ProfileImageView
    func setProfileImageView(){
        // 設定 ProfileImageView Constraint
        profileImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: self.signInRegisterSegmentedController.topAnchor
            , constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor .constraint(equalToConstant: 150).isActive = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSelectProfileImage))
        self.profileImageView.addGestureRecognizer(tapGesture)
    }
    
    
    /// 設定 SignInRegisterSegmentedController
    func setSignInRegisterSegmentedController(){
        signInRegisterSegmentedController.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        signInRegisterSegmentedController.bottomAnchor.constraint(equalTo: self.inputsContainView.topAnchor
            , constant: -12).isActive = true
        signInRegisterSegmentedController.widthAnchor.constraint(equalTo: self.inputsContainView.widthAnchor, multiplier: 0.5).isActive = true
        signInRegisterSegmentedController.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
}


    



// MARK: - 鍵盤升起下降 的 notification
extension SigninViewController{
    
    @objc func keyboardWillShow(note : Notification){
        guard let keyboardFrame: NSValue = note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else{
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardMinY = keyboardRectangle.minY
        
        let buttonMaxY = self.loginRegisterButton.frame.maxY
        let moveRange = buttonMaxY - keyboardMinY + 10
        self.inputsContainViewCenterYAnchor?.constant = self.centY! - moveRange
        
    }
    @objc func keyboardWillhide(note : Notification){
        UIView.animate(withDuration: 0.3) {
            self.inputsContainViewCenterYAnchor?.constant = self.centY!
        }
    }
}

extension UIColor {
    convenience init(r: CGFloat , g: CGFloat ,b: CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
