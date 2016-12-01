//
//  settingsViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/30.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController {
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var noticeSwitch: UISwitch!
    
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    @IBAction func noticeVoiceSwitch(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "noticevoice")
            
        }else {
            
            UserDefaults.standard.set(false, forKey: "noticevoice")
            
        }
    }
    
    @IBAction func alarmVoiceSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "alarmvoice")
            
        }else {
            
            UserDefaults.standard.set(false, forKey: "alarmvoice")
            
        }

    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let currentNoticeSwitch = UserDefaults.standard.bool(forKey: "noticevoice")
        let currentAlarmSwitch = UserDefaults.standard.bool(forKey: "alarmvoice")
        
        if currentNoticeSwitch == false {
            noticeSwitch.isOn = false
        }else {
            noticeSwitch.isOn = true
        }
        
        if currentAlarmSwitch == false {
            alarmSwitch.isOn = false
        }else {
            alarmSwitch.isOn = true
        }

        
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
