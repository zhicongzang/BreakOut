//
//  DemoTableViewController.swift
//  BreakOut
//
//  Created by Zhicong Zang on 2/3/16.
//  Copyright © 2016 Zhicong Zang. All rights reserved.
//

import UIKit

class DemoTableViewController: UITableViewController, BreakOutToRefreshDelegate{
    
    var refreshView: BreakOutToRefreshView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshView = BreakOutToRefreshView(scrollView: tableView)
        refreshView.delegate = self
        refreshView.ballColor = UIColor.redColor()
        
        tableView.addSubview(refreshView)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("demo", forIndexPath: indexPath)
        
        cell.textLabel?.text = "Row: \(indexPath.row)"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            refreshView.endRefreshing()
        }
    }
    
    
    func refreshViewDidRefresh(refreshView: BreakOutToRefreshView) {
    }

}

extension DemoTableViewController {
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        refreshView.scrollViewDidScroll(scrollView)
    }
    
    override func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        refreshView.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        refreshView.scrollViewWillBeginDragging(scrollView)
    }

}










