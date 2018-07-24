import UIKit
import FoldingCell
import RealmSwift



class CalendarViewController: UITableViewController, CategoryCellDelegate {
    func getIndex() -> IndexPath {
        print("im in indexPathAYE -> CalendarVC")
        return indexPathAYE
        
    }
    
    
    var categoryArray : [Category] = [Category]()
    var categories: Results<Category>?
    var todoTasks: Results<Todo>?
    let realm = try! Realm()
    var indexPathAYE : IndexPath = []
    
    
    func doSomething(){
        print("something")
    }

    

    func showAlert() {
        print("in showalert1")
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add task", style: .default) { (action) in
            
            
            if let currentCategory = self.categories?[self.indexPathAYE.row]{
                
               
                
                do {
                    try self.realm.write {
                        let newItem = Todo()
                        newItem.todoName = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.theTasks.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            self.tableView.reloadData()
        }
            alert.addAction(action)
            
            alert.addTextField { (field) in
                textField = field
                textField.placeholder = "Add a new category"
            }
            self.present(alert, animated: true, completion: nil)
            print("in showalert33")
        
        
        //return (self.categories?[self.indexPathAYE.row])!
    }
    
 
    
    enum Const {
        static let closeCellHeight: CGFloat = 149
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    
    
    /// --- REALM Notification. Update Tableview once new category is added --- ///
    var notificationToken : NotificationToken?
    deinit{
        notificationToken?.invalidate()
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //let realm = Realm()
        notificationToken = realm.observe { [unowned self] note, realm in
            self.tableView.reloadData()
        }
        
        setup()
        tableView.separatorStyle = .none
        tableView.reloadData()
        loadCategories()
        
        
        
    }
    
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: Const.rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.register(UINib(nibName: "taskCell", bundle: nil) , forCellReuseIdentifier: "customTaskCell")
        
        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    /// --- LOAD FROM REALM --- ///
    func loadCategories() {
        categories  = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    /// --- SAVE FOR REALM --- ///
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
    
    
    
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
    
}

extension CalendarViewController {
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
       // cell.delegate = self
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        /////CELL TEXT
        /// --- DATA OF CELL --- ///
        if let category = categories?[indexPath.row] {
           // cell.categories = category
            cell.closeNumberLabel?.text = category.nameOfCategory
            cell.openNumberLabel?.text = category.nameOfCategory
            //cell.backgroundColor = categoryColour
            //cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
        //cell.closeNumberLabel =
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTaskCell", for: indexPath) as! DemoCell
       // cell.delegate = self
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        
        /// --- DATA OF CELL --- ///
        // if let category = categories?[indexPath.row] {
        // cell.textLabel?.text = category.nameOfCategory
        // }
        
        
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! DemoCell
        indexPathAYE = indexPath
        cell.delegate = self
        
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
        
        //        let destinationCell = DemoCell()
        //        if let indexPath = tableView.indexPathForSelectedRow{
        //            destinationCell.selectedCategory = categories?[indexPath.row]
        //        }
        
        
    }
}




