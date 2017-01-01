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
        titleList.removeAll()
        let query = BmobQuery(className: "media")
        query?.order(byDescending: "updatedAt")
        query?.findObjectsInBackground({ (array, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "错误提示", message: "服务器连接失败", preferredStyle: .alert)
                let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                
            }else {
                for obj in array! {
                    
                    let detail = obj as! BmobObject
                    let listtitle = detail.object(forKey: "title") as! String
                    titleList.append(listtitle)
      
                }
                
            }
            
        })
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
       _ = segue.destination as! mediaCollectionViewController
        
       

    }
 }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

}
