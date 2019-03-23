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
        tableView.registerForDraggedTypes([.string])
        tableView.setDraggingSourceOperationMask([.copy, .delete], forLocal: false)
    }
    
}


extension LeftTableViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return FruitManager.leftFruits.count
    }
}


extension LeftTableViewController: NSTableViewDelegate {
    func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?,
        row: Int) -> NSView?
    {
        if let cell = tableView.makeView(withIdentifier: .leftCellView, owner: self)
            as? NSTableCellView
        {
            cell.textField?.stringValue = FruitManager.leftFruits[row]
            return cell
        }
        return nil
    }
    
    
    
    func tableView(
        _ tableView: NSTableView,
        pasteboardWriterForRow row: Int) -> NSPasteboardWriting?
    {
        return FruitManager.leftFruits[row] as NSString
    }
    
    
    
    func tableView(
        _ tableView: NSTableView,
        validateDrop info: NSDraggingInfo,
        proposedRow row: Int,
        proposedDropOperation dropOperation: NSTableView.DropOperation)
        -> NSDragOperation
    {
        guard let source = info.draggingSource as? NSTableView else { return [] }
        if source !== tableView {
            tableView.setDropRow(-1, dropOperation: .on)
            return .copy
        }
        return []
    }
    
    
    
    func tableView(
        _ tableView: NSTableView,
        acceptDrop info: NSDraggingInfo,
        row: Int,
        dropOperation: NSTableView.DropOperation) -> Bool
    {
        guard let items = info.draggingPasteboard.pasteboardItems else { return false }
        
        let fruits = items.compactMap{ $0.string(forType: .string) }
        FruitManager.leftFruits.append(contentsOf: fruits)
        tableView.reloadData()
        return true
    }
}


extension NSUserInterfaceItemIdentifier {
    static let leftCellView = NSUserInterfaceItemIdentifier("leftCellView")
}
