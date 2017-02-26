//
//  contributionInfoViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/11.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class contributionInfoViewController: UIViewController {
    

    
    @IBOutlet weak var signedlevel: UILabel!
    
    
    @IBOutlet weak var updatedKnowledge: UILabel!
  
    @IBOutlet weak var totalScore: UILabel!
      
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var updateKnowledgeNum = 0
    var signTimes:Int!
    var userTotalScore:Int!
   
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
       
       
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
  
        
        let usr = BmobUser.current()
        if usr != nil{
   
        let usrId = usr?.objectId
        self.userTotalScore = usr?.object(forKey: "exscore") as? Int
            if userTotalScore == nil {
                userTotalScore = 0
            }
            totalScore.text = "\(String(self.userTotalScore))"
        let query = BmobQuery(className: "bake")
        let author = BmobUser(outDataWithClassName: "_User", objectId: usrId)
        query?.whereKey("author", equalTo: author)
            
        signTimes = usr?.object(forKey: "signtimes") as? Int
     
            if signTimes == nil {
              self.signedlevel.text = "0"
            }else {
            self.signedlevel.text = "\(String(self.signTimes))"
            self.signedlevel.textColor = UIColor.orange
            }
            query?.countObjectsInBackground({ (num, error) in
                if error != nil {
                    print("\(error?.localizedDescription)")
                    let alart = UIAlertController(title: "温馨提示", message: "连接服务器失败", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alart.addAction(ok)
                    self.present(alart, animated: true, completion: nil)
                    
                }else {
                    DispatchQueue.main.async {
                        print("success")
                        self.updateKnowledgeNum = Int(num)
                        self.updatedKnowledge.text = "您上传了\(num)条内容"
                        self.updatedKnowledge.textColor = UIColor.magenta
                        
                    }
                }
                
            })
            
            
        }else {
            self.signedlevel.text = "请您先登录"
            self.updatedKnowledge.text = "请您先登录"
            self.totalScore.text = "请您先登录"
        }
     
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
