//
//  lianchuangguanViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/4.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit
//记录关卡信息
var allLevels = [1,0,0,0,0,0,0,0,0]

func write() {
    let ud = UserDefaults.standard
    for i in 0...8 {
        
        ud.set(allLevels[i], forKey: "level\(i + 1)")
    }
    
}





class lianchuangguanViewController: UIViewController {
  
    @IBOutlet weak var level3: UIImageView!
    @IBOutlet weak var level2: UIImageView!
    
    @IBOutlet weak var level1: UIImageView!
    
    @IBOutlet weak var level4: UIImageView!
    
    @IBOutlet weak var level5: UIImageView!
    
    
    @IBOutlet weak var level6: UIImageView!
    
    @IBOutlet weak var level7: UIImageView!
    
    @IBOutlet weak var level8: UIImageView!
    
    @IBOutlet weak var level9: UIImageView!
    
    
    @IBOutlet weak var button1: UIButton!
    
    @IBOutlet weak var button2: UIButton!
    
    @IBOutlet weak var button3: UIButton!
    
    @IBOutlet weak var button4: UIButton!
    
    
    @IBOutlet weak var button5: UIButton!
    
    
    @IBOutlet weak var button6: UIButton!
    
    
    @IBOutlet weak var button7: UIButton!
    
    @IBOutlet weak var button8: UIButton!
    
    
    @IBOutlet weak var button9: UIButton!
    
    
    
    
    let answer = answerViewController()
    //转场定制器
    var transferTimer : Timer? = nil
    
    //记录关卡视图数组
    var images = [UIImageView]()
       @IBAction func chooseLevel(_ sender: UIButton) {
        let btn = sender as UIButton
        let tag = btn.tag
        let usr = BmobUser.current()
        if usr == nil {
            let alart = UIAlertController(title: "温馨提示", message: "请您先登录", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alart.addAction(ok)
            self.present(alart, animated: true, completion: nil)
        }else{
            
            if allLevels[tag - 1] == 1 {
                
                let layer1 = images[tag-1].layer
                
                let scaleAnimate = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimate.fromValue = 1.0
                scaleAnimate.toValue = 1.5
                scaleAnimate.repeatCount = 1
                scaleAnimate.duration = 1.5
                scaleAnimate.autoreverses = true
                
                let opaAnimate = CABasicAnimation(keyPath: "opacity")
                opaAnimate.fromValue = 1.0
                opaAnimate.toValue = 0.0
                opaAnimate.autoreverses = true
                opaAnimate.repeatCount = 1
                opaAnimate.duration = 1.5
                
                layer1.add(scaleAnimate, forKey: "myscale")
                layer1.add(opaAnimate, forKey: "opa")
                answer.currentLevel = tag
                answer.currentQuestion = 10 * (tag - 1)
                //过1。5秒去转场，给动画留足时间
                transferTimer = Timer.scheduledTimer(timeInterval: 1.2, target: self, selector: #selector(self.transfer), userInfo: nil, repeats: false)
                
            }else {
                
                let alart = UIAlertController(title: "温馨提示", message: "请您先闯过上一关", preferredStyle: .alert)
                let okaction = UIAlertAction(title: "好", style: .cancel, handler: nil)
                alart.addAction(okaction)
                self.present(alart, animated: true, completion: nil)
            }
        }
        
    }
   
        //转场至答题界面
    func transfer() {
   
       
        self.navigationController?.pushViewController(answer, animated: true)
        
    }
  
    @IBOutlet weak var usrmenu: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            self.revealViewController().rearViewRevealWidth = 310
            self.revealViewController().toggleAnimationDuration = 0.5
            
            //侧拉到用户信息界面
            self.usrmenu.target = self.revealViewController()
            
            self.usrmenu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                 
            
        }


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       //如果用户未登陆，则读取本地通过数，如果用户登录则从网络读取用户通关数并进行更新
        let usr = BmobUser.current()
        let level = usr?.object(forKey: "lianxinchuangguan") as! Int
        
        
        if usr == nil {
        
        let ud = UserDefaults.standard
        for i  in 0...8 {
            allLevels[i] = ud.integer(forKey: "level\(i+1)")
        }
        
        allLevels[0] = 1
        } else {
            for i in 0...8 {
                if i <= level {
                    allLevels[i] = 1
                }
            }
        }
        
         let str = NSTemporaryDirectory()
        print(str)
        //组成关卡视图数组，完成动画
        images = [level1,level2,level3,level4,level5,level6,level7,level8,level9]
        //记录调整按钮状态
        let btns = [button1,button2,button3,button4,button5,button6,button7,button8,button9]
        
        for item in btns {
            if allLevels[(item?.tag)! - 1] == 1 {
                item?.setImage(nil, for: .normal)
            }
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
