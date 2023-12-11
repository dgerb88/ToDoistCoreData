//
//  ItemManager.swift
//  ToDoist
//
//  Created by Parker Rushton on 10/21/22.
//

import Foundation
import CoreData

class ItemManager {
    static let shared = ItemManager()
    
    
    // Create
    
    func createNewItem(with title: String) {
        let newItem = Item(context: PersistenceController.shared.viewContext)
        newItem.id = UUID().uuidString
        newItem.title = title
        newItem.createdAt = Date()
        newItem.completedAt = nil
        PersistenceController.shared.saveContext()
    }
    
    // Retrieve
    
    private func fetchItems(matching predicate: NSPredicate) -> [Item] {
        let fetchRequest = Item.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        do {
            let context = PersistenceController.shared.viewContext
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    
    func fetchIncompleteItems() -> [Item] {
        return fetchItems(matching: NSPredicate(format: "completedAt == nil"))
    }
    func fetchCompleteItems() -> [Item] {
        return fetchItems(matching: NSPredicate(format: "completedAt != nil"))
    }
    
    // Update
    
    func toggleItemCompletion(_ item: Item) {
        item.completedAt = item.isCompleted ? nil : Date()
        PersistenceController.shared.saveContext()
    }
    
    // Delete
    
    func remove(_ item: Item) {
        let context = PersistenceController.shared.viewContext
        context.delete(item)
        PersistenceController.shared.saveContext()
    }
    
}
