//
//  logInViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/7.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class logInViewController: UIViewController , UITextFieldDelegate{
    let myStoryboard = UIStoryboard(name: "Main", bundle: nil)
   
   

    @IBOutlet weak var usrName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    @IBAction func signIn(_ sender: UIButton) {
        let usr = BmobUser.current()
        
        if usr == nil {
             self.present(self.myStoryboard.instantiateViewController(withIdentifier: "signup"), animated: true, completion: nil)
        }else {
            let alert  = UIAlertController(title: "提示", message: "您已登录", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }

       
    }

    @IBAction func forgetPassword(_ sender: UIButton) {
        self.present(self.myStoryboard.instantiateViewController(withIdentifier: "forget"), animated: true, completion: nil)
        
    }
 
    @IBAction func goBack(_ sender: UIButton) {
         self.present((self.myStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController")), animated: true, completion: nil)
        
    }
    
    @IBAction func logIn(_ sender: UIButton) {
        if (usrName.text == "" || passWord.text == "") {
            let alart = UIAlertController(title: "温馨提示", message: "请输入用户名或密码", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alart.addAction(ok)
            self.present(alart, animated: true, completion: nil)
            
        } else {
           BmobUser.loginInbackground(withAccount: usrName.text, andPassword: passWord.text, block: { (user, error) in
            if user != nil {
               
                let alart = UIAlertController(title: "提示", message: "登录成功", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: {(ok)->Void in
                 self.present((self.myStoryboard.instantiateViewController(withIdentifier: "SWRevealViewController")), animated: true, completion: nil)               })
                alart.addAction(ok)
                self.present(alart, animated: true, completion: nil)
              
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
        
    
            self.usrName.resignFirstResponder()
        
        if (usrName.text == "" || passWord.text == "") {
            let alart = UIAlertController(title: "温馨提示", message: "请输入用户名或密码", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alart.addAction(ok)
            self.present(alart, animated: true, completion: nil)
            
        } else {
            BmobUser.loginInbackground(withAccount: usrName.text, andPassword: passWord.text, block: { (user, error) in
                if user != nil {
                    let alart = UIAlertController(title: "提示", message: "注册成功", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: {(ok)->Void in
                        _ = self.navigationController?.popToRootViewController(animated: true)                })
                    alart.addAction(ok)
                    self.present(alart, animated: true, completion: nil)
                    

                } else {
                    let alart1 = UIAlertController(title: "温馨提示", message: "用户名或密码有误", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alart1.addAction(ok)
                    self.present(alart1, animated: true, completion: nil)
                }
            })
        }

        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
              
      
       
        usrName.delegate = self
        passWord.delegate = self
        
     
    }

   
      
    
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
 }
