//
//  userListTableViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/4.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class userListTableViewController: UITableViewController {
    //aboutUs实例化
    let aboutUs = aboutUsViewController()
    
    let userInfoChange = userInfoChangeViewController()
    
    let contribuionInfo = contributionInfoViewController()
    
    let setting = settingsViewController()
    
    
    
    @IBAction func turnSetting(_ sender: UITapGestureRecognizer) {
        let user = BmobUser.current()
        if user != nil {
        self.present(setting, animated: true, completion: nil)
        }else {
            let alert  = UIAlertController(title: "提示", message: "您尚未登录", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    @IBOutlet weak var avatar: UIImageView?
   
    @IBOutlet weak var username: UILabel?
    
    @IBOutlet weak var chinesename: UILabel?
    @IBAction func usrInfo(_ sender: UIButton) {
        self.present(userInfoChange, animated: true, completion: nil)
        
    }
    
    @IBAction func compInfo(_ sender: UIButton) {
        self.present(contribuionInfo, animated: true, completion: nil)
    }
    
    
    @IBAction func logOut(_ sender: UIButton) {
        BmobUser.logout()
        alarmArrayIsNotNull = false
        noticeArrayIsNotNull = false
   
    }
    
    
    @IBAction func aboutUs(_ sender: UIButton) {
        self.present(aboutUs, animated: true, completion: nil)
        
        
    }
    

    
    @IBOutlet weak var usrInfoOut: UIButton?
    
    @IBOutlet weak var compInfoOut: UIButton?
    
    @IBOutlet weak var logOutOut: UIButton?
  
    
    @IBOutlet weak var aboutUsOut: UIButton?
    
    @IBOutlet weak var reportOut: UIButton!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //按钮标题左对齐
        self.usrInfoOut?.contentHorizontalAlignment = .left
        self.compInfoOut?.contentHorizontalAlignment = .left
        self.logOutOut?.contentHorizontalAlignment = .left
        self.aboutUsOut?.contentHorizontalAlignment = .left
        self.reportOut.contentHorizontalAlignment = .left
        self.tableView.tableFooterView = UIView()
        self.tableView.tableFooterView?.backgroundColor = UIColor.black
        //使表头不与状态栏重叠
        self.tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        //设置分割线顶头
        self.tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //设置圆角
        self.avatar?.layer.masksToBounds = true
        self.avatar?.layer.cornerRadius = 8
        
        self.username?.adjustsFontSizeToFitWidth = true
  
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let nowuser = BmobUser.current()
        //加载用户名
        let currentUser = nowuser?.object(forKey: "username")
        if currentUser != nil {
            self.username?.text = currentUser as? String
        }else {
            self.username?.text = "用户名"
        }
       //加载中文名
        let currentChineseName = nowuser?.object(forKey: "chinesename")
        if currentChineseName != nil {
            self.chinesename?.text = currentChineseName as? String
        }else {
            self.chinesename?.text = "姓名"
        }
      
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let path = "\(rootPath)/pickedimage.jpg"
        
        if FileManager.default.fileExists(atPath: path) == false {
            self.avatar?.image = UIImage(named: "头像")
        }
        
        if nowuser != nil {
        
       
        
        self.avatar?.image = UIImage(contentsOfFile: path)
        
      
        } else {
            self.avatar?.image = UIImage(named: "头像")
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if section == 0 {
            return 1
        } else {
        
        return 5
        }
      
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "report") {
            let user = BmobUser.current()
            if user == nil {
                let alert  = UIAlertController(title: "提示", message: "您尚未登录", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
    }
    
      
}
