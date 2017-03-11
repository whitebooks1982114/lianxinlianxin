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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        }
    
  override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    let user = BmobUser.current()
    if segue.identifier == "anli" {
         let baikeDir = segue.destination as! baikeDirTableViewController
         baikeDir.kind = "anli"
        if (user != nil) && (user?.object(forKey: "isadmin") as! Bool) {
          
        
        baikeDir.isAdmin = true
        }else {
            baikeDir.isAdmin = false
        }
    }
   
    if segue.identifier == "zhishi" {
         let baikeDir = segue.destination as! baikeDirTableViewController
        baikeDir.kind = "zhishi"
        
        if (user != nil) && (user?.object(forKey: "isadmin") as! Bool) {
            
            baikeDir.isAdmin = true
        }else {
            baikeDir.isAdmin = false
        }
    }
    if segue.identifier == "xinde" {
        let baikeDir = segue.destination as! baikeDirTableViewController
        baikeDir.kind = "xinde"
        
        if (user != nil) && (user?.object(forKey: "isadmin") as! Bool) {
            
            baikeDir.isAdmin = true
        }else {
            baikeDir.isAdmin = false
        }
    }
    if segue.identifier == "ketang" {
       _ = segue.destination as! MediaPerfaceCollectionViewController
        
       

    }
 }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
