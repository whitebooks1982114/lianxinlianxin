//
//  contributionInfoViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/11.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class contributionInfoViewController: UIViewController {
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var SuccessLabel: UILabel!
   
    
    @IBOutlet weak var clearedLevel: UILabel!
    
    @IBOutlet weak var updatedKnowledge: UILabel!
    

    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
  

    override func viewDidLoad() {
        super.viewDidLoad()
        self.img.isHidden = true
        self.SuccessLabel.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
  
        
        let usr = BmobUser.current()
        if usr != nil{
        let usrname = (usr?.username)! as String
        let usrId = usr?.objectId
        let query = BmobQuery(className: "bake")
        let author = BmobUser(outDataWithClassName: "_User", objectId: usrId)
        query?.whereKey("author", equalTo: author)
        
        let level = usr?.object(forKey: "lianxinchuangguan") as? Int
        
            if level == nil {
              self.clearedLevel.text = "您未闯过任何关卡"
            }else {
    
            self.clearedLevel.text = "您已闯过了\((level!))关"
            self.clearedLevel.textColor = UIColor.orange
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
                        self.updatedKnowledge.text = "您上传了\(num)条内容"
                        self.updatedKnowledge.textColor = UIColor.magenta
                        
                    }
                }
                
            })
            if level == 9 {
           
                self.img.isHidden = false
                self.SuccessLabel.isHidden = false
                
                //出现闯关通关动画
                img.animationImages = [UIImage(named:"1")!,UIImage(named:"2")!,UIImage(named:"3")!,UIImage(named:"4")!,UIImage(named:"5")!,UIImage(named:"6")!,UIImage(named:"7")!]
                
                img.animationDuration = 2
                
                img.startAnimating()
                
                SuccessLabel.lineBreakMode = .byWordWrapping
                SuccessLabel.numberOfLines = 0
                SuccessLabel.textAlignment = .center
                SuccessLabel.textColor = UIColor.magenta
                SuccessLabel.text = "恭喜\(usrname)成功完成答题闯关任务"
                UIView.animate(withDuration: 2.0, delay: 0.0, options: [.autoreverse , .repeat], animations: {
                    self.SuccessLabel.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    
                }, completion: nil)
            } else {
                self.img.isHidden = true
                self.SuccessLabel.isHidden = true
            }
            
            
        }else {
            self.clearedLevel.text = "请您先登录"
            self.updatedKnowledge.text = "请您先登录"
        }
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
