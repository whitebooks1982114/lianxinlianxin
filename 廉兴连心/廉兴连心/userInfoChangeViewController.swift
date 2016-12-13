//
//  userInfoChangeViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/8.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class userInfoChangeViewController: UIViewController , UITextFieldDelegate ,UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
    //部门输入框
    @IBOutlet weak var myDepartment: UITextField!
    //电话输入框
    @IBOutlet weak var phoneNumber: UITextField!
 
    //头像
    @IBOutlet weak var avatar: UIImageView!
    
    //活动指示器
    @IBOutlet weak var activity: UIActivityIndicatorView!
    //当前用户名
    @IBOutlet weak var currentName: UILabel!
    //更新用户名
    @IBOutlet weak var newName: UITextField!
    //编辑头像按钮
    @IBAction func editAvatar(_ sender: UIButton) {
        let imPicker = UIImagePickerController()
        imPicker.sourceType = .photoLibrary
        imPicker.delegate = self
        present(imPicker, animated: true, completion: nil)
        
        
    }
    //保存按钮
    @IBAction func save(_ sender: UIBarButtonItem) {
        let usr = BmobUser.current()
        if usr == nil {
            let alart = UIAlertController(title: "温馨提示", message: "请先登录！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alart.addAction(ok)
            self.present(alart, animated: true, completion: nil)        }
        usr?.setObject(self.newName.text! as String, forKey: "username")
        usr?.setObject(self.phoneNumber.text! as String, forKey: "mobilePhoneNumber")
        usr?.setObject(self.myDepartment.text! as String, forKey: "department")
        usr?.updateInBackground(resultBlock: { (success, error) in
            if success {
                print("sccess")
                let alart = UIAlertController(title: "信息", message: "恭喜更新成功！", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alart.addAction(ok)
                self.present(alart, animated: true, completion: nil)
            }else {
                print("error")
                let alart = UIAlertController(title: "温馨提示", message: "更新信息有误", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alart.addAction(ok)
                self.present(alart, animated: true, completion: nil)
            }
        })
    }
    //返回按钮
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    //部门选择器
    @IBOutlet weak var departmentPicker: UIPickerView!
    //工具条
    @IBOutlet weak var departToolBar: UIToolbar!
    //工具条完成按钮
    @IBAction func done(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .transitionCurlDown, animations:{
            self.myDepartment.endEditing(true)
            self.myDepartment.resignFirstResponder()
        }, completion: nil)
      
   
    }
 
    //部门数组
    var departmentArray: NSArray?
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 8
        
        let path = Bundle.main.path(forResource: "department", ofType: "plist")
        
        departmentArray = NSArray(contentsOfFile: path!)
        
        myDepartment.delegate = self
        phoneNumber.delegate = self
        newName.delegate = self
        departmentPicker.delegate = self
        
        departmentPicker.removeFromSuperview()
        departToolBar.removeFromSuperview()
        
        myDepartment.inputView = departmentPicker
        myDepartment.inputAccessoryView = departToolBar
 
    }
    //保存用户选择的图片至本地
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        avatar.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        let myfileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                           .userDomainMask, true)[0] as String
        let filePath = "\(rootPath)/pickedimage.jpg"
        let imageData = UIImageJPEGRepresentation(avatar.image!, 1.0)
        myfileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        
       
            
            
            /*if (myfileManager.fileExists(atPath: filePath)){
            let usr = BmobUser.current()
            
            let objId = usr?.objectId as? String
            
            let usrAvatar = BmobObject(className: "avatar")
        
            let file  = BmobFile(filePath: filePath)
            
            let author = BmobUser(outDataWithClassName: "_User", objectId: objId)
            
            
            let op = BlockOperation(block: {
               
                file?.save(inBackground: { (ok, error) in
                    if ok {
                        usrAvatar?.setObject(file, forKey: "avatar")
                        usrAvatar?.setObject(author, forKey: "author")
                        usrAvatar?.saveInBackground(resultBlock: { (success, error) in
                            if error != nil {
                                print("error")
                            }
                        })
                    }
                }, withProgressBlock: { (progress) in
                    print( (progress))
                    if progress < 1.0 {
                        self.activity.startAnimating()
                        self.activity.isHidden = false
                    } else if progress == 1.0 {
                        self.activity.stopAnimating()
                        self.activity.isHidden = true
                    }
                    
                    
                })
                
            })
            let queue = OperationQueue()
            
            queue.addOperation(op)
    
            
        } */
       self.dismiss(animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.animate(withDuration: 0.5, animations: {
            self.phoneNumber.resignFirstResponder()
            self.myDepartment.resignFirstResponder()
            self.newName.resignFirstResponder()
            
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.phoneNumber.resignFirstResponder()
        self.newName.resignFirstResponder()
        return true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (departmentArray?.count)!
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.departmentArray?[row] as? String
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.myDepartment.text = self.departmentArray?[row] as? String
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let usr = BmobUser.current()
        //获取用户名
        let currentUser = usr?.object(forKey: "username")
        if currentUser != nil {
            currentName.text = currentUser as? String
        }else {
            
            currentName.text = "用户名"
        }
        let newUserName = usr?.object(forKey: "username")
        if newUserName != nil {
            newName.text = newUserName as? String
        }else {
            newName.text = ""
        }
        
        //获取电话号码
        let currentPhone = usr?.object(forKey: "mobilePhoneNumber")
        if currentPhone != nil {
            phoneNumber.text = currentPhone as? String
            
        }else {
            phoneNumber.text = ""
        }
        
        //获取部门信息
        let currentDepartment = usr?.object(forKey: "department")
        if currentDepartment != nil {
            myDepartment.text = currentDepartment as? String
        }else {
            myDepartment.text = ""
        }
        
        
        
    }
    
    // 5S 里面键盘遮住了输入框，所有以下代码用于使输入框上移可见
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let frame: CGRect = myDepartment.frame
        
        let offset = frame.origin.y + 100 - (self.view.frame.size.height - 240)
        
        if offset > 0 {
            UIView.animate(withDuration: 0.8, animations: {
                self.view.frame = CGRect(x: 0, y: -offset, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
