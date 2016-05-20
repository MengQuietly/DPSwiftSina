//
//  MQBaseTableViewController.swift
//  MQSwiftSinaManager
//
//  Created by mengmeng on 16/5/20.
//  Copyright © 2016年 mengQuietly. All rights reserved.
//

import UIKit

class MQBaseTableViewController: UITableViewController {
    
    // 用户登录标记
    var userLoaon = false

    // 用户登录视图：每个控制器各自拥有自己的 visitorView
    // 提示：若使用懒加载，会在用户登录成功后，视图仍被创建，虽不影响执行，但会消耗内存
    // lazy var visitorView: VisitorLoginView = VisitorLoginView()
    var visitorView : MQVisitorLoginView?
    
    /// 若 view 不存在，系统就会再次调用 loadView
    override func loadView() {
        userLoaon ? super.loadView() : setupVistorView()
    }
    
    /// 设置访问视图
    private func setupVistorView(){
        visitorView = MQVisitorLoginView()
        view = visitorView // 替换根视图
        
        // 设置导航栏按钮
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(registerBtnClick))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(loginBtnClick))
        
        // 设置按钮监听方法
        visitorView?.registerBtn.addTarget(self, action: #selector(registerBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
        visitorView?.loginBtn.addTarget(self, action: #selector(loginBtnClick), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    @objc private func registerBtnClick(){
        printLog(#function)
    }
    
    @objc private func loginBtnClick(){
        printLog(#function)
        
        let navVC = UINavigationController(rootViewController: MQOAuthController())
        presentViewController(navVC, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
