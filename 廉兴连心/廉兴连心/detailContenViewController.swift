//
//  detailContenViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/13.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class detailContenViewController: UIViewController,UIScrollViewDelegate {
    
    var username:UILabel!
    var MyScroll:UIScrollView!
   

    
    var contentTitle:UILabel!
   
    var content:UILabel!

    var checkLabel:UILabel!
  
    
    var checkSwitch:UISwitch!
    
    var user:BmobUser?
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
    var updateScore:UIButton!
    //给用户加减分按钮
    func update(btn:UIButton) {
       
        exchangeScore = user?.object(forKey: "exscore") as! Int?
        
         let post  = BmobObject(outDataWithClassName: "userscore", objectId: self.scoreObjectId)
       // print(self.addScoreFlag)
        if self.addScoreFlag {
        self.score = self.score! + 5
            exchangeScore = exchangeScore! + 5
        }else {
           self.score = self.score! - 5
            exchangeScore = exchangeScore! - 5
        }
        if self.score! < 0 {
            self.score = 0
            exchangeScore = 0
        }
        
        
         post?.setObject(self.score, forKey: "score")
        post?.updateInBackground(resultBlock: { (finish, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误提示", message: "更新失败", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }else {
                let alert = UIAlertController(title: "提示", message: "已经更新了该用户可兑换积分", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: {
                    (ok)-> Void in
                    self.user?.setObject(self.exchangeScore, forKey: "exscore")
                    self.user?.updateInBackground(resultBlock: { (sccess, error) in
                        if error != nil {
                            print("\(error?.localizedDescription)")
                        }
                    })                })
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
    
    //用户可兑换积分
    var exchangeScore:Int?
   
    var scoreObjectId:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        MyScroll = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
      
        
        MyScroll.backgroundColor = UIColor(patternImage: UIImage(named: "通知背景")!)
      
        
        MyScroll.delegate = self
        checkLabel = UILabel(frame: CGRect(x: 20.0, y: 170.0, width: 100.0, height: 30.0))
        checkLabel.text = "审核按钮"
        checkSwitch = UISwitch(frame: CGRect(x: 140.0, y: 170.0, width: 51.0, height: 31.0))
        updateScore = UIButton(frame: CGRect(x: 200.0, y: 170.0, width: 100.0, height: 30.0))
        
          checkLabel.isHidden = true
          checkSwitch.isHidden = true
          updateScore.isHidden = true
        
        self.view.addSubview(MyScroll)
        MyScroll.addSubview(checkLabel)
        MyScroll.addSubview(checkSwitch)
        MyScroll.addSubview(updateScore)
      
        
    }
    func labelSize(text:String ,attributes : [NSObject : AnyObject]) -> CGRect{
        var size = CGRect();
        let size2 = CGSize(width: UIScreen.main.bounds.width - 40, height: 0);//设置label的最高宽度
        size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as? [String : AnyObject] , context: nil);
        return size
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        for subview in MyScroll!.subviews {
            
            subview.removeFromSuperview()
            
        }
        
        contentTitle = UILabel(frame: CGRect(x: 20.0, y: 40.0, width: UIScreen.main.bounds.width - 40, height: 30.0))
      
        username = UILabel(frame: CGRect(x: 20.0, y: 90.0, width: 200.0, height: 30.0))
        checkLabel = UILabel(frame: CGRect(x: 20.0, y: 150.0, width: 80.0, height: 30.0))
        checkLabel.text = "审核按钮"
        checkSwitch = UISwitch(frame: CGRect(x: 120.0, y: 150.0, width: 50.0, height: 30.0))
        updateScore = UIButton(frame: CGRect(x: 190.0, y: 150.0, width: UIScreen.main.bounds.width - 210, height: 30.0))
        updateScore.setTitleColor(UIColor.white, for: .normal)
        updateScore.setTitle( "更新用户积分", for: .normal)
        updateScore.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15.0)
        updateScore.backgroundColor = UIColor.blue
        updateScore.addTarget(self, action: #selector(update(btn:)), for: .touchUpInside)
        content = UILabel(frame: CGRect(x: 20.0, y: 200.0, width: 0, height: 0))
        
        contentTitle.adjustsFontSizeToFitWidth = true
        username.adjustsFontSizeToFitWidth = true
      
        MyScroll.addSubview(contentTitle)
        MyScroll.addSubview(username)
        MyScroll.addSubview(content)
        MyScroll.addSubview(checkLabel)
        MyScroll.addSubview(checkSwitch)
        MyScroll.addSubview(updateScore)

        
        
        
            user = BmobUser.current()
        if (user != nil) && (user?.object(forKey: "isadmin") as! Bool) {
            self.checkSwitch.isHidden = false
            self.checkLabel.isHidden = false
            self.updateScore.isHidden = false
        }else{
            self.checkSwitch.isHidden = true
            self.checkLabel.isHidden = true
            self.updateScore.isHidden = true
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
                            
                         
                        }
                        DispatchQueue.main.async{
                         
                           self.username.text = self.author
                            
                            if (self.checked != nil) && (self.checked!) {
                                self.checkSwitch.isOn = true
                            }else{
                                self.checkSwitch.isOn = false
                            }
                            self.myContent = content as! String
                            self.content.text = self.myContent
                            self.content.numberOfLines = 0
                            self.content.textAlignment = .left
                            self.content.lineBreakMode = .byWordWrapping
                            
                            self.content.font = UIFont.systemFont(ofSize: 17)
                            let text = (self.content?.text!)!
                            let attributes = [NSFontAttributeName: self.content?.font!]//计算label的字体
                            self.content.frame = self.labelSize(text: text, attributes: attributes as [NSObject : AnyObject])//调用计算label宽高的方法
                            self.content.frame.origin.x = 20
                            self.content.frame.origin.y = 200
                            self.MyScroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.content.frame.height + 200)
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


