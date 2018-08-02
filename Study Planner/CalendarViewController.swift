import UIKit
import FoldingCell
import RealmSwift
import SwiftEntryKit


class CalendarViewController: UITableViewController, CategoryCellDelegate {
    
    
    
    
    var categoryArray : [Category] = [Category]()
    var categories: Results<Category>?
    var todoTasks: Results<Todo>?
    let realm = try! Realm()
    var indexPathAYE : IndexPath = []
    var dateOfVC : Date?
    
    
    
    init(date: Date) {
        super.init(nibName: nil, bundle: nil)
        
        dateOfVC = date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func deleteCategoryCell(SelectedCategory: Category) {
        if SelectedCategory != nil{
            do {
                try self.realm.write {
                    self.realm.delete(SelectedCategory)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    func showAlertNotPinned(SelectedCategory : Category) {

        var textField : [EKProperty.TextFieldContent] = []
        let title = EKProperty.LabelContent(text: "Create New Task", style: .init(font: .systemFont(ofSize: 16), color: EKColor.Gray.a800, alignment: .center, numberOfLines: 1))
        let buttonText = EKProperty.LabelContent(text: "Create", style: .init(font: .systemFont(ofSize: 16), color: .white))
        
        let description1 = EKProperty.LabelContent(text: "Task Name", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image1 = UIImage(named: "pencil")
        let textField1 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description1, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image1 , bottomBorderColor: .darkGray)

        let button = EKProperty.ButtonContent(label: buttonText, backgroundColor: .flatPurple, highlightedBackgroundColor: .flatBlue) {
            
            if SelectedCategory != nil {
                do {
                    try self.realm.write {
                        let newItem = Todo()
                        newItem.todoName = textField1.output
                        newItem.pinned = false
                        newItem.dateCreatedInDays = Int ((self.dateOfVC?.timeIntervalSince1970)!/(60*60*24))
                        print(newItem.dateCreatedInDays)
                        SelectedCategory.theTasks.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            SwiftEntryKit.dismiss()
        }
        
        var attributes = EKAttributes.centerFloat
        attributes = .float
        attributes.windowLevel = .normal
        attributes.position = .center
        attributes.displayDuration = .infinity
        attributes.entranceAnimation = .init(translate: .init(duration: 0.65, anchorPosition: .bottom,  spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.65, anchorPosition: .top, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.65, spring: .init(damping: 1, initialVelocity: 0))))
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        attributes.entryBackground = .color(color: .white)
        attributes.screenBackground = .color(color: .dimmedDarkBackground)
        attributes.border = .value(color: UIColor(white: 0.8784, alpha: 0.6), width: 0.6)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 3))
        attributes.scroll = .enabled(swipeable: false, pullbackAnimation: .jolt)
        attributes.statusBar = .light
        attributes.positionConstraints.keyboardRelation = .bind(offset: .init(bottom: 15, screenEdgeResistance: 0))

        textField.append(textField1)
        if textField != nil {
            let contentView = EKFormMessageView(with: title, textFieldsContent: textField, buttonContent: button)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
    }
    
    func showAlertPinned(SelectedCategory : Category) {
        var textField : [EKProperty.TextFieldContent] = []
        let title = EKProperty.LabelContent(text: "Create New Pinned Task", style: .init(font: .systemFont(ofSize: 16), color: EKColor.Gray.a800, alignment: .center, numberOfLines: 1))
        let buttonText = EKProperty.LabelContent(text: "Create", style: .init(font: .systemFont(ofSize: 16), color: .white))
        let description1 = EKProperty.LabelContent(text: "Pinned Task Name", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image1 = UIImage(named: "pencil")
        let textField1 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description1, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image1 , bottomBorderColor: .darkGray)

        let button = EKProperty.ButtonContent(label: buttonText, backgroundColor: .flatPurple, highlightedBackgroundColor: .flatBlue) {
            if SelectedCategory != nil {
                do {
                    try self.realm.write {
                        let newItem = Todo()
                        newItem.todoName = textField1.output
                        newItem.pinned = true
                        newItem.dateCreatedInDays = Int ((self.dateOfVC?.timeIntervalSince1970)!/(60*60*24))
                        print(newItem.dateCreatedInDays)
                        SelectedCategory.theTasks.append(newItem)
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            SwiftEntryKit.dismiss()
        }
        
        var attributes = EKAttributes.centerFloat
        attributes = .float
        attributes.windowLevel = .normal
        attributes.position = .center
        attributes.displayDuration = .infinity
        attributes.entranceAnimation = .init(translate: .init(duration: 0.65, anchorPosition: .bottom,  spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.65, anchorPosition: .top, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.65, spring: .init(damping: 1, initialVelocity: 0))))
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        attributes.entryBackground = .color(color: .white)
        attributes.screenBackground = .color(color: .dimmedDarkBackground)
        attributes.border = .value(color: UIColor(white: 0.8784, alpha: 0.6), width: 0.6)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 3))
        attributes.scroll = .enabled(swipeable: false, pullbackAnimation: .jolt)
        attributes.statusBar = .light
        attributes.positionConstraints.keyboardRelation = .bind(offset: .init(bottom: 15, screenEdgeResistance: 0))
        textField.append(textField1)

        if textField != nil {
            let contentView = EKFormMessageView(with: title, textFieldsContent: textField, buttonContent: button)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
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
        
        //print("in willDisplay")
        
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
        

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTaskCell", for: indexPath) as! DemoCell
        
        
        
        //cell.myTableView.reloadData()
        // cell.delegate = self
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        

        
        if let category = categories?[indexPath.row] {

            cell.dateOfViewController = dateOfVC
            cell.selectedCategory = category
            cell.Label?.text = category.notes
            cell.closeNumberLabel?.text = category.nameOfCategory
            cell.openNumberLabel?.text = category.nameOfCategory

//            if dateOfVC != nil{
//                let dateOfVCinDays = Int ((dateOfVC?.timeIntervalSince1970)!)/(60*60*24)
//                todoTasks = category.theTasks.filter("(dateCreatedInDays == \(dateOfVCinDays))  OR (todoDone == false AND dateCreatedInDays < \(dateOfVCinDays) ) OR (pinned == true )").sorted(byKeyPath: "pinned", ascending: false).sorted(byKeyPath: "dateCreatedInDays", ascending: true)
//
//                if let item = todoTasks?[indexPath.row]{
//                print(indexPath.row)
//
//                if indexPath.row == 0 {
//                    cell.closedTask1.text = item.todoName
//                    print("0")
//                    //closedTask1.attributedText = attribute
//                }
//                else if indexPath.row == 1{
//                    print("1")
//                    cell.closedTask2.text = item.todoName
//                    //closedTask2.attributedText = attribute
//                }
//                else if indexPath.row == 2{
//                    print("2")
//                    cell.closedTask3.text = item.todoName
//                    //closedTask3.attributedText = attribute
//                }
//                else if indexPath.row == 3{
//                    cell.closedTask4.text = item.todoName
//                    //closedTask4.attributedText = attribute
//                }
//                else if indexPath.row == 4{
//                    cell.closedTask5.text = item.todoName
//                    //closedTask5.attributedText = attribute
//                }
//
//                }
      
           // }
            
            
            
        }
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
        
        
        
    }
}




