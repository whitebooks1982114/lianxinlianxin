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
    //显示签到分数
    @IBOutlet weak var scoreLabel: UILabel!
    //得分动画view
    @IBOutlet weak var scoreView: UIView!
    
    
    
    //连续签到天数
    var contSignTimes: Int?
    //签到次数
    var signTimes: Int?
    //判断能否签到，一天只能签一次
    var date1:Date?
    var date2:Date?
    //判断是否连续签到
    var dateFlag:Bool?
    
    var totalScore:Int?
    
    
    
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
    //签到按钮输出口
    @IBOutlet weak var signOutLet: UIButton!
    //签到
    @IBAction func sign(_ sender: UIButton) {
          let usr = BmobUser.current()
        if usr == nil {
            let alart = UIAlertController(title: "温馨提示", message: "请先登录！", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alart.addAction(ok)
            self.present(alart, animated: true, completion: nil)
        }else {
           
            if self.signTimes == nil {
                self.signTimes = 1
            }else {
                self.signTimes = self.signTimes! + 1
            }
            if self.contSignTimes == nil {
                self.contSignTimes = 1
            }else{
                if dateFlag! {
                self.contSignTimes = self.contSignTimes! + 1
                }else {
                  self.contSignTimes = 1
                }
            }
            
            if self.totalScore == nil {
                self.totalScore = 1
            }else {
                if self.contSignTimes! <= 7 {
                self.totalScore = self.totalScore! + contSignTimes!
                }else{
                    self.totalScore = self.totalScore! + 7
                }
            }
       
           usr?.setObject(signTimes, forKey: "signtimes")
            usr?.setObject(totalScore, forKey: "score")
            usr?.setObject(contSignTimes, forKey: "contsigntimes")
           usr?.updateInBackground(resultBlock: { (success, error) in
            if success {
                  self.signOutLet.backgroundColor = UIColor.gray
                  self.signOutLet.isEnabled = false
                  self.date1 = Date()
                  UserDefaults.standard.set(self.date1, forKey: "signeddate")
                
            }else {
                print("error")
                let alart = UIAlertController(title: "温馨提示", message: "签到失败", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alart.addAction(ok)
                self.present(alart, animated: true, completion: nil)
            }
           })
            
            self.scoreView.isHidden = false
            self.scoreLabel.text = " + \(self.contSignTimes!)"
            self.scoreLabel.textColor = UIColor.red
            self.scoreView.backgroundColor = UIColor.clear
            self.scoreView.alpha = 1.0
            UIView.animate(withDuration: 1.0, delay: 0, options: [.curveLinear], animations: {
                self.scoreView.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
                self.scoreView.alpha = 0.0
                
            }, completion: nil)
            
            
        }
        
        
        
    }
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
        
        scoreView.isHidden = true
        
        date2 = Date()
       
        date1 = UserDefaults.standard.object(forKey: "signeddate") as! Date?
       
        dateFlag = Calendar.current.isDateInYesterday(date1!)
        if date1 != nil{
            if  Calendar.current.isDate(date1!, inSameDayAs: date2!) {
                self.signOutLet.isEnabled = false
                self.signOutLet.backgroundColor = UIColor.gray
            }else{
                self.signOutLet.isEnabled = true
                self.signOutLet.backgroundColor = UIColor.red
            }
        }else{
            self.signOutLet.isEnabled = true
            self.signOutLet.backgroundColor = UIColor.red
        }
        let nowuser = BmobUser.current()
        //加载用户名
        let currentUser = nowuser?.object(forKey: "username")
        if currentUser != nil {
            self.username?.text = currentUser as? String
        }else {
            self.username?.text = "用户名"
        }
        
        let currentSignTimes = nowuser?.object(forKey: "signtimes")
        let continuousSignedTimes = nowuser?.object(forKey: "contsigntimes")
        if currentSignTimes != nil {
            self.signTimes = currentSignTimes as! Int?
        }else {
            self.signTimes = 0
        }
        
        if continuousSignedTimes != nil {
            self.contSignTimes = continuousSignedTimes as! Int?
        }else {
            self.contSignTimes = 0
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
        //查询用户签到积分
        if nowuser != nil {
            self.totalScore = nowuser?.object(forKey: "score") as! Int?
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
