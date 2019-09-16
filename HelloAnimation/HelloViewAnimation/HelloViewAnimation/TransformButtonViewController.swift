//
//  TransformButtonViewController.swift
//  HelloViewAnimation
//
//  Created by Uran on 2018/7/3.
//  Copyright © 2018年 Uran. All rights reserved.
//

import UIKit

class TransformButtonViewController: UITableViewController,UIPopoverPresentationControllerDelegate {
    let cellID = "TransformTableCell"
    var nums : [Int] = {
        var nums = [Int]()
        for num in 0..<100{
            nums.append(num)
        }
        return nums
    }()
    var selectIndexPath = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TransformTableCell", bundle: bundle)
        self.tableView.register(nib, forCellReuseIdentifier: cellID)
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return nums.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! TransformTableCell

        let num = self.nums[indexPath.row]
        cell.textLabel?.text = "\(num)"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let selectCell = tableView.cellForRow(at: indexPath) as? TransformTableCell else{
            return
        }
        
        let cellRect = tableView.rectForRow(at: indexPath)
        let rect = tableView.convert(cellRect, to: self.tableView)
        selectCell.showMore()
        if selectCell.select{
            // 再次選到時就 Show
            self.selectIndexPath = indexPath
            self.presentPopOverView(With: selectCell, at: rect)
        }
        
    }

    func presentPopOverView(With sourceView : UIView , at rect : CGRect){
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.blue
        
        let label = UILabel()
        label.text = "Hello world"
        vc.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo:vc.view.topAnchor, constant: 10).isActive = true
        label.leftAnchor.constraint(equalTo: vc.view.leftAnchor, constant: 10).isActive = true
        
        
        
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 200, height: 200)
        
        let ppc = vc.popoverPresentationController
        ppc?.permittedArrowDirections = .up
        ppc?.delegate = self
        ppc?.sourceView = sourceView
        ppc?.sourceRect = CGRect(x: rect.size.width/2, y: rect.size.height, width: 0, height: 0)
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        guard let selectCell = tableView.cellForRow(at: self.selectIndexPath) as? TransformTableCell else{
            return true
        }
        selectCell.showMore()
        return true
    }
    public func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}

