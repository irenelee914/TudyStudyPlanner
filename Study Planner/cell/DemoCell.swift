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
    func showAlert();
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
            
   
        }
    }
    
    
    
 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("2 \(self.closeNumberLabel.text!)")
        
       // print(demo)
        //section = demo?.count ?? 1
        //let count = demo.count
        
//        if count != nil {
//            return demo.count
//        }
//        else {
//        return 1
//        }
       
        //return section
        return demo?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "HELLO", for: indexPath)
    print("3 \(self.openNumberLabel.text!)")
      //  print(self.openNumberLabel.text!)
       // print(self.createdDate)
        //loadCategories()
        
      // categories = realm.objects(Category.self)
  //  let demo = realm.objects(Category.self).filter("dateCreated == self.createdDate" )
         demo = realm.objects(Category.self).filter("nameOfCategory == '\(self.openNumberLabel.text!)' " ).first!.theTasks
        
       // print(demo[indexPath.row].todoName)
       // print(indexPath.row)
        
       // self.tableView(myTableView, numberOfRowsInSection: (demo?.count)!)
        
        if let task = demo?[indexPath.row] {
            
             cell.textLabel?.text = task.todoName
             cell.accessoryType = task.todoDone ? .checkmark : .none
             cell.textLabel?.textColor = task.todoDone ? .red : .black
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
        self.delegate?.showAlert()
       
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
    
    
    
    
    
    func loadCategories(){
     
       // self.delegate?.doSomething()
       
        print(self.openNumberLabel.text!)
        todoTasks = selectedCategory?.theTasks.sorted(byKeyPath: "dateCreated", ascending: true)
        //myTableView.reloadData()
        
       // print("HI")
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



