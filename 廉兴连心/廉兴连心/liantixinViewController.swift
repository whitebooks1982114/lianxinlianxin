//
//  liantixinViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/4.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit


class liantixinViewController: UIViewController  {
    @IBOutlet weak var usrmenu: UIBarButtonItem!
    
    @IBOutlet weak var noticeImage: UIImageView!
    
    @IBOutlet weak var alarmImage: UIImageView!
    
    @IBOutlet weak var noticeView: UIView!
    
    //点击监察目录按钮
    
    @IBAction func adminDir(_ sender: UIBarButtonItem) {
        let user = BmobUser.current()
        let isAdmin = user?.object(forKey: "isadmin") as? Bool
        if user == nil {
            let alert  = UIAlertController(title: "温馨提示", message: "对不起，您未登录", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)

        }else{
            if isAdmin == true {
                let adminDir = self.storyboard?.instantiateViewController(withIdentifier: "admindir") as! adminDirTableViewController
                
                self.navigationController?.pushViewController(adminDir, animated: true)
           
        }else {
                let alert  = UIAlertController(title: "温馨提示", message: "对不起，您不是纪检人员", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                 }
        
        }
    }
    
    
    @IBOutlet weak var alarmView: UIView!
    
    
    
    @IBOutlet weak var noticeLabel: UILabel!
    
    
    @IBOutlet weak var alarmLabel: UILabel!
    
  
  
    
    let masterpiece = masterPieceViewController()
    
    
    @IBAction func toNoticeDetail(_ sender: UITapGestureRecognizer) {
        let user = BmobUser.current()
        if user == nil {
            let alert  = UIAlertController(title: "温馨提示", message: "对不起，您未登录", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }else {
          UIApplication.shared.applicationIconBadgeNumber = 0
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewController(withIdentifier: "tongzhi") as! tongziTableViewController, animated: true)
        }
    }
    
    
    @IBAction func toAlarmDetail(_ sender: UITapGestureRecognizer) {
        let user = BmobUser.current()
        if user == nil {
            let alert  = UIAlertController(title: "温馨提示", message: "对不起，您未登录", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }else {
         UIApplication.shared.applicationIconBadgeNumber = 0
        self.navigationController?.pushViewController(self.storyboard?.instantiateViewController(withIdentifier: "tixin") as! tixinTableViewController, animated: true)
        }
    }
    
    @IBAction func showworks(_ sender: UITapGestureRecognizer) {
       
    }
    
    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "masterpiece" {
            let user = BmobUser.current()
            if user == nil {
                let alert  = UIAlertController(title: "温馨提示", message: "对不起，您未登录", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }else {
                
            _ = segue.destination as! masterPieceViewController
            }
            
        }
        
    }
       override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 310
            self.revealViewController().toggleAnimationDuration = 0.5
     
           
            self.usrmenu.target = self.revealViewController()
            
            self.usrmenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
            
           
            
        }
        
        
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
  
        
        if noticeArrayIsNotNull == true {
            
            self.noticeImage.image = #imageLiteral(resourceName: "newnotice")
            self.noticeLabel.textColor = UIColor.red
        }else{
            
            self.noticeImage.image = #imageLiteral(resourceName: "notice")
            self.noticeLabel.textColor = UIColor.black
        }
        
        if alarmArrayIsNotNull == true {
            
            self.alarmImage.image = #imageLiteral(resourceName: "newalarm")
            self.alarmLabel.textColor = UIColor.red
        }else{
            self.alarmImage.image = #imageLiteral(resourceName: "alarm")
            self.alarmLabel.textColor = UIColor.black
        }

        
    }
    
 
}
