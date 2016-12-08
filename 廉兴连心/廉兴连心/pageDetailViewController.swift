//
//  pageDetailViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 16/12/8.
//  Copyright © 2016年 whitebooks. All rights reserved.
//

import UIKit

class pageDetailViewController: UIViewController, UIScrollViewDelegate {
   
    var page = 0
    
    var selectedActivity: String?
    
    var perface: String?
   
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var myScroll: UIScrollView!
    @IBOutlet var myView: UIView!
    @IBAction func myTap(_ sender: UITapGestureRecognizer) {
        
        myQuery()
        page += 1
        
    }
    
    
    @IBAction func myPinch(_ sender: UIPinchGestureRecognizer) {
        
        if sender.state == .ended {
            sender.scale = 1.0
        }
        
        let _width = myScroll.bounds.width
        let _height = myScroll.bounds.height
      
        myScroll.bounds.size = CGSize(width: _width * sender.scale, height: _height * sender.scale)
    
    }
    
    
    func myQuery() {
        
        let query1 = BmobQuery(className: "works")
        let query2 = BmobQuery(className: "works")
        let main = BmobQuery(className: "works")
        query1?.whereKey("activity", equalTo: selectedActivity)
        query2?.whereKey("index", equalTo: page)
        main?.add(query1)
        main?.add(query2)
        main?.andOperation()
        main?.findObjectsInBackground({ (array, error) in
            if error != nil {
                print("\(error?.localizedDescription)")
            }
            if array != nil {
                for obj in array! {
                    let myObject = obj as! BmobObject
                    let myFile = myObject.object(forKey: "works") as! BmobFile
                    let myUrl = NSURL(string: myFile.url)
                    DispatchQueue.main.async {
                        let myData = NSData(contentsOf: myUrl as! URL)
                        let myImage = UIImage(data: myData as! Data)
                        self.myImageView.image = myImage
                       
                    }
                }
            }
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       myScroll.minimumZoomScale = 0.5
       myScroll.maximumZoomScale = 2.0
        myScroll.bounces = true
       myScroll.contentSize = CGSize(width: self.myView.frame.width * 1.5, height: self.myView.frame.height * 1.5)
        myScroll.delegate = self
       //重要否则无法缩放图片
        myScroll.isUserInteractionEnabled = true
        
        

        // Do any additional setup after loading the view.
    }
    //此方法重要，否则无法缩放图片
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return myImageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       myImageView.image = UIImage(named: perface!)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        page = 0
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
