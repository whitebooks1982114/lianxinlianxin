//
//  ExchangeViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/24.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class ExchangeViewController: UIViewController,UITextFieldDelegate {

    var scoreObjectId:String?
    var signScore:Int?
    var contriScore:Int?
    
    @IBOutlet weak var gift1: UILabel!
    
    @IBOutlet weak var gift2: UILabel!
    
    @IBOutlet weak var gift3: UILabel!
   
    @IBOutlet weak var gift4: UILabel!
    
    @IBOutlet weak var gift5: UILabel!
   
    @IBAction func addButton(_ sender: UIButton) {
        if sender.tag == 1{
            exchang1Num = exchang1Num! + 1
            exchange1.text = "\(String(exchang1Num))"
            leftScore = leftScore - 1
            self.scoreLeft.text = "\(leftScore)"
           
            
        }else if sender.tag == 2{
             exchang2Num = exchang2Num! + 1
            exchange2.text = "\(String(exchang2Num))"
            leftScore = leftScore - 2
            self.scoreLeft.text = "\(leftScore)"
        }else if sender.tag == 3{
             exchang3Num = exchang3Num! + 1
            exchange3.text = "\(String(exchang3Num))"
            leftScore = leftScore - 3
            self.scoreLeft.text = "\(leftScore)"
        }else if sender.tag == 4{
             exchang4Num = exchang4Num! + 1
            exchange4.text = "\(String(exchang4Num))"
            leftScore = leftScore - 4
            self.scoreLeft.text = "\(leftScore)"
        }else {
             exchang5Num = exchang5Num! + 1
            exchange5.text = "\(String(exchang5Num))"
            leftScore = leftScore - 5
            self.scoreLeft.text = "\(leftScore)"
        }
    }
    
    @IBAction func minusButton(_ sender: UIButton) {
        if sender.tag == 1{
            exchang1Num = exchang1Num! - 1
            if exchang1Num < 0 {
                exchang1Num = 0
                leftScore = leftScore + 0
            }else {
                leftScore = leftScore + 1
            }
            exchange1.text = "\(String(exchang1Num))"
           
            self.scoreLeft.text = "\(leftScore)"
            
        }else if sender.tag == 2{
            exchang2Num = exchang2Num! - 1
            if exchang2Num < 0 {
                exchang2Num = 0
                leftScore = leftScore + 0
            }else {
                leftScore = leftScore + 2
            }
            exchange2.text = "\(String(exchang2Num))"
    
            self.scoreLeft.text = "\(leftScore)"
        }else if sender.tag == 3{
            exchang3Num = exchang3Num! - 1
            if exchang3Num < 0 {
                exchang3Num = 0
                leftScore = leftScore + 0
            }else {
                leftScore = leftScore + 3
            }
            exchange3.text = "\(String(exchang3Num))"
         
            self.scoreLeft.text = "\(leftScore)"
        }else if sender.tag == 4{
            exchang4Num = exchang4Num! - 1
            if exchang4Num < 0 {
                exchang4Num = 0
                leftScore = leftScore + 0
            }else {
                leftScore = leftScore + 4
            }
            exchange4.text = "\(String(exchang4Num))"
         
            self.scoreLeft.text = "\(leftScore)"
            
        }else {
            exchang5Num = exchang5Num! - 1
            if exchang5Num < 0 {
                exchang5Num = 0
                leftScore = leftScore + 0
            }else {
                leftScore = leftScore + 5
            }
            exchange5.text = "\(String(exchang5Num))"
          
            self.scoreLeft.text = "\(leftScore)"
        }

    }
    

    
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        if leftScore < 0 {
            let alert  = UIAlertController(title: "错误", message: "积分不足", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else if leftScore < signScore! {
            let user = BmobUser.current()
            user?.setObject(leftScore, forKey: "score")
            user?.updateInBackground(resultBlock: { (success, error) in
                if error != nil {
                    print("\(error?.localizedDescription)")
                }
            })
            
        }else {
            
            let post  = BmobObject(outDataWithClassName: "userscore", objectId: self.scoreObjectId)
            post?.setObject(leftScore - signScore!, forKey: "score")
            post?.updateInBackground(resultBlock: { (finish, error) in
                if error != nil {
                    let alart = UIAlertController(title: "温馨提示", message: "积分更新失败", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alart.addAction(ok)
                    self.present(alart, animated: true, completion: nil)
                }else {
                    print("success")
                }
            })
            
        }
        
        
        let post = BmobObject(className: "gift")
        post?.setObject(exchang1Num, forKey: "quantity-1")
        post?.setObject(exchang2Num, forKey: "quantity-2")
        post?.setObject(exchang3Num, forKey: "quantity-3")
        post?.setObject(exchang4Num, forKey: "quantity-4")
        post?.setObject(exchang5Num, forKey: "quantity-5")
        
        let usr = BmobUser.current()
        let currentId = usr?.objectId
        let myAuthor = BmobUser(outDataWithClassName: "_User", objectId: currentId)
        
        post?.setObject(myAuthor, forKey: "author")
        
        post?.saveInBackground(resultBlock: { (success, error) in
            if success {
                print("success")
                self.dismiss(animated: true, completion: nil)
                
            }else {
                let alert  = UIAlertController(title: "提示", message: "保存失败", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
        })

        
    }
    
    @IBOutlet weak var scoreLeft: UILabel!
    
    @IBOutlet weak var exchange1: UITextField!
    
    @IBOutlet weak var exchange2: UITextField!
    @IBOutlet weak var exchange3: UITextField!
    
    @IBOutlet weak var exchange4: UITextField!
    
    
    @IBOutlet weak var exchange5: UITextField!
    var exchang1Num:Int!
    var exchang2Num:Int!
    var exchang3Num:Int!
    var exchang4Num:Int!
    var exchang5Num:Int!
    
    var leftScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exchange1.delegate = self
        exchange2.delegate = self
           exchange3.delegate = self
           exchange4.delegate = self
           exchange5.delegate = self
        
        gift1.adjustsFontSizeToFitWidth = true
        gift2.adjustsFontSizeToFitWidth = true
        gift3.adjustsFontSizeToFitWidth = true
        gift4.adjustsFontSizeToFitWidth = true
        gift5.adjustsFontSizeToFitWidth = true
       
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        exchange1.text = "0"
         exchange2.text = "0"
         exchange3.text = "0"
         exchange4.text = "0"
         exchange5.text = "0"
        exchang1Num = 0
        exchang2Num = 0
        exchang3Num = 0
        exchang4Num = 0
        exchang5Num = 0
        
        scoreLeft.text = String(leftScore)
        let nowUser = BmobUser.current()
        
        let userScoreQuery = BmobQuery(className: "userscore")
        userScoreQuery?.whereKey("author", equalTo: nowUser)
        userScoreQuery?.findObjectsInBackground({ (array, error) in
            if array != nil {
                for obj in array! {
                    let object = obj as! BmobObject
                    self.scoreObjectId = object.object(forKey: "objectId") as! String?
                }
            }else {
                
                print("\(error?.localizedDescription)")
            }
        })
        
    }

     
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   }
