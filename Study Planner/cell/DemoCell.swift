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

protocol CategoryCellDelegate {
    func showAlert()->Category;
   // func getCurrentCategory()->Category;
    //func loadTodoTasks();
    func getIndex()->IndexPath
}



class DemoCell: FoldingCell, UITableViewDelegate , UITableViewDataSource {
    var delegate:CategoryCellDelegate?
    
    /// --- REALM Notification. Update Tableview once new category is added --- ///
    var notificationToken : NotificationToken?
    deinit{
        notificationToken?.invalidate()
    }
    
    var todoTasks: Results<Todo>?
    var categories: Results<Category>?
    let realm = try! Realm()
    
    
    
    var selectedCategory : Category?
    
    
    @IBOutlet weak var myTableView: UITableView!
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            // Update the cell
            
            notificationToken = realm.observe { [unowned self] note, realm in
                self.myTableView.reloadData()
            }
            
            
            
            myTableView.delegate = self
            myTableView.dataSource = self
           // myTableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell")
            myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HELLO")
            myTableView.reloadData()
            
            
                
            var indexT = self.delegate?.getIndex()
            categories  = realm.objects(Category.self)
            print(indexT)
            
            
           // print("heeeeelllo \(categories)")
            
           // selectedCategory = categories?[(indexT?.row)!]
            
           // print("heeeeelllo \(selectedCategory)")
            
            loadCategories()
       
   
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoTasks?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HELLO", for: indexPath)
        if let task = todoTasks?[indexPath.row] {
             cell.textLabel?.text = task.todoName
            cell.accessoryType = task.todoDone ? .checkmark : .none
            cell.textLabel?.textColor = task.todoDone ? .red : .black
            //print(cell.accessoryType)
             }
        
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let task = todoTasks?[indexPath.row] {
            do {
                try realm.write {
                    task.todoDone = !task.todoDone
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    @IBOutlet var menuButton: UIButton!
    
    @IBOutlet var cellColour1: UIView!
    @IBOutlet var cellColour2: UILabel!
    
    
    @IBOutlet var Label: UILabel!
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet var openNumberLabel: UILabel!
    @IBAction func addNewTask(_ sender: UIButton) {
        
        
        
        
        selectedCategory = self.delegate?.showAlert()
        loadCategories()
        myTableView.reloadData()
        
        print("eeee")
        
//        if let currentCategory = self.selectedCategory{
//            do{
//                try self.realm.write {
//                    let newTask = Todo()
//                    //newTask.todoName = textField.text!
//                    newTask.dateCreated = Date()
//                    currentCategory.theTasks.append(newTask)
//                }
//            } catch {
//                print("Error")
//            }
//        }
    
    }
    
    @IBAction func addNewPinnedTask(_ sender: UIButton) {
    }
    
    
    
//    var number: Int = 0 {
//        didSet {
//            closeNumberLabel.text = String(number)
//            openNumberLabel.text = String(number)
//        }
//    }

    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }

    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    /// --- LOAD FROM REALM --- ///
//    func loadCategories() {
//       // todoTasks  = realm.objects(Todo.self)
//        selectedCategory = self.delegate?.getCurrentCategory()
//
//        todoTasks = selectedCategory?.theTasks.sorted(byKeyPath: "dateCreated", ascending: true)
//        myTableView.reloadData()
//        print("in loadcategories()")
////        todoTasks = selectedCategory?.theTasks.sorted(byKeyPath: "nameOfTask", ascending: true)
//
//
//    }
    
    func loadCategories(){
      //  delegate?.loadTodoTasks()
        todoTasks = selectedCategory?.theTasks.sorted(byKeyPath: "dateCreated", ascending: true)
        myTableView.reloadData()
        print("dd")
    }

    
    /// --- SAVE TO REALM --- ///
    func save(Task: Todo) {
        do {
            try realm.write {
                realm.add(Task)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        // tableView.reloadData()
        
    }
    
    
}

// MARK: - Actions ⚡️

extension DemoCell {

    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}



