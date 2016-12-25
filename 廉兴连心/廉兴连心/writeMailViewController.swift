//
//  writeMailViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/24.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class writeMailViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var myTitle: UITextField!
    
    @IBOutlet weak var contentText: UITextView!
   
    
    @IBAction func send(_ sender: UIButton) {
        if myTitle.text == "" || contentText.text == "" {
            let alert  = UIAlertController(title: "温馨提示", message: "标题内容不能为空", preferredStyle: .alert)
            let ok = UIAlertAction(title: "好", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)

        }else {
            let post = BmobObject(className: "report")
            post?.setObject(self.myTitle.text, forKey: "title")
            post?.setObject(self.contentText.text, forKey: "content")
            post?.setObject(false, forKey: "readed")
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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "写信"
        myTitle.delegate = self
        contentText.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        myTitle.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        myTitle.resignFirstResponder()
        contentText.resignFirstResponder()
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
