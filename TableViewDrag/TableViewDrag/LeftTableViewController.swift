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
        tableView.setDraggingSourceOperationMask(.copy, forLocal: false)
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
        // info.draggingSource is nil when the source is in a different application.
        // This disallows drags from other apps, sources within the same app that
        // aren’t NSTableViews, and drags from the left table view.
        guard let source = info.draggingSource as? NSTableView else { return [] }
        if source !== tableView {
            // Highlight entire table view
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
        
        let newFruits = items.compactMap{ $0.string(forType: .string) }
        FruitManager.leftFruits.append(contentsOf: newFruits)
        
        let oldCount = tableView.numberOfRows
        tableView.insertRows(at: IndexSet(oldCount...oldCount + newFruits.count - 1),
                             withAnimation: .slideDown)
        return true
    }
}


extension NSUserInterfaceItemIdentifier {
    static let leftCellView = NSUserInterfaceItemIdentifier("leftCellView")
}
