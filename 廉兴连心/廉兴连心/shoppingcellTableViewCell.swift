//
//  shoppingcellTableViewCell.swift
//  廉兴连心
//
//  Created by whitebooks on 17/2/25.
//  Copyright © 2017年 whitebooks. All rights reserved.
//

import UIKit

//代理：用于监听CELL中Button被点击,获取label内容等
protocol cellbuttonclick {
    func cellForRowButtonClicked(tableview: UITableView)
    //用于获取cell中的内容
    func getCellLabelContent(tableview:UITableView,cellIndexPath:IndexPath)
}

class shoppingcellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shopimage: UIImageView!
   
    @IBOutlet weak var shopname: UILabel!
    
    @IBOutlet weak var shopscore: UILabel!

   
    @IBOutlet weak var quantity: UILabel!
    //单位商品所需积分
    var perScore:Int!
    //数量
    var number:Int!

     var exchageNum = 0
    
    static var delegate:cellbuttonclick!
    
    
    @IBAction func add(_ sender: UIButton) {
        exchageNum = exchageNum + 1
        
        
        
        
        if exchageNum > number {
            exchageNum = number
            
        }else {
            userNeedScore = userNeedScore +  perScore
        }
         quantity.text = "\(String(exchageNum))"
        
        let myTable = superTableView()
        let indexpath = myTable?.indexPath(for: self)
        
        shoppingcellTableViewCell.delegate.cellForRowButtonClicked(tableview: myTable!)
        shoppingcellTableViewCell.delegate.getCellLabelContent(tableview: myTable!, cellIndexPath: indexpath!)
       
    }
    
    
    @IBAction func minus(_ sender: UIButton) {
        
        exchageNum = exchageNum - 1
        if exchageNum < 0 {
            exchageNum = 0
         
            
        }else {
            userNeedScore = userNeedScore -  perScore
            
        }
        quantity.text = "\(String(exchageNum))"
        let myTable = superTableView()
        let indexpath = myTable?.indexPath(for: self)
        
        
     shoppingcellTableViewCell.delegate.cellForRowButtonClicked(tableview: myTable!)
     shoppingcellTableViewCell.delegate.getCellLabelContent(tableview: myTable!, cellIndexPath: indexpath!)
        
    }
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        quantity.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UITableViewCell {
    //返回cell所在的UITableView
    func superTableView() -> UITableView? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let tableView = view as? UITableView {
                return tableView
            }
        }
        return nil
    }
}
extension UIView {
    //返回该view所在的父view
    func superView<T: UIView>(of: T.Type) -> T? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let father = view as? T {
                return father
            }
        }
        return nil
    }
}
