import UIKit
import Parchment
import RealmSwift
import SwiftEntryKit
import SwiftyDrop


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
    
    
    @IBAction func addNewAssignment(_ sender: UIBarButtonItem) {
        
        var textField : [EKProperty.TextFieldContent] = []
        let title = EKProperty.LabelContent(text: "Create New Assignment", style: .init(font: .systemFont(ofSize: 16), color: EKColor.Gray.a800, alignment: .center, numberOfLines: 1))
        let buttonText = EKProperty.LabelContent(text: "Create", style: .init(font: .systemFont(ofSize: 16), color: .white))
        
        let description1 = EKProperty.LabelContent(text: "Assignment Title", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image1 = UIImage(named: "pencil")
        let textField1 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description1, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image1 , bottomBorderColor: .darkGray)
        
        let description2 = EKProperty.LabelContent(text: "Course/Subject", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image2 = UIImage(named: "tag")
        let textField2 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description2, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image2 , bottomBorderColor: .darkGray)
        
        let description3 = EKProperty.LabelContent(text: "Due Date", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image3 = UIImage(named: "calendar")
        let textField3 = EKProperty.TextFieldContent(keyboardType: .default, placeholder: description3, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image3 , bottomBorderColor: .darkGray, datePicker: true)
        
        let description4 = EKProperty.LabelContent(text: "Start Date", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image4 = UIImage(named: "calendar")
        let textField4 = EKProperty.TextFieldContent(keyboardType: .default, placeholder: description4, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image4 , bottomBorderColor: .darkGray, datePicker: true)
        
        let description5 = EKProperty.LabelContent(text: "Weighting (ex. 10%)", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image5 = UIImage(named: "percent")
        let textField5 = EKProperty.TextFieldContent(keyboardType: .decimalPad, placeholder: description5, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image5 , bottomBorderColor: .darkGray, datePicker: false)
        
        let button = EKProperty.ButtonContent(label: buttonText, backgroundColor: .flatPurple, highlightedBackgroundColor: .flatBlue) {
            
            
            
            
            let addedDate = textField3.output
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            let dueDate = formatter.date(from: addedDate)
            
            let addedDate2 = textField4.output
            let formatter2 = DateFormatter()
            formatter2.dateFormat = "dd/MM/yyyy"
            let startDate = formatter2.date(from: addedDate2)
            
            
            
            if (dueDate != nil) && (startDate != nil) {
                let dueDateInDays = Int ((dueDate?.timeIntervalSince1970)!)/(60*60*24)
                let startDateInDays = Int ((startDate?.timeIntervalSince1970)!)/(60*60*24)
                let temp = Float(textField5.output)
                
                if startDateInDays > dueDateInDays {
                    Drop.down("Starting Date is after Due Date", state: .error)
                }
                else if temp == nil{
                    Drop.down("Incorrect weighting input", state: .error)
                }
                else if (textField1.output.count <= 0 || textField2.output.count <= 0){
                    Drop.down("Missing input", state: .error)
                }
                else{
                    let newAssignment = Category()
                    newAssignment.nameOfAssignment = textField1.output
                    newAssignment.assignmentTag = textField2.output
                    newAssignment.assignmentDueDate = textField3.output
                    newAssignment.assignmentStartDate = textField4.output
                    newAssignment.isAssignment = true
                    newAssignment.assignmentDateDueInDays = dueDateInDays
                    newAssignment.assignmentStartDateInDays = startDateInDays
                    
                    newAssignment.assignmentWeighting = temp!
                    self.save(category: newAssignment)
                    SwiftEntryKit.dismiss()
                    
                    //Notification that New Category was Created
                    var attributesNotification = EKAttributes.topFloat
                    attributesNotification.entryBackground = .gradient(gradient: .init(colors: [.white, .white], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
                    attributesNotification.displayDuration = 1.3
                    attributesNotification.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                    attributesNotification.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                    attributesNotification.statusBar = .dark
                    attributesNotification.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                    
                    let title = EKProperty.LabelContent(text: "Update", style: .init(font: .systemFont(ofSize: 16), color: .black))
                    let description = EKProperty.LabelContent(text: "New Assignment: \(newAssignment.nameOfAssignment) Created", style: .init(font: .systemFont(ofSize: 12), color: .black))
                    let image = EKProperty.ImageContent(image: UIImage(named: "photo")!, size: CGSize(width: 35, height: 35))
                    let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
                    let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
                    let contentView = EKNotificationMessageView(with: notificationMessage)
                    SwiftEntryKit.display(entry: contentView, using: attributesNotification)
                }
            }
            else{
                Drop.down("Incorrect inputs", state: .error)
            }
            
        }
        
        var attributes = EKAttributes.centerFloat
        attributes = .float
        attributes.windowLevel = .normal
        attributes.positionConstraints = .float
        attributes.position = .center
        attributes.displayDuration = .infinity
        attributes.entranceAnimation = .init(translate: .init(duration: 0.65, anchorPosition: .bottom,  spring: .init(damping: 1, initialVelocity: 0)))
        // attributes.exitAnimation = .init(translate: .init(duration: 0.65, anchorPosition: .top, spring: .init(damping: 1, initialVelocity: 0)))
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
        attributes.displayPriority = .normal
        textField.append(textField1)
        textField.append(textField2)
        textField.append(textField3)
        textField.append(textField4)
        textField.append(textField5)
        
        
        if textField != nil {
            let contentView = EKFormMessageView(with: title, textFieldsContent: textField, buttonContent: button)
            SwiftEntryKit.display(entry: contentView, using: attributes)
            
        }
    }
    
    
    @IBAction func addNewCategory(_ sender: UIBarButtonItem) {
        
        var textField : [EKProperty.TextFieldContent] = []
        let title = EKProperty.LabelContent(text: "Create New Category", style: .init(font: .systemFont(ofSize: 16), color: EKColor.Gray.a800, alignment: .center, numberOfLines: 1))
        
        let buttonText = EKProperty.LabelContent(text: "Create", style: .init(font: .systemFont(ofSize: 16), color: .white))
        let description1 = EKProperty.LabelContent(text: "Category Title", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image1 = UIImage(named: "pencil")
        let textField1 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description1, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image1 , bottomBorderColor: .darkGray)
        let description2 = EKProperty.LabelContent(text: "Tag", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image2 = UIImage(named: "tag")
        let textField2 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description2, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image2 , bottomBorderColor: .darkGray)
        
        let button = EKProperty.ButtonContent(label: buttonText, backgroundColor: .flatPurple, highlightedBackgroundColor: .flatBlue) {
            
            
            
            if (textField1.output.count > 0 && textField2.output.count > 0){
                //Create New Category
                let newCategory = Category()
                newCategory.nameOfCategory = textField1.output
                newCategory.notes = textField2.output
                self.save(category: newCategory)
                SwiftEntryKit.dismiss()
                
                //Notification that New Category was Created
                var attributesNotification = EKAttributes.topFloat
                attributesNotification.entryBackground = .gradient(gradient: .init(colors: [.white, .white], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
                attributesNotification.displayDuration = 1.3
                attributesNotification.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                attributesNotification.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                attributesNotification.statusBar = .dark
                attributesNotification.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                let title = EKProperty.LabelContent(text: "Update", style: .init(font: .systemFont(ofSize: 16), color: .black))
                let description = EKProperty.LabelContent(text: "New Category: \(newCategory.nameOfCategory) Created", style: .init(font: .systemFont(ofSize: 12), color: .black))
                let image = EKProperty.ImageContent(image: UIImage(named: "photo")!, size: CGSize(width: 35, height: 35))
                let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
                let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
                let contentView = EKNotificationMessageView(with: notificationMessage)
                SwiftEntryKit.display(entry: contentView, using: attributesNotification)
                
            }
            else {
                Drop.down("Missing input", state: .error)
                
            }
            
        }
        
        var attributes = EKAttributes.centerFloat
        attributes = .float
        attributes.windowLevel = .normal
        attributes.position = .center
        attributes.displayDuration = .infinity
        attributes.entranceAnimation = .init(translate: .init(duration: 0.65, anchorPosition: .bottom,  spring: .init(damping: 1, initialVelocity: 0)))
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
        textField.append(textField2)
        if textField != nil {
            let contentView = EKFormMessageView(with: title, textFieldsContent: textField, buttonContent: button)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
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
        return CalendarViewController(date: calendarItem.date)
        //return CalendarViewController()
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
