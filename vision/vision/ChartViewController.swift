//
//  ChartViewController.swift
//  vision
//
//  Created by Jason Du on 2016-04-23.
//  Copyright © 2016 IBM Bluemix Developer Advocate Team. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController, ChartViewDelegate {

    @IBOutlet var barChart: BarChartView!
    
    var fishes:[String] = []
    var fishNum:[Double] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.delegate = self

        for fishData in sData.sharedInstance.party {
            if (fishes.indexOf(fishData.species) != nil) {
                fishNum[fishes.indexOf(fishData.species)!] += 1.0
            } else {
                fishes.append(fishData.species)
                fishNum.append(1.0)
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        setChart(fishes, values: fishNum)
    }

    func setChart(dataPoints:[String], values:[Double]){
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "")
        chartDataSet.colors = ChartColorTemplates.liberty()
        let chartData = BarChartData(xVals: fishes, dataSet: chartDataSet)
        barChart.descriptionText = ""
        barChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChart.data = chartData
        barChart.xAxis.labelTextColor = UIColor(red:0.09, green:0.66, blue:0.55, alpha:1.0)
        barChart.leftAxis.labelTextColor = UIColor(red:0.09, green:0.66, blue:0.55, alpha:1.0)
        barChart.rightAxis.enabled = false
        barChart.maxVisibleValueCount = 0
        barChart.legend.enabled = false
        barChart.xAxis.labelPosition = .Bottom
        barChart.scaleYEnabled = false
        barChart.highlightValue(xIndex: 0, dataSetIndex: 0, callDelegate: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func mainMenu(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion:nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
