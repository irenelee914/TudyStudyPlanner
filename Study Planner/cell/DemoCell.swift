//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import FoldingCell
import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit

protocol CategoryCellDelegate: class {
    func showAlertNotPinned(SelectedCategory : Category)
    func showAlertPinned(SelectedCategory : Category)
    func deleteCategoryCell(SelectedCategory: Category )
}



class DemoCell: FoldingCell, UITableViewDelegate , UITableViewDataSource, SwipeTableViewCellDelegate {
   
    
    
    //Setup Variables
    weak var delegate:CategoryCellDelegate?
    var dateOfViewController:Date?
    let realm = try! Realm()
    var todoTasks: Results<Todo>?
    var selectedCategory : Category? {
        didSet{
            
            loadTodoTasks()
        }
    }
    var pinnedTasksCompletedDatesArray = [Int]()
    
    
    
    //REALM Notification
    var notificationToken : NotificationToken?
    deinit{
        notificationToken?.invalidate()
    }
    
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            // Notification
            notificationToken = realm.observe { [unowned self] note, realm in
                //self.loadTodoTasks()
                //self.myTableView.reloadData()
            }
            myTableView.delegate = self
            myTableView.dataSource = self
            myTableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoTasks?.count ?? 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
//        if todoTasks?.count == 0 {
//            do {
//                try realm.write {
//                    let newItem = Todo()
//                    selectedCategory?.theTasks.append(newItem)
//                }
//            } catch {
//                print("Error saving category \(error)")
//            }
//        }
        
        if selectedCategory != nil {
            if let item = todoTasks?[indexPath.row]{
                let dateOfVCinDays = Int ((dateOfViewController?.timeIntervalSince1970)!)/(60*60*24)
                
                //cell.accessoryType = item.todoDone ? .checkmark : .none
                //cell.accessoryType = UITableViewCellAccessoryType.checkmark
                //cell.textLabel?.textColor = item.todoDone ? .gray : .black
                
                if item.pinned == false{
                    if item.todoDone == true {
                        let attributedString = NSMutableAttributedString(string: item.todoName)
                        attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
                        cell.textLabel?.attributedText = attributedString
                        cell.textLabel?.text = item.todoName
                        cell.textLabel?.textColor = .gray
                    }
                    else {
                        cell.textLabel?.attributedText = nil
                        cell.textLabel?.text = item.todoName
                        cell.textLabel?.textColor = .black
                    }
                }
                var daysPassed = dateOfVCinDays - item.dateCreatedInDays
                // var lastTimeCompleted =
                
                if item.pinned == true {
                    if item.pinnedTasksCompletedDates.contains("\(dateOfVCinDays)"){
                        let attributedString = NSMutableAttributedString(string: "📌  \(item.todoName)")
                        attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(3, attributedString.length-3))
                        cell.textLabel?.attributedText = attributedString
                        //cell.textLabel?.text = "📌  \(item.todoName)"
                        cell.textLabel?.textColor = .gray
                    }
                    else{
                        cell.textLabel?.attributedText = nil
                        cell.textLabel?.text = "📌  \(item.todoName)"
                        cell.textLabel?.textColor = .black
                    }
                }
                
                
                
                if daysPassed > 0 && item.pinned == false {
                    let main_string = "\(item.todoName)      D-\(daysPassed)"
                    let sub_string = "      D-\(daysPassed)"
                    let range = (main_string as NSString).range(of: sub_string)
                    
                    let attribute = NSMutableAttributedString.init(string: main_string)
                    attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.flatPinkDark , range: range)
                    cell.textLabel?.attributedText = attribute
                    //cell.textLabel?.text = "\(item.todoName)   D-\(daysPassed)"
                }
                
            }
        }
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let task = todoTasks?[indexPath.row] {
            do {
                try realm.write {
                    if task.pinned == false{
                        if task.todoDone == false {
                            task.todoDone = true
                            task.dateCompleted = dateOfViewController
                            task.dateCompletedInDays = Int((self.dateOfViewController?.timeIntervalSince1970)!/(60*60*24))
                        }
                        else{
                            task.todoDone = false
                            task.dateCompleted = nil
                            task.dateCompletedInDays = 0
                        }
                    }
                    let dateOfVCinDays = Int ((dateOfViewController?.timeIntervalSince1970)!)/(60*60*24)
                    
                    if task.pinned == true{
                        print("notchange3")
                        if task.pinnedTasksCompletedDates.contains("\(dateOfVCinDays)"){
                            
                            if let range = task.pinnedTasksCompletedDates.range(of: " \(dateOfVCinDays) "){
                                task.pinnedTasksCompletedDates.removeSubrange(range)
                                print("changed")
                            }
                            
                            
                            //                            task.pinnedTasksCompletedDates.append("\(dateOfVCinDays )")
                            //                            print("notchange")
                        }
                        else{
                            task.pinnedTasksCompletedDates.append(" \(dateOfVCinDays) ")
                            print("notchange")
                        }
                    }
                    
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
        myTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            self.updateModel(at: indexPath)
            
        }
        
        // customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
        if let item = todoTasks?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
       // loadTodoTasks()
       
    }
    
    
    
    
    @IBAction func menuButton(_ sender: UIButton) {
   
        if todoTasks != nil {
            do {
                try realm.write {
                    realm.delete(todoTasks!)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
        
        self.delegate?.deleteCategoryCell(SelectedCategory: self.selectedCategory!)
       
        //myTableView.reloadData()
      
    }
    
    
    @IBOutlet var cellColour1: UIView!
    @IBOutlet var cellColour2: UILabel!
    @IBOutlet var Label: UILabel!
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet var openNumberLabel: UILabel!
    @IBAction func addNewTask(_ sender: UIButton) {
        
        //  selectedCategory =
        self.delegate?.showAlertNotPinned(SelectedCategory: self.selectedCategory!)
        myTableView.reloadData()
    }
    
    @IBAction func addNewPinnedTask(_ sender: UIButton) {
        
        self.delegate?.showAlertPinned(SelectedCategory: self.selectedCategory!)
        myTableView.reloadData()
        
    }
    
    
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    
    
    
    
    
    func loadTodoTasks(){
        if dateOfViewController != nil{
            let dateOfVCinDays = Int ((dateOfViewController?.timeIntervalSince1970)!)/(60*60*24)
            // todoTasks = selectedCategory?.theTasks.filter("(dateCreatedInDays == \(dateOfVCinDays))")
            print(dateOfVCinDays)
            //            todoTasks = selectedCategory?.theTasks.filter("(dateCreatedInDays == \(dateOfVCinDays)) OR (dateCompletedInDays != \(dateOfVCinDays) AND dateCompletedInDays != 0  ) OR (todoDone == false AND dateCreatedInDays < \(dateOfVCinDays) ) OR (pinned == true )")
            
            todoTasks = selectedCategory?.theTasks.filter("(dateCreatedInDays == \(dateOfVCinDays))  OR (todoDone == false AND dateCreatedInDays < \(dateOfVCinDays) ) OR (pinned == true )").sorted(byKeyPath: "pinned", ascending: false).sorted(byKeyPath: "dateCreatedInDays", ascending: true)
            
            
            
            
            myTableView.reloadData()
            print("Welcome")
        }
        
    }
    
}





