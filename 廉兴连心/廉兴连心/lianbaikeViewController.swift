//
//  lianbaikeViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/4.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class lianbaikeViewController: UIViewController {
    @IBOutlet weak var usrmenu: UIBarButtonItem!
    
  
    

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
    
  override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let baikeDir = segue.destination as! baikeDirTableViewController
    let user = BmobUser.current()
    if segue.identifier == "dir" {
       
        if (user != nil) && (user?.object(forKey: "isadmin") as! Bool) {
        
        baikeDir.isAdmin = true
        }else {
            baikeDir.isAdmin = false
        }
    }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
