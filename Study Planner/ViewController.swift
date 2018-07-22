import UIKit
import Parchment
import RealmSwift
import SwiftEntryKit

// First thing we need to do is create our own PagingItem that will
// hold our date. We need to make sure it conforms to Hashable and
// Comparable, as that is required by PagingViewController. We also
// cache the formatted date strings for performance.

struct CalendarItem: PagingItem, Hashable, Comparable {
  let date: Date
  let dateText: String
  let weekdayText: String
  
  init(date: Date) {
    self.date = date
    self.dateText = DateFormatters.dateFormatter.string(from: date)
    self.weekdayText = DateFormatters.weekdayFormatter.string(from: date)
  }
  
  var hashValue: Int {
    return date.hashValue
  }
  
  static func ==(lhs: CalendarItem, rhs: CalendarItem) -> Bool {
    return lhs.date == rhs.date
  }
  
  static func <(lhs: CalendarItem, rhs: CalendarItem) -> Bool {
    return lhs.date < rhs.date
  }
}

class ViewController: UIViewController  {
    /// --- REALM --- ///
    let realm = try! Realm()
    var categories: Results<Category>?
    
    /// --- Sending Data from 1st VC to 2nd VC --- ///
    
    
    

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Create an instance of PagingViewController where CalendarItem
    // is set as the generic type.
    let pagingViewController = PagingViewController<CalendarItem>()
    pagingViewController.menuItemClass = CalendarPagingCell.self
    pagingViewController.menuItemSize = .fixed(width: 48, height: 68)
    pagingViewController.textColor = UIColor(red: 95/255, green: 102/255, blue: 108/255, alpha: 1)
    pagingViewController.selectedTextColor = UIColor(red: 117/255, green: 111/255, blue: 216/255, alpha: 1)
    pagingViewController.indicatorColor = UIColor(red: 117/255, green: 111/255, blue: 216/255, alpha: 1)
    
    // Add the paging view controller as a child view
    // controller and constrain it to all edges
    addChildViewController(pagingViewController)
    view.addSubview(pagingViewController.view)
    view.constrainToEdges(pagingViewController.view)
    pagingViewController.didMove(toParentViewController: self)
    
    pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false


    
    // Set our custom data source
    pagingViewController.infiniteDataSource = self
    
    // Set the current date as the selected paging item
    pagingViewController.select(pagingItem: CalendarItem(date: Date()))
    
    
    self.edgesForExtendedLayout = []
     pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
        pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        pagingViewController.view.topAnchor.constraint(equalTo: view.topAnchor)
        ])
  }
    
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.nameOfCategory = textField.text!
            //newCategory.colour = UIColor.randomFlat.hexValue()
            
            self.save(category: newCategory)
            
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    /// --- SAVE TO REALM --- ///
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
       // tableView.reloadData()
        
    }
    

    
  
}

// We need to conform to PagingViewControllerDataSource in order to
// implement our custom data source. We set the initial item to be the
// current date, and every time pagingItemBeforePagingItem: or
// pagingItemAfterPagingItem: is called, we either subtract or append
// the time interval equal to one day. This means our paging view
// controller will show one menu item for each day.

extension ViewController: PagingViewControllerInfiniteDataSource {
  
    /// --- THIS GENERATES THE VIEWCONTROLLER PER EACH DATE --- ///
  func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, viewControllerForPagingItem pagingItem: T) -> UIViewController {
    let calendarItem = pagingItem as! CalendarItem
   // return CalendarViewController(date: calendarItem.date)
    return CalendarViewController()
  }
  
  func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemBeforePagingItem pagingItem: T) -> T? {
    let calendarItem = pagingItem as! CalendarItem
    return CalendarItem(date: calendarItem.date.addingTimeInterval(-86400)) as? T
  }
  
  func pagingViewController<T>(_ pagingViewController: PagingViewController<T>, pagingItemAfterPagingItem pagingItem: T) -> T? {
    let calendarItem = pagingItem as! CalendarItem
    return CalendarItem(date: calendarItem.date.addingTimeInterval(86400)) as? T
  }
  
}
