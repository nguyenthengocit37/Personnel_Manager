//
//  LoginController.swift
//  ManagerPersonel
//
//  Created by NGOC IT on 5/13/22.
//

import UIKit
import FirebaseAuth
import Toast_Swift

class LoginController: UIViewController {
    //MARK:Proterty
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBAction func btnLogin(_ sender: UIButton) {
        if(validateTextField()){
            Auth.auth().signIn(withEmail: tfEmail.text!, password: tfPassword.text!) { (result, error) in
                if error != nil {
                    self.view.makeToast("Sai Email hoac Mat khau",position:.top)
                }else{
                    self.view.makeToast("Login Succesfully",position:.top)
                    
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func validateTextField() -> Bool {
        let txtEmail = tfEmail.text
        let txtPassword = tfPassword.text
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isEmail = emailPred.evaluate(with: txtEmail)
        if(txtEmail!.isEmpty || txtPassword!.isEmpty){
            self.view.makeToast("Vui long nhap du cac truong",position: .top)
            return false
        }else if !isEmail{
            self.view.makeToast("Vui long nhap dung Email",position: .top)
            return false
        }else if txtPassword!.count < 6 {
            self.view.makeToast("Password chua it nhat 6 ky tu",position: .top)
            return false
        }
        return true;
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
