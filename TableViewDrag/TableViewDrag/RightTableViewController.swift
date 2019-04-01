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
        tableView.setDraggingSourceOperationMask([.copy, .delete], forLocal: false)
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
        guard let source = info.draggingSource as? NSTableView, dropOperation == .above
            else { return [] }
        
        // If dragging to reorder, use the gap feedback style. Otherwise, draw insertion marker.
        if source === tableView {
            tableView.draggingDestinationFeedbackStyle = .gap
        } else {
            tableView.draggingDestinationFeedbackStyle = .regular
        }
        return .move
    }
    
    
    
    func tableView(
        _ tableView: NSTableView,
        acceptDrop info: NSDraggingInfo,
        row: Int,
        dropOperation: NSTableView.DropOperation) -> Bool
    {
        guard let items = info.draggingPasteboard.pasteboardItems else { return false }
        
        let oldIndexes = items.compactMap{ $0.integer(forType: .tableViewIndex) }
        if !oldIndexes.isEmpty {
            FruitManager.rightFruits.move(with: IndexSet(oldIndexes), to: row)
            
            // The ol' Stack Overflow copy-paste. Reordering rows can get pretty hairy if
            // you allow multiple selection. https://stackoverflow.com/a/26855499/7471873
            
            tableView.beginUpdates()
            var oldIndexOffset = 0
            var newIndexOffset = 0
            
            for oldIndex in oldIndexes {
                if oldIndex < row {
                    tableView.moveRow(at: oldIndex + oldIndexOffset, to: row - 1)
                    oldIndexOffset -= 1
                } else {
                    tableView.moveRow(at: oldIndex, to: row + newIndexOffset)
                    newIndexOffset += 1
                }
            }
            tableView.endUpdates()
            
            return true
        }
        
        let newFruits = items.compactMap{ $0.string(forType: .string) }
        FruitManager.rightFruits.insert(contentsOf: newFruits, at: row)
        tableView.insertRows(at: IndexSet(row...row + newFruits.count - 1),
                             withAnimation: .slideDown)
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
            tableView.removeRows(at: IndexSet(indexes), withAnimation: .slideUp)
        }
    }
}



extension NSUserInterfaceItemIdentifier {
    static let rightCellView = NSUserInterfaceItemIdentifier("rightCellView")
}
