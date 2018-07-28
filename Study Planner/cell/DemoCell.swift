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
    func showAlert(SelectedCategory : Category);
    func doSomething()
}



class DemoCell: FoldingCell, UITableViewDelegate , UITableViewDataSource {

     //Setup Variables
    weak var delegate:CategoryCellDelegate?
    let realm = try! Realm()
    var todoTasks: Results<Todo>?
    var selectedCategory : Category? {
        didSet{
            loadTodoTasks()
        }
    }
    
    
    
    
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
                self.myTableView.reloadData()
            }
            myTableView.delegate = self
            myTableView.dataSource = self
            myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        }
    }
    
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoTasks?.count ?? 1
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        
        if todoTasks?.count == 0 {
            do {
                try realm.write {
                    let newItem = Todo()
                    selectedCategory?.theTasks.append(newItem)
                }
            } catch {
                print("Error saving category \(error)")
            }
        }

        if selectedCategory != nil {
            if let item = todoTasks?[indexPath.row]{
                cell.textLabel?.text = item.todoName
                //cell.accessoryType = item.todoDone ? .checkmark : .none
                //cell.accessoryType = UITableViewCellAccessoryType.checkmark
                cell.textLabel?.textColor = item.todoDone ? .gray : .black
                
                if item.todoDone == true {
                    let attributedString = NSMutableAttributedString(string: item.todoName)
                    attributedString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
                    cell.textLabel?.attributedText = attributedString
                }
                else {
                    cell.textLabel?.attributedText = nil
                    cell.textLabel?.text = item.todoName
                    
                }
                
            }
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
        self.delegate?.showAlert(SelectedCategory: self.selectedCategory!)
        myTableView.reloadData()
    }
    
    @IBAction func addNewPinnedTask(_ sender: UIButton) {
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
        todoTasks = selectedCategory?.theTasks.sorted(byKeyPath: "todoName", ascending: false)
        myTableView.reloadData()
    }

}

    



