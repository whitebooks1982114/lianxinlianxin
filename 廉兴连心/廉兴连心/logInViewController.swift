//
//  logInViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/7.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class logInViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var usrName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    
 
    
    @IBAction func logIn(_ sender: UIButton) {
        if (usrName.text == "" || passWord.text == "") {
            let alart = UIAlertController(title: "温馨提示", message: "请输入用户名或密码", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alart.addAction(ok)
            self.present(alart, animated: true, completion: nil)
            
        } else {
           BmobUser.loginInbackground(withAccount: usrName.text, andPassword: passWord.text, block: { (user, error) in
            if user != nil {
                print("登录成功")
               _ = self.navigationController?.popToRootViewController(animated: true)
            } else {
                let alart1 = UIAlertController(title: "温馨提示", message: "用户名或密码有误", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alart1.addAction(ok)
                self.present(alart1, animated: true, completion: nil)
            }
           })
            
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.usrName.resignFirstResponder()
            self.passWord.resignFirstResponder()
        })
       
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.usrName.resignFirstResponder()
            self.passWord.resignFirstResponder()
        })
       
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
               self.navigationItem.title = "登录"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "忘记密码", style: .plain, target: self , action: #selector(self.forget))
       
        usrName.delegate = self
        passWord.delegate = self
        
        // Do any additional setup after loading the view.
    }

    func forget() {
      
        self.navigationController?.pushViewController(fogetPwdViewController(), animated: true)
        
        
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
