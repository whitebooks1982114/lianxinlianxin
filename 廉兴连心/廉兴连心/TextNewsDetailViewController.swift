//
//  TextNewsDetailViewController.swift
//  廉兴连心
//
//  Created by whitebooks on 17/1/30.
//  Copyright © 2017年 whitebooks. All rights reserved.
//

import UIKit

class TextNewsDetailViewController: UIViewController,UIScrollViewDelegate {

    var newsTitle:String!
    var newsContent:String!
   
    var titleLabel:UILabel!
    
   
    var contentLabel:UILabel!
    @IBOutlet weak var scroll: UIScrollView!
    
       
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "新闻详情"
       
      
    
        scroll.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.view.frame.height)
        scroll.backgroundColor = UIColor(patternImage: UIImage(named: "通知背景")!)
       
        scroll.delegate = self
       
    }
    
    func labelSize(text:String ,attributes : [NSObject : AnyObject]) -> CGRect{
        var size = CGRect();
        let size2 = CGSize(width: UIScreen.main.bounds.width - 20, height: 0);//设置label的最高宽度
        size = text.boundingRect(with: size2, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: attributes as? [String : AnyObject] , context: nil);
        return size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        for subview in scroll!.subviews {
            
            subview.removeFromSuperview()
            
        }
        
        titleLabel = UILabel(frame: CGRect(origin: CGPoint(x:10.0,y:40.0), size: CGSize(width: UIScreen.main.bounds.width - 20, height: 80.0)))
        self.titleLabel.text = self.newsTitle
        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.textAlignment = .center
       
        titleLabel.adjustsFontSizeToFitWidth = true
        self.scroll.addSubview(titleLabel)
        
        
        
        self.contentLabel = UILabel(frame: CGRect(x: 100.0, y: 70.0, width: 0, height: 0))
        self.contentLabel.text = self.newsContent
        self.contentLabel.numberOfLines = 0
        self.contentLabel.textAlignment = .left
        self.contentLabel.lineBreakMode = .byWordWrapping
        
        self.contentLabel.font = UIFont.systemFont(ofSize: 17)
        
        
        
        
        let text = (self.contentLabel?.text!)!
        let attributes = [NSFontAttributeName: self.contentLabel?.font!]//计算label的字体
        self.contentLabel.frame = self.labelSize(text: text, attributes: attributes as [NSObject : AnyObject])//调用计算label宽高的方法
        self.contentLabel.frame.origin.x = 10
        self.contentLabel.frame.origin.y = 130
        self.scroll.addSubview(self.contentLabel)
        scroll.contentSize = CGSize(width: UIScreen.main.bounds.width, height: self.contentLabel.frame.height + 200)
        
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
