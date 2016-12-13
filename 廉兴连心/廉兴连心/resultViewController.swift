//
//  resultViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/11.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class resultViewController: UIViewController {
    
    @IBOutlet weak var rightNum: UILabel!
    
    @IBOutlet weak var wrongNum: UILabel!
    
    @IBOutlet weak var result: UILabel!
    
    var rightresult:String = ""
    var wrongresult:String = ""
    var success: String = ""
    var clearedLevel:Int = 0
    
    let usr = BmobUser.current()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "答题结果"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(self.goBack))
        self.result.adjustsFontSizeToFitWidth = true
        
        
    }
    
    func goBack() {
       _ = navigationController?.popToRootViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.rightNum.text = rightresult
        self.wrongNum.text = wrongresult
        self.result.text = success
        if success == "恭喜你过关了" {
            self.result.textColor = UIColor.red
        }else if success == "很遗憾，您需要再努力" {
            self.result.textColor = UIColor.green
        }else {
            self.result.textColor = UIColor.orange
            self.result.isHighlighted = true
        }
        
      
        
        usr?.setObject(clearedLevel, forKey: "lianxinchuangguan")
        usr?.updateInBackground(resultBlock: { (success, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            }else {
                print("success")
            }
        })

    }
    
}
