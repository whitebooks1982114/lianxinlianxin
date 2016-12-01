//
//  lianxinlianxinViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/4.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit
import AVFoundation



class lianxinlianxinViewController: UIViewController {
    //判断用户是否关闭提醒音效
    var noticeVoiceOn: Bool = true
    
    
    var alarmVoiceOn: Bool = true
    

    
    var player: AVAudioPlayer?
    
    var myUrl: URL?

    @IBOutlet weak var usrmenu: UIBarButtonItem!
    
    @IBOutlet weak var brandIntro: UILabel!
    
    @IBAction func signUp(_ sender: UIButton) {
        
        let usr = BmobUser.current()
        
        if usr == nil {
       
        self.navigationController?.pushViewController(signUpViewController(), animated: true)
        }else {
            let alert  = UIAlertController(title: "提示", message: "您已登录", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    @IBAction func logIn(_ sender: UIButton) {
        let usr = BmobUser.current()
        
        if usr == nil {
        
        self.navigationController?.pushViewController(logInViewController(), animated: true)
        }else {
        let alert  = UIAlertController(title: "提示", message: "您已登录", preferredStyle: .alert)
        let ok = UIAlertAction(title: "好", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
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
            
                //自适应宽度
            self.brandIntro.adjustsFontSizeToFitWidth = true
            
           let path = Bundle.main.path(forResource: "提醒音效", ofType: "mp3")
            myUrl = URL(fileURLWithPath: path!)
      
        }
        
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
      noticeVoiceOn = UserDefaults.standard.bool(forKey: "noticevoice")
  
        
      alarmVoiceOn = UserDefaults.standard.bool(forKey: "alarmvoice")
        
        
        let currentDay = Date()
        
        let nextDay = currentDay.addingTimeInterval(56*60*60)
        let chinaDay = currentDay.addingTimeInterval(8*60*60)
        let user = BmobUser.current()
        if user != nil {
            //查询马上到期的通知，并发出音效
     
            let query = BmobQuery(className: "notice")
            let noticeInQuery = BmobUser.query()
            let userName = user?.username
         
            noticeInQuery?.whereKey("username", equalTo: userName)
            query?.whereKey("relation", matchesQuery: noticeInQuery)
            let query1 = BmobQuery(className: "notice")
            query1?.whereKey("deadline", lessThan: nextDay)
            let quer2 = BmobQuery(className: "notice")
            quer2?.whereKey("deadline", greaterThan: chinaDay)
            let main = BmobQuery(className: "notice")
            main?.add(quer2)
            main?.add(query1)
            main?.add(query)
            main?.andOperation()
            main?.findObjectsInBackground({ (array, error) in
                if array != nil {
                    if self.noticeVoiceOn == true {
                        if self.player == nil{
                            do{
                                try  self.player = AVAudioPlayer(contentsOf: self.myUrl!)
                                self.player?.prepareToPlay()
                                self.player?.numberOfLoops = 1
                            }catch {
                                print(error)
                            }
                            
                        }
                        if self.player?.isPlaying == false {
                            self.player?.play()
                        }
                    }
                    noticeArrayIsNull = true
                }
                if error != nil {
                    print("\(error?.localizedDescription)")
                }
                
            })
 
            
            //查询马上到期提醒事项，并发出音效
           
            let queryAlarm = BmobQuery(className: "alarm")
            let id = user?.objectId
            let author = BmobUser(outDataWithClassName: "_User", objectId: id)
            queryAlarm?.whereKey("author", equalTo: author)
            let queryAlarm1 = BmobQuery(className: "alarm")
            queryAlarm1?.whereKey("deadLine", lessThan: nextDay)
            let querAlarm2 = BmobQuery(className: "alarm")
            querAlarm2?.whereKey("deadLine", greaterThan: chinaDay)
            let mainAlarm = BmobQuery(className: "alarm")
            mainAlarm?.add(queryAlarm)
            mainAlarm?.add(queryAlarm1)
            mainAlarm?.add(querAlarm2)
            mainAlarm?.andOperation()
            mainAlarm?.findObjectsInBackground({ (array, error) in
                if array != nil {
                  
                    for _ in array! {
                       
                        if self.alarmVoiceOn == true {
                        if self.player == nil{
                            do{
                                try  self.player = AVAudioPlayer(contentsOf: self.myUrl!)
                                self.player?.prepareToPlay()
                                self.player?.numberOfLoops = 1
                            }catch {
                                print(error)
                            }
                            
                        }
                        if self.player?.isPlaying == false {
                            self.player?.play()
                        }
                    }
                    alarmArrayIsNull = true
                    }
                }
              
                if error != nil {
                    print("\(error?.localizedDescription)")
                }
                

            })
            
           
        }
     
    }
    
    
      
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
      
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
