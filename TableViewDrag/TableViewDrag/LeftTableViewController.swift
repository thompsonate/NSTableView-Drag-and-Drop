//
//  LeftTableViewController.swift
//  TableViewDrag
//
//  Created by Nate Thompson on 3/21/19.
//  Copyright © 2019 Nate Thompson. All rights reserved.
//

import Cocoa

class LeftTableViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
}


extension LeftTableViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return FruitManager.leftFruits.count
    }
    
    func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?,
        row: Int) -> NSView?
    {
        let cell = tableView.makeView(withIdentifier: .leftCellView, owner: self)
            as! NSTableCellView
        cell.textField?.stringValue = FruitManager.leftFruits[row]
        return cell
    }
}


extension LeftTableViewController: NSTableViewDelegate {
    
    
    
    
    
    
    
}


extension NSUserInterfaceItemIdentifier {
    static let leftCellView = NSUserInterfaceItemIdentifier("leftCellView")
}
