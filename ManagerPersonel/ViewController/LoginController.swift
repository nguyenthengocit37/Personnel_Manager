//
//  LoginController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/13/22.
//

import UIKit
import FirebaseAuth
import Toast_Swift

class LoginController: UIViewController,UITextFieldDelegate {
    //MARK:Proterty
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup delegate
        tfEmail.delegate = self
        tfPassword.delegate = self
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfEmail.resignFirstResponder()
        return true
    }
    
    @IBAction func btnLogin(_ sender: UIButton) {
        //Handle Login
        if(validateTextField()){
            Auth.auth().signIn(withEmail: tfEmail.text!, password: tfPassword.text!) { (result, error) in
                if error != nil {
                    self.view.makeToast("Sai tài khoản hoặc mật khẩu",position:.top)
                }else{
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    if let nextViewController = storyBoard.instantiateViewController(withIdentifier: "mainviewcontroller") as? MainViewController{
                        self.present(nextViewController, animated:true, completion:nil)
                    }
                 
                    
                }
            }
        }
        
    }
    
    //MARK: Validate Data
    func validateTextField() -> Bool {
        let txtEmail = tfEmail.text
        let txtPassword = tfPassword.text
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isEmail = emailPred.evaluate(with: txtEmail)
        if(txtEmail!.isEmpty || txtPassword!.isEmpty){
            self.view.makeToast("Vui lòng nhập đủ các trường",position: .top)
            return false
        }else if !isEmail{
            self.view.makeToast("Vui lòng nhập đúng địa chỉ email",position: .top)
            return false
        }else if txtPassword!.count < 6 {
            self.view.makeToast("Password phải chứa ít nhất 6 ký tự",position: .top)
            return false
        }
        return true;
    }

    
     //MARK: - Navigation

     //In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//      
//    }
    

}
