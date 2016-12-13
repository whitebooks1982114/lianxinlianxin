//
//  signUpViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/7.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class signUpViewController: UIViewController,  UITextFieldDelegate{
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var passWord: UITextField!
    
    @IBOutlet weak var comfirmPassWord: UITextField!
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var chineseName: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "注册页面"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "注册", style:.plain, target: self, action: #selector(self.signup))
        
        userName.delegate = self
        passWord.delegate = self
        comfirmPassWord.delegate = self
        email.delegate = self
        chineseName.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.5, animations:{
            self.userName.resignFirstResponder()
            self.passWord.resignFirstResponder()
            self.comfirmPassWord.resignFirstResponder()
            self.email.resignFirstResponder()
            self.chineseName.resignFirstResponder()
        }
        
        
        )
        
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.userName.resignFirstResponder()
            self.passWord.resignFirstResponder()
            self.comfirmPassWord.resignFirstResponder()
            self.email.resignFirstResponder()
            self.chineseName.resignFirstResponder()
          
            
        })
        
          return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let frame: CGRect = chineseName.frame
        let offSet = frame.origin.y + 100 - (self.view.frame.size.height - 216)
        if offSet > 0 {
            UIView.animate(withDuration: 0.5, animations: { 
                self.view.frame = CGRect(x: 0, y: -offSet, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    
    
    func signup() {
        let user = BmobUser()
        
     
        user.username = userName.text
        user.password = passWord.text
        user.email = email.text
        user.setObject(chineseName.text, forKey: "chinesename")
        if (self.userName.text == "" || self.passWord.text == "" || self.comfirmPassWord.text == "" || self.email.text == "" || self.chineseName.text == "") {
            let alart = UIAlertController(title: "温馨提示", message: "您的注册信息填写不完整", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alart.addAction(ok)
            self.present(alart, animated: true, completion: nil)
            
        }else if (self.passWord.text != self.comfirmPassWord.text) {
            let alart1 = UIAlertController(title: "温馨提示", message: "两次密码填写不一致", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alart1.addAction(ok)
            self.present(alart1, animated: true, completion: nil)
            
        }else {
            user.signUpInBackground({ (success, error) in
                if success {
                    print("注册成功")
                    
                   _ = self.navigationController?.popToRootViewController(animated: true)
                    
                }else {
                    print("注册失败")
                    let alart2 = UIAlertController(title: "温馨提示", message: "用户名已存在", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alart2.addAction(ok)
                    self.present(alart2, animated: true, completion: nil)
                }
            })
            
        }
    
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
