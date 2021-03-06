//
//  fogetPwdViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/7.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class fogetPwdViewController: UIViewController ,UITextFieldDelegate {
    
    @IBOutlet weak var email: UITextField!
 
    @IBAction func send(_ sender: UIButton) {
        if email.text == "" {
            let alart = UIAlertController(title: "温馨提示", message: "请输入电子邮箱地址", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alart.addAction(ok)
            self.present(alart, animated: true, completion: nil)
        }else {
            BmobUser.requestPasswordResetInBackground(withEmail: email.text)
            self.present((self.myStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController")), animated: true, completion: nil)
        }
        

    }
    
    
    let myStoryboard = UIStoryboard(name: "Main", bundle: nil)

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.5, animations: {
             self.email.resignFirstResponder()        })
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.email.resignFirstResponder()
        })
        
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        email.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
