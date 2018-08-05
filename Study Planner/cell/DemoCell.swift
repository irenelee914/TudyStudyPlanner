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
import CircleMenu




extension UIColor {
    static func color(_ red: Int, green: Int, blue: Int, alpha: Float) -> UIColor {
        return UIColor(
            red: 1.0 / 255.0 * CGFloat(red),
            green: 1.0 / 255.0 * CGFloat(green),
            blue: 1.0 / 255.0 * CGFloat(blue),
            alpha: CGFloat(alpha))
    }
}



protocol CategoryCellDelegate: class {
    func showAlertNotPinned(SelectedCategory : Category)
    func showAlertPinned(SelectedCategory : Category)
    func editCategoryCell(SelectedCategory: Category )
     func deleteCategoryCell(SelectedCategory: Category )
}



class DemoCell: FoldingCell, UITableViewDelegate , UITableViewDataSource, SwipeTableViewCellDelegate, CircleMenuDelegate {
    
    
    let items: [(icon: String, color: UIColor)] = [
        ("clear", .clear),
        ("clear", .clear),
        ("edit", UIColor(hexString: "#e67e22")!),
        ("garbage", UIColor(red: 0.96, green: 0.23, blue: 0.21, alpha: 1)),
        ("nearby-btn", .clear),
        ("nearby-btn", .clear),
        ("nearby-btn", .clear),
        ]
    
    
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
    
    

    
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
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
        if selectedCategory != nil {
            if let item = todoTasks?[indexPath.row]{
                let dateOfVCinDays = Int ((dateOfViewController?.timeIntervalSince1970)!)/(60*60*24)
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
                    writeToClosedCell(indexPath : indexPath.row, taskName : item.todoName, pinned: item.pinned)
                }
                var daysPassed = dateOfVCinDays - item.dateCreatedInDays
                
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
                    writeToClosedCell(indexPath : indexPath.row, taskName : item.todoName, pinned: item.pinned)
                }
                
                
                
                if daysPassed > 0 && item.pinned == false {
                    let main_string = "\(item.todoName)      D-\(daysPassed)"
                    let sub_string = "      D-\(daysPassed)"
                    let range = (main_string as NSString).range(of: sub_string)
                    
                    let attribute = NSMutableAttributedString.init(string: main_string)
                    attribute.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.flatPinkDark , range: range)
                    cell.textLabel?.attributedText = attribute
                    writeToClosedCell(indexPath : indexPath.row, taskName : item.todoName, pinned: item.pinned)
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
            self.updateModel(at: indexPath)
        }
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
    }
    
    
    
    
    @IBAction func menuButton(_ sender: UIButton) {
        
//        if todoTasks != nil {
//            do {
//                try realm.write {
//                    realm.delete(todoTasks!)
//                }
//            } catch {
//                print("Error deleting Item, \(error)")
//            }
//        }
        self.delegate?.editCategoryCell(SelectedCategory: self.selectedCategory!)
        
        //myTableView.reloadData()
        
    }
    
    
    @IBOutlet var closedTask1: UILabel!
    @IBOutlet var closedTask2: UILabel!
    @IBOutlet var closedTask3: UILabel!
    @IBOutlet var closedTask4: UILabel!
    @IBOutlet var closedTask5: UILabel!
    @IBOutlet var buttonView: UIView!
    
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
    @IBOutlet weak var backView: UIView!
    
    @IBAction func addNewPinnedTask(_ sender: UIButton) {
        
        self.delegate?.showAlertPinned(SelectedCategory: self.selectedCategory!)
        myTableView.reloadData()
        
    }
    
    
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
        
        self.backView.layer.borderWidth = 2
        self.backView.layer.cornerRadius = 3
        self.backView.layer.borderColor = UIColor.clear.cgColor
        self.backView.layer.masksToBounds = true
        self.layer.shadowOpacity = 0.28
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 2
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        
        //menu
        // add button
        let button = CircleMenu(
            frame: buttonView.frame,
            normalIcon:"burger",
            selectedIcon:"burger",
            buttonsCount: 6,
            duration: 0.5,
            distance: 80)
        button.backgroundColor = UIColor.clear
        button.delegate = self
        button.layer.cornerRadius = button.frame.size.width / 2.0
        
        containerView.addSubview(button)
        
    }
    
    //CIRCLE MENU DELEGATE
    func circleMenu(_: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
        
        // set highlited image
        let highlightedImage = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func circleMenu(_: CircleMenu, buttonWillSelected _: UIButton, atIndex: Int) {
        print("button will selected: \(atIndex)")
    }
    
    func circleMenu(_: CircleMenu, buttonDidSelected _: UIButton, atIndex: Int) {
        print("button did selected: \(atIndex)")
        if atIndex == 2 {
            self.delegate?.editCategoryCell(SelectedCategory: self.selectedCategory!)
        }
        else if atIndex == 3 {
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
        }
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    func writeToClosedCell(indexPath : Int, taskName : String, pinned : Bool) {
        
        if indexPath == 0 {
            if pinned {
                closedTask1.text = "▸  \(taskName)"
            }
            else{
                closedTask1.text = "◦  \(taskName)"
            }
            
        }
        else if indexPath == 1{
            if pinned {
                closedTask2.text = "▸  \(taskName)"
            }
            else{
                closedTask2.text = "◦  \(taskName)"
            }
        }
        else if indexPath == 2{
            if pinned {
                closedTask3.text = "▸  \(taskName)"
            }
            else{
                closedTask3.text = "◦  \(taskName)"
            }
            
        }
        else if indexPath == 3{
            if pinned {
                closedTask4.text = "▸  \(taskName)"
            }
            else{
                closedTask4.text = "◦  \(taskName)"
            }
            
        }
        else if indexPath == 4{
            if pinned {
                closedTask5.text = "▸  \(taskName)"
            }
            else{
                closedTask5.text = "◦  \(taskName)"
            }
            
        }
    }
    
    
    
    
    func loadTodoTasks(){
        if dateOfViewController != nil{
            let dateOfVCinDays = Int ((dateOfViewController?.timeIntervalSince1970)!)/(60*60*24)
            todoTasks = selectedCategory?.theTasks.filter("(dateCreatedInDays == \(dateOfVCinDays))  OR (todoDone == false AND dateCreatedInDays < \(dateOfVCinDays) ) OR (pinned == true )").sorted(byKeyPath: "pinned", ascending: false).sorted(byKeyPath: "dateCreatedInDays", ascending: true)
            myTableView.reloadData()
        }
    }
    
}





