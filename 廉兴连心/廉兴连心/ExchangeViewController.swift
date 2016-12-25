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
    
    @IBAction func back(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirm(_ sender: UIButton) {
        
        if leftScore < 0 {
            let alert  = UIAlertController(title: "错误", message: "积分不足", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }else {
       
            let post  = BmobObject(outDataWithClassName: "userscore", objectId: self.scoreObjectId)
            post?.setObject(leftScore, forKey: "score")
            post?.updateInBackground(resultBlock: { (finish, error) in
                if error != nil {
                    let alart = UIAlertController(title: "温馨提示", message: "积分更新失败", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alart.addAction(ok)
                    self.present(alart, animated: true, completion: nil)
                }else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        }
        
    }
    
    @IBOutlet weak var scoreLeft: UILabel!
    
    @IBOutlet weak var exchange1: UITextField!
    
    @IBOutlet weak var exchange2: UITextField!
    @IBOutlet weak var exchange3: UITextField!
    
    @IBOutlet weak var exchange4: UITextField!
    
    
    @IBOutlet weak var exchange5: UITextField!
    var exchang1Num = 0
    var exchang2Num = 0
    var exchang3Num = 0
    var exchang4Num = 0
    var exchang5Num = 0

    
    var leftScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        exchange1.delegate = self
        exchange2.delegate = self
           exchange3.delegate = self
           exchange4.delegate = self
           exchange5.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        exchange1.text = "0"
         exchange2.text = "0"
         exchange3.text = "0"
         exchange4.text = "0"
         exchange5.text = "0"
        
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

    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        exchang1Num = Int (self.exchange1.text!)!
        exchang2Num = Int (self.exchange2.text!)!
        exchang3Num = Int (self.exchange3.text!)!
        exchang4Num = Int (self.exchange4.text!)!
        exchang5Num = Int (self.exchange5.text!)!
        
        leftScore = leftScore - (exchang1Num * 1 + exchang2Num * 2 + exchang3Num * 3 + exchang4Num * 4 + exchang5Num * 5 )
        
        scoreLeft.text = String(leftScore)
        
        
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
           
            }else {
                let alert  = UIAlertController(title: "提示", message: "保存失败", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        exchange1.resignFirstResponder()
        exchange2.resignFirstResponder()
        exchange3.resignFirstResponder()
        exchange4.resignFirstResponder()
        exchange5.resignFirstResponder()
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        exchange1.resignFirstResponder()
        exchange2.resignFirstResponder()
        exchange3.resignFirstResponder()
        exchange4.resignFirstResponder()
        exchange5.resignFirstResponder()
        return true
    }
}
