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

protocol CategoryCellDelegate: class {
    func showAlert(TESTCategory : Category);
    func doSomething()
}



class DemoCell: FoldingCell, UITableViewDelegate , UITableViewDataSource {

    
    weak var delegate:CategoryCellDelegate?
    
    /// --- REALM Notification. Update Tableview once new category is added --- ///
    var notificationToken : NotificationToken?
    deinit{
        notificationToken?.invalidate()
    }
    
    var todoTasks: Results<Todo>?
    var categories: Results<Category>?
    let realm = try! Realm()
    var demo : List<Todo>?
    
    
    var createdDate = Date()
    
    var selectedCategory : Category?
    
    
    
    //NEW NEW NEW NEW
     var TESTtodoTasks: Results<Todo>?
    var TESTselectedCategory : Category? {
        didSet{
            loadTodoTasks()
        }
    }
    
    
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
            
            //myTableView.reloadData()
            
   
        }
    }
    
    
    
 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
//        if TESTselectedCategory != nil {
//            return
//        }
//        else {
//        return 1
//        }
       
        //return section
        return TESTtodoTasks?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "HELLO", for: indexPath)

        // demo = realm.objects(Category.self).filter("nameOfCategory == '\(self.openNumberLabel.text!)' " ).first!.theTasks

        print("fdsfsd@")
       // self.tableView(myTableView, numberOfRowsInSection: (demo?.count)!)
        
        if TESTtodoTasks?.count == 0 {
            do {
                try realm.write {
                    let newItem = Todo()
                    TESTselectedCategory?.theTasks.append(newItem)
                }
            } catch {
                print("Error saving category \(error)")
            }
        }
        
        print (TESTselectedCategory)
        if TESTselectedCategory != nil {
            print("1212121@")
            if let item = TESTtodoTasks?[indexPath.row]{
                 print("43242342@")
                cell.textLabel?.text = item.todoName
                cell.accessoryType = item.todoDone ? .checkmark : .none
                cell.textLabel?.textColor = item.todoDone ? .red : .black
            }
        }
        
        

        
        
        
//        if let task = demo?[indexPath.row] {
//
//             cell.textLabel?.text = task.todoName
//             cell.accessoryType = task.todoDone ? .checkmark : .none
//             cell.textLabel?.textColor = task.todoDone ? .red : .black
//             }
        
    
        return cell
    }
    
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let task = TESTtodoTasks?[indexPath.row] {
            do {
                try realm.write {
                    task.todoDone = !task.todoDone
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        myTableView.reloadData()
        
    }
    

    @IBOutlet var menuButton: UIButton!
    
    @IBOutlet var cellColour1: UIView!
    @IBOutlet var cellColour2: UILabel!
    
    
    @IBOutlet var Label: UILabel!
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet var openNumberLabel: UILabel!
    @IBAction func addNewTask(_ sender: UIButton) {
        
        
        
        
      //  selectedCategory =
        self.delegate?.showAlert(TESTCategory: self.TESTselectedCategory!)
       
        myTableView.reloadData()
        
        
        
        print("eeee")
    
    }
    
    @IBAction func addNewPinnedTask(_ sender: UIButton) {
    }
    
    

    override func awakeFromNib() {
        print("awakefromnib\(self.openNumberLabel.text!)")
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }

    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        print("1 \(self.openNumberLabel.text!)")
        return durations[itemIndex]
    }
    
    
    
    func DEMOLOAD(){
        categories  = realm.objects(Category.self)
        //tableView.reloadData()
    }
    
    
    
    
    
    func loadTodoTasks(){

        TESTtodoTasks = TESTselectedCategory?.theTasks.sorted(byKeyPath: "todoName", ascending: false)
        myTableView.reloadData()
        
        
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



