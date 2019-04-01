//
//  RightTableViewController.swift
//  TableViewDrag
//
//  Created by Nate Thompson on 3/21/19.
//  Copyright © 2019 Nate Thompson. All rights reserved.
//

import Cocoa

class RightTableViewController: NSViewController {
    
    @IBOutlet weak var tableView: NSTableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
}


extension RightTableViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return FruitManager.rightFruits.count
    }
    
    func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        let cell = tableView.makeView(withIdentifier: .rightCellView, owner: nil)
            as! NSTableCellView
        cell.textField?.stringValue = FruitManager.rightFruits[row]
        return cell
    }
}


extension RightTableViewController: NSTableViewDelegate {
    // Due to a bug with NSTableView, this method has to be implemented to get
    // the draggingDestinationFeedbackStyle.gap animation to look right.
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 17
    }
    
    
    
    
    
}



extension NSUserInterfaceItemIdentifier {
    static let rightCellView = NSUserInterfaceItemIdentifier("rightCellView")
}
