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
        }
        
        
    }
    
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
        
        self.navigationItem.title = "重置密码"
        
        email.delegate = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
