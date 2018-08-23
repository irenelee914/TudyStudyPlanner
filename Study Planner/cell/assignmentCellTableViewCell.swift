//
//  assignmentCellTableViewCell.swift
//  Study Planner
//
//  Created by Hojoon Lee on 2018-08-01.
//  Copyright © 2018 Irene Lee. All rights reserved.
//

import UIKit
import FoldingCell
import UIKit
import RealmSwift
import ChameleonFramework
import SwipeCellKit
//import ScrollableGraphView

import Dropper
import CircleMenu






protocol AssignmentCellDelegate: class {
    func showAlertNotPinnedSelectedAssignment(SelectedAssignment : Category)
    func showAlertPinnedSelectedAssignment(SelectedAssignment : Category)
    func editCategoryCellSelectedAssignment(SelectedAssignment: Category )
     func deleteAssignmentCell(SelectedAssignment: Category )
}



class assignmentCellTableViewCell: FoldingCell, UITableViewDelegate , UITableViewDataSource, SwipeTableViewCellDelegate, CircleMenuDelegate{

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
    weak var delegate:AssignmentCellDelegate?
    var pinnedTasksCompletedDatesArray = [Int]()
    var dateOfViewController:Date?
    let realm = try! Realm()
    let view = UIView()
    var assignmentTasks: Results<Todo>?
    var selectedAssignment : Category? {
        didSet{
            loadAssignmentTasks()
        }
    }
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var assignmentClosedName: UILabel!
    @IBOutlet weak var course: UILabel!
    @IBOutlet weak var daysDue: UILabel!
    @IBOutlet weak var assignmentTag: UILabel!
    @IBOutlet weak var weighting: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var dueDate: UILabel!
    ///
    @IBOutlet weak var openClosedName: UILabel!
    @IBAction func addTask(_ sender: UIButton) {
        self.delegate?.showAlertNotPinnedSelectedAssignment(SelectedAssignment: self.selectedAssignment!)
        myTableView.reloadData()
    }
    @IBAction func pinnedTask(_ sender: UIButton) {
        self.delegate?.showAlertPinnedSelectedAssignment(SelectedAssignment: self.selectedAssignment!)
    }

    
    @IBOutlet weak var myTableView: UITableView!
    
    @IBOutlet var menuView: UIView!
    @IBOutlet weak var backView: UIView!
    
    
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
        
        //set drop down shadow
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
                    frame: menuView.frame,
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
            self.delegate?.editCategoryCellSelectedAssignment(SelectedAssignment: self.selectedAssignment!)
        }
        else if atIndex == 3 {
            if assignmentTasks != nil {
                do {
                    try realm.write {
                        realm.delete(assignmentTasks!)
                    }
                } catch {
                    print("Error deleting Item, \(error)")
                }
            }
        
            self.delegate?.deleteAssignmentCell(SelectedAssignment: self.selectedAssignment!)
        }
    }
    
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            myTableView.delegate = self
            myTableView.dataSource = self
            myTableView.register(SwipeTableViewCell.self, forCellReuseIdentifier: "DefaultCell")
            
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assignmentTasks?.count ?? 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        
        
        if selectedAssignment != nil {
            if let item = assignmentTasks?[indexPath.row]{
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
    
    
    //
    func loadAssignmentTasks(){
        if dateOfViewController != nil{
             let dateOfVCinDays = Int ((dateOfViewController?.timeIntervalSince1970)!)/(60*60*24)
            assignmentTasks = selectedAssignment?.theTasks.filter("(dateCreatedInDays == \(dateOfVCinDays))  OR (todoDone == false AND dateCreatedInDays < \(dateOfVCinDays) ) OR (pinned == true )").sorted(byKeyPath: "pinned", ascending: false).sorted(byKeyPath: "dateCreatedInDays", ascending: true)
            
            myTableView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
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
        if let item = assignmentTasks?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
        
        
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let task = assignmentTasks?[indexPath.row] {
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}





