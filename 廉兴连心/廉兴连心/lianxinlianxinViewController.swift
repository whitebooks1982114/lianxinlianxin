//
//  lianxinlianxinViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/4.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit


class lianxinlianxinViewController: UIViewController {

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
            
         
            
            
            
        }
        
        

        // Do any additional setup after loading the view.
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
