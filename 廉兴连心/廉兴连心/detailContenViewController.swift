//
//  detailContenViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/13.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class detailContenViewController: UIViewController {
    @IBOutlet weak var content: UITextView!
    
    @IBOutlet weak var contentTitle: UILabel!

    @IBOutlet weak var checkLabel: UILabel!
    
   
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var checkSwitch: UISwitch!
    
    
    func getCurrentScore() {
        let userScoreQuery = BmobQuery(className: "userscore")
        userScoreQuery?.whereKey("author", equalTo: self.myAuthor)
        userScoreQuery?.findObjectsInBackground({ (array, error) in
            if array != nil {
                for obj in array! {
                    let object = obj as! BmobObject
                    self.scoreObjectId = object.object(forKey: "objectId") as! String?
                    
                    self.score = object.object(forKey: "score") as? Int
                    
                }
            }else {
                
                print("\(error?.localizedDescription)")
            }
        })
     
    }
    @IBAction func check(_ sender: UISwitch) {
        let dataObject = BmobObject(outDataWithClassName: "bake", objectId: myObjectId)
       
       //  print(myAuthor)
        getCurrentScore()
        if sender.isOn {
           
            dataObject?.setObject(true, forKey: "check")
            if self.score != nil {
              self.addScoreFlag = true
            }else {
                self.score = 0
                self.addScoreFlag = true
            }
           
            }else {
            
            dataObject?.setObject(false, forKey: "check")
            if (self.score != nil) && (self.score! >= 5 ) {
                self.addScoreFlag = false
 
            }else {
                self.score = 0
               
            }
   
        }
        
        dataObject?.updateInBackground(resultBlock: { (finish, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误提示", message: "服务器连接失败", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        })
        
       
        
    }
    @IBOutlet weak var updateScoreOutlet: UIButton!
    //给用户加减分按钮
    @IBAction func UpdateScore(_ sender: UIButton) {
       // print("\(self.score)")
         let post  = BmobObject(outDataWithClassName: "userscore", objectId: self.scoreObjectId)
       // print(self.addScoreFlag)
        if self.addScoreFlag {
        self.score = self.score! + 5
        }else {
           self.score = self.score! - 5
        }
        if self.score! < 0 {
            self.score = 0
        }
        
         post?.setObject(self.score, forKey: "score")
        post?.updateInBackground(resultBlock: { (finish, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误提示", message: "更新失败", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        })
        
      _ = self.navigationController?.popViewController(animated: true)
    }
    
    var myContent: String!
    var author: String!
    var mytitle: String!
    var myObjectId: String!
    var isAdmin: Bool!
    var score: Int?
    var userid:String!
    var myAuthor:BmobUser?
    var checked: Bool?
    var addScoreFlag = false
   
    var scoreObjectId:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTitle.adjustsFontSizeToFitWidth = true
        username.adjustsFontSizeToFitWidth = true
        content.backgroundColor = UIColor.clear
        
        checkLabel.isHidden = true
        checkSwitch.isHidden = true
        updateScoreOutlet.isHidden = true
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.content.text = ""
        
        let user = BmobUser.current()
        if (user != nil) && (user?.object(forKey: "isadmin") as! Bool) {
            self.checkSwitch.isHidden = false
            self.checkLabel.isHidden = false
            self.updateScoreOutlet.isHidden = false
        }else{
            self.checkSwitch.isHidden = true
            self.checkLabel.isHidden = true
            self.updateScoreOutlet.isHidden = true
        }
   
        self.contentTitle.text = mytitle
        
        let query = BmobQuery(className: "bake")
        query?.whereKey("liantitle", equalTo: self.mytitle)
        
        query?.findObjectsInBackground({ (array, error) in
            
            
            if array != nil {
                for obj in array! {

                    let selectedObject = obj as! BmobObject
                    let content = selectedObject.object(forKey: "content")
                    self.myObjectId = selectedObject.objectId
                    self.checked = selectedObject.object(forKey: "check") as! Bool?
                    
                    query?.includeKey("author")
                    query?.getObjectInBackground(withId: self.myObjectId, block: { (obj, error) in
                        if let usr = obj?.object(forKey: "author") {
                            self.myAuthor = usr as? BmobUser
                            self.author = self.myAuthor?.username
                            self.isAdmin = self.myAuthor?.object(forKey: "isadmin") as! Bool
                      
                            self.userid = self.myAuthor?.objectId
                            
                            DispatchQueue.main.async{
                                self.username.text = self.author
                              
                                if (self.checked != nil) && (self.checked!) {
                                    self.checkSwitch.isOn = true
                                }else{
                                    self.checkSwitch.isOn = false
                                }
                                self.myContent = content as! String
                               self.content.text = self.myContent
                              
                            }
                        }
                        
                        
                    })
         
                }
                
            } else {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误提示", message: "服务器连接失败", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        })
      
      
    
    }


}


