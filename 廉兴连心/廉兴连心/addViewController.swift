//
//  addViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/11/14.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class addViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var addTitle: UITextField!
    
    @IBOutlet weak var addText: UITextView!
    
    let baike = baikeDirTableViewController()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "添加"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.done))
        
        self.addTitle.delegate = self
        self.addText.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func done() {
        
        if self.addText.text == "" || self.addTitle.text == "" {
            let alert  = UIAlertController(title: "温馨提示", message: "标题内容不能为空", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
            
        }else {
            
            let post = BmobObject(className: "bake")
            post?.setObject(self.addTitle.text, forKey: "liantitle")
            post?.setObject(self.addText.text, forKey: "content")
            
            let usr = BmobUser.current()
            let currentId = usr?.objectId
            let myAuthor = BmobUser(outDataWithClassName: "_User", objectId: currentId)
            post?.setObject(myAuthor, forKey: "author")
            
            post?.saveInBackground(resultBlock: { (success, error) in
                if success {
                    print("success")
                    _ = self.navigationController?.popViewController(animated: true)
                    
                    
                }else {
                    let alert  = UIAlertController(title: "提示", message: "保存失败", preferredStyle: .alert)
                    let ok = UIAlertAction(title: "好", style: .default, handler: nil)
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                    
                }
            })
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.addTitle.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.addText.resignFirstResponder()
        self.addText.resignFirstResponder()
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
