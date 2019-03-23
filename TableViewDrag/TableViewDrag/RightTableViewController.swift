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
        tableView.registerForDraggedTypes([.string, .tableViewIndex])
        tableView.setDraggingSourceOperationMask(.every, forLocal: false)
    }
    
}


extension RightTableViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return FruitManager.rightFruits.count
    }
}


extension RightTableViewController: NSTableViewDelegate {
    func tableView(
        _ tableView: NSTableView,
        viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?
    {
        if let cell = tableView.makeView(withIdentifier: .rightCellView, owner: nil)
            as? NSTableCellView
        {
            cell.textField?.stringValue = FruitManager.rightFruits[row]
            return cell
        }
        return nil
    }
    
    
    
    func tableView(
        _ tableView: NSTableView,
        pasteboardWriterForRow row: Int) -> NSPasteboardWriting?
    {
        return FruitPasteboardWriter(fruit: FruitManager.rightFruits[row], at: row)
    }
    
    
    
    func tableView(
        _ tableView: NSTableView,
        validateDrop info: NSDraggingInfo,
        proposedRow row: Int,
        proposedDropOperation dropOperation: NSTableView.DropOperation) -> NSDragOperation
    {
        if dropOperation == .above {
            return .move
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
        
        let indexes = items.compactMap{ $0.integer(forType: .tableViewIndex) }
        if !indexes.isEmpty {
            FruitManager.rightFruits.move(with: IndexSet(indexes), to: row)
            tableView.reloadData()
            return true
        }
        
        let fruits = items.compactMap{ $0.string(forType: .string) }
        FruitManager.rightFruits.insert(contentsOf: fruits, at: row)
        tableView.reloadData()
        return true
    }
    
    
    
    func tableView(
        _ tableView: NSTableView,
        draggingSession session: NSDraggingSession,
        endedAt screenPoint: NSPoint,
        operation: NSDragOperation)
    {
        // Handle items dragged to Trash
        if operation == .delete, let items = session.draggingPasteboard.pasteboardItems {
            let indexes = items.compactMap{ $0.integer(forType: .tableViewIndex) }
            
            for index in indexes.reversed() {
                FruitManager.rightFruits.remove(at: index)
            }
            tableView.reloadData()
        }
    }
}



extension NSUserInterfaceItemIdentifier {
    static let rightCellView = NSUserInterfaceItemIdentifier("rightCellView")
}
