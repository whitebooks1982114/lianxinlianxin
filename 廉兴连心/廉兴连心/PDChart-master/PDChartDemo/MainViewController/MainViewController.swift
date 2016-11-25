//
//  MainViewController.swift
//  Swift_iPhone_demo
//
//  Created by Pandara on 14-7-2.
//  Copyright (c) 2014年 Pandara. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView: UITableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    //MARK: Charts
    func getLineChart() -> PDLineChart {
        let dataItem: PDLineChartDataItem = PDLineChartDataItem()
        dataItem.xMax = 7.0
        dataItem.xInterval = 1.0
        dataItem.yMax = 100.0
        dataItem.yInterval = 10.0
        dataItem.pointArray = [CGPoint(x: 1.0, y: 95.0), CGPoint(x: 2.0, y: 25.0), CGPoint(x: 3.0, y: 30.0), CGPoint(x: 4.0, y:50.0), CGPoint(x: 5.0, y: 55.0), CGPoint(x: 6.0, y: 60.0), CGPoint(x: 7.0, y: 90.0)]
        dataItem.xAxesDegreeTexts = ["周日", "一", "二", "三", "四", "五", "周六"]
        dataItem.yAxesDegreeTexts = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
        
        let frameW = self.view.frame.size.width
        let lineChart: PDLineChart = PDLineChart(frame: CGRect(x: 0, y: 100, width: frameW, height: frameW), dataItem: dataItem)
        return lineChart
    }
    
    func getPieChart() -> PDPieChart {
        let dataItem: PDPieChartDataItem = PDPieChartDataItem()
        dataItem.pieWidth = 80
        dataItem.pieMargin = 50
        dataItem.dataArray = [PieDataItem(description: "first pie", color: lightGreen, percentage: 0.3),
                              PieDataItem(description: nil, color: middleGreen, percentage: 0.1),
                              PieDataItem(description: "third pie", color: deepGreen, percentage: 0.6)]
        
        let frameW = self.view.frame.size.width
        let pieChart: PDPieChart = PDPieChart(frame: CGRect(x: 0, y: 100, width: frameW, height: frameW), dataItem: dataItem)
        return pieChart
    }
    
    func getBarChart() -> PDBarChart {
        let dataItem: PDBarChartDataItem = PDBarChartDataItem()
        dataItem.xMax = 7.0
        dataItem.xInterval = 1.0
        dataItem.yMax = 100.0
        dataItem.yInterval = 10.0
        dataItem.barPointArray = [CGPoint(x: 1.0, y: 95.0), CGPoint(x: 2.0, y: 25.0), CGPoint(x: 3.0, y: 30.0), CGPoint(x: 4.0, y:50.0), CGPoint(x: 5.0, y: 55.0), CGPoint(x: 6.0, y: 60.0), CGPoint(x: 7.0, y: 90.0)]
        dataItem.xAxesDegreeTexts = ["周日", "一", "二", "三", "四", "五", "周六"]
        dataItem.yAxesDegreeTexts = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
        
        let frameW = self.view.frame.size.width
        let barChart: PDBarChart = PDBarChart(frame: CGRect(x: 0, y: 100, width: frameW, height: frameW), dataItem: dataItem)
        return barChart
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "cell") as UITableViewCell!
        if !(cell != nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        }
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "折线图 - line chart"
        case 1:
            cell.textLabel?.text = "饼状图 - pie chart"
        case 2:
            cell.textLabel?.text = "柱状图 - bar chart"
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewCon: UIViewController = UIViewController()
        viewCon.view.backgroundColor = UIColor.white
        
        var chart: PDChart!
        
        switch indexPath.row {
        case 0:
            let lineChart: PDLineChart = self.getLineChart()
            chart = lineChart
            viewCon.view.addSubview(lineChart)
        case 1:
            let pieChart: PDPieChart = self.getPieChart()
            chart = pieChart
            viewCon.view.addSubview(pieChart)
        case 2:
            let barChart: PDBarChart = self.getBarChart()
            chart = barChart
            viewCon.view.addSubview(barChart)
        default:
            break
        }
        
        chart.strokeChart()
        
        self.navigationController?.pushViewController(viewCon, animated: true)
    }
}



















