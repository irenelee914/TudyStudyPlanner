import UIKit
import FoldingCell
import RealmSwift
import SwiftEntryKit
import SwiftyDrop
import SwipeCellKit


class CalendarViewController: UITableViewController, CategoryCellDelegate, AssignmentCellDelegate, SwipeTableViewCellDelegate {
    
    
    
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
    
    
    
    
    
    
    
    
    func deleteAssignmentCell(SelectedAssignment: Category) {
        if SelectedAssignment != nil{
            do {
                try self.realm.write {
                    self.realm.delete(SelectedAssignment)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    
    

    
    func showAlertNotPinnedSelectedAssignment(SelectedAssignment: Category) {
        var textField : [EKProperty.TextFieldContent] = []
        let title = EKProperty.LabelContent(text: "Create New Assignment Task", style: .init(font: .systemFont(ofSize: 16), color: EKColor.Gray.a800, alignment: .center, numberOfLines: 1))
        let buttonText = EKProperty.LabelContent(text: "Create", style: .init(font: .systemFont(ofSize: 16), color: .white))
        
        let description1 = EKProperty.LabelContent(text: "Task Name", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image1 = UIImage(named: "pencil")
        let textField1 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description1, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image1 , bottomBorderColor: .darkGray)
        
        let button = EKProperty.ButtonContent(label: buttonText, backgroundColor: .flatPurple, highlightedBackgroundColor: .flatBlue) {
            
            if SelectedAssignment != nil && (textField1.output.count > 0){
                do {
                    try self.realm.write {
                        let newItem = Todo()
                        newItem.todoName = textField1.output
                        newItem.pinned = false
                        newItem.dateCreatedInDays = Int ((self.dateOfVC?.timeIntervalSince1970)!/(60*60*24))
                        print(newItem.dateCreatedInDays)
                        SelectedAssignment.theTasks.append(newItem)
                        SwiftEntryKit.dismiss()
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            else {
                Drop.down("Incorrect inputs", state: .error)
            }
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
    
    func showAlertPinnedSelectedAssignment(SelectedAssignment: Category) {
        var textField : [EKProperty.TextFieldContent] = []
        let title = EKProperty.LabelContent(text: "Create New Pinned Task", style: .init(font: .systemFont(ofSize: 16), color: EKColor.Gray.a800, alignment: .center, numberOfLines: 1))
        let buttonText = EKProperty.LabelContent(text: "Create", style: .init(font: .systemFont(ofSize: 16), color: .white))
        let description1 = EKProperty.LabelContent(text: "Pinned Task Name", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image1 = UIImage(named: "pencil")
        let textField1 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description1, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image1 , bottomBorderColor: .darkGray)
        
        let button = EKProperty.ButtonContent(label: buttonText, backgroundColor: .flatPurple, highlightedBackgroundColor: .flatBlue) {
            if SelectedAssignment != nil && (textField1.output.count > 0) {
                do {
                    try self.realm.write {
                        let newItem = Todo()
                        newItem.todoName = textField1.output
                        newItem.pinned = true
                        newItem.dateCreatedInDays = Int ((self.dateOfVC?.timeIntervalSince1970)!/(60*60*24))
                        print(newItem.dateCreatedInDays)
                        SelectedAssignment.theTasks.append(newItem)
                        SwiftEntryKit.dismiss()
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            else {
                Drop.down("Incorrect inputs", state: .error)
            }
            
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
    
    func editCategoryCellSelectedAssignment(SelectedAssignment: Category) {
        
        var textField : [EKProperty.TextFieldContent] = []
        let title = EKProperty.LabelContent(text: "Edit Assignment", style: .init(font: .systemFont(ofSize: 16), color: EKColor.Gray.a800, alignment: .center, numberOfLines: 1))
        let buttonText = EKProperty.LabelContent(text: "Edit", style: .init(font: .systemFont(ofSize: 16), color: .white))
        
        let description1 = EKProperty.LabelContent(text: "\(SelectedAssignment.nameOfAssignment)", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image1 = UIImage(named: "pencil")
        let textField1 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description1, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image1 , bottomBorderColor: .darkGray)
        
        let description2 = EKProperty.LabelContent(text: "\(SelectedAssignment.assignmentTag)", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image2 = UIImage(named: "tag")
        let textField2 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description2, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image2 , bottomBorderColor: .darkGray)
        
        let description3 = EKProperty.LabelContent(text: "\(SelectedAssignment.assignmentDueDate)", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image3 = UIImage(named: "calendar")
        let textField3 = EKProperty.TextFieldContent(keyboardType: .default, placeholder: description3, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image3 , bottomBorderColor: .darkGray, datePicker: true)
        
        let description4 = EKProperty.LabelContent(text: "\(SelectedAssignment.assignmentStartDate)", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image4 = UIImage(named: "calendar")
        let textField4 = EKProperty.TextFieldContent(keyboardType: .default, placeholder: description4, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image4 , bottomBorderColor: .darkGray, datePicker: true)
        
        let description5 = EKProperty.LabelContent(text: "\(SelectedAssignment.assignmentWeighting)", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image5 = UIImage(named: "percent")
        let textField5 = EKProperty.TextFieldContent(keyboardType: .decimalPad, placeholder: description5, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image5 , bottomBorderColor: .darkGray, datePicker: false)
      
        
        
        let button = EKProperty.ButtonContent(label: buttonText, backgroundColor: .flatPurple, highlightedBackgroundColor: .flatBlue) {
           
            var errorCode : Int = 0
            
            
            if textField1.output.count > 0  {
                try! self.realm.write {
                    SelectedAssignment.nameOfAssignment = textField1.output
                }
            }
            
            if textField2.output.count > 0 {
                try! self.realm.write {
                    SelectedAssignment.assignmentTag = textField2.output
                }
            }
            
            if textField3.output.count > 0{
                
                let addedDate = textField3.output
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let dueDate = formatter.date(from: addedDate)
                
                if (dueDate != nil)  {
                    let dueDateInDays = Int ((dueDate?.timeIntervalSince1970)!)/(60*60*24)
                    let startDateInDays = SelectedAssignment.assignmentStartDateInDays
                    if startDateInDays > dueDateInDays {
                        errorCode = 1
                        
                    }
                    else{
                        try! self.realm.write {
                            SelectedAssignment.assignmentDueDate = textField3.output
                            SelectedAssignment.assignmentDateDueInDays = dueDateInDays
  
                        }
                    }
                }
                
            }
            
            if textField4.output.count > 0 {
                let addedDate2 = textField4.output
                let formatter2 = DateFormatter()
                formatter2.dateFormat = "dd/MM/yyyy"
                let startDate = formatter2.date(from: addedDate2)
                
                
                if (startDate != nil)  {
                    let dueDateInDays = SelectedAssignment.assignmentDateDueInDays
                    let startDateInDays = Int ((startDate?.timeIntervalSince1970)!)/(60*60*24)
                    if startDateInDays > dueDateInDays {
                        errorCode = 2
                        
                    }
                    else{
                        try! self.realm.write {
                            
                            SelectedAssignment.assignmentStartDate = textField4.output
                            SelectedAssignment.assignmentStartDateInDays = startDateInDays
                        }
                    }
                }
            }
            
            
            
            if textField5.output.count > 0 {
                let temp = Float(textField5.output)
                if temp == nil{
                    errorCode = 3
                    //Drop.down("Incorrect weighting input", state: .error)
                }
                else {
                    try! self.realm.write {
                        SelectedAssignment.assignmentWeighting = temp!
                    }
                }
            }
            
            switch errorCode {
            case (0):
                 SwiftEntryKit.dismiss()
                 var attributesNotification = EKAttributes.topFloat
                 attributesNotification.entryBackground = .gradient(gradient: .init(colors: [.white, .white], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
                 attributesNotification.displayDuration = 1.3
                 attributesNotification.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                 attributesNotification.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                 attributesNotification.statusBar = .dark
                 attributesNotification.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                 
                 let title = EKProperty.LabelContent(text: "Update", style: .init(font: .systemFont(ofSize: 16), color: .black))
                 let description = EKProperty.LabelContent(text: "Assignment: \(SelectedAssignment.nameOfAssignment) edited ", style: .init(font: .systemFont(ofSize: 12), color: .black))
                 let image = EKProperty.ImageContent(image: UIImage(named: "photo")!, size: CGSize(width: 35, height: 35))
                 let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
                 let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
                 let contentView = EKNotificationMessageView(with: notificationMessage)
                 SwiftEntryKit.display(entry: contentView, using: attributesNotification)
                print("0")
            case (1):
                print("1")
                Drop.down("Starting Date is after Due Date", state: .error)
            case (2):
                Drop.down("Starting Date is after Due Date", state: .error)
                print("2")
            case (3):
                print("3")
                Drop.down("Incorrect weighting input", state: .error)
                
            default:
                print("F. You failed")
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
    
    
    var categories: Results<Category>?
    var todoTasks: Results<Todo>?
    
    //var assignment:Results<Assignment>?
    var assignmentTodos: Results<Todo>?
    
    
    let realm = try! Realm()
    var indexPathAYE : IndexPath = []
    var dateOfVC : Date?
    
    var doneAssignment : Bool = false
    
    
    init(date: Date) {
        super.init(nibName: nil, bundle: nil)
        
        dateOfVC = date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func editCategoryCell(SelectedCategory: Category) {
        var textField : [EKProperty.TextFieldContent] = []
        let title = EKProperty.LabelContent(text: "Edit Category", style: .init(font: .systemFont(ofSize: 16), color: EKColor.Gray.a800, alignment: .center, numberOfLines: 1))
        
        let buttonText = EKProperty.LabelContent(text: "Edit", style: .init(font: .systemFont(ofSize: 16), color: .white))
        let description1 = EKProperty.LabelContent(text: "\(SelectedCategory.nameOfCategory)", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image1 = UIImage(named: "pencil")
        let textField1 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description1, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image1 , bottomBorderColor: .darkGray)
        let description2 = EKProperty.LabelContent(text: "\(SelectedCategory.notes)", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image2 = UIImage(named: "tag")
        let textField2 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description2, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image2 , bottomBorderColor: .darkGray)
        
        let button = EKProperty.ButtonContent(label: buttonText, backgroundColor: .flatPurple, highlightedBackgroundColor: .flatBlue) {
            
            
            if textField1.output.count > 0  {
                try! self.realm.write {
                    SelectedCategory.nameOfCategory = textField1.output
                }
            }
            
            if textField2.output.count > 0 {
                try! self.realm.write {
                    SelectedCategory.notes = textField2.output
                }
            }

                //Notification that New Category was Created
                var attributesNotification = EKAttributes.topFloat
                attributesNotification.entryBackground = .gradient(gradient: .init(colors: [.white, .white], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
                attributesNotification.displayDuration = 1.3
                attributesNotification.popBehavior = .animated(animation: .init(translate: .init(duration: 0.3), scale: .init(from: 1, to: 0.7, duration: 0.7)))
                attributesNotification.shadow = .active(with: .init(color: .black, opacity: 0.5, radius: 10, offset: .zero))
                attributesNotification.statusBar = .dark
                attributesNotification.scroll = .enabled(swipeable: true, pullbackAnimation: .jolt)
                let title = EKProperty.LabelContent(text: "Update", style: .init(font: .systemFont(ofSize: 16), color: .black))
                let description = EKProperty.LabelContent(text: "Category: \(SelectedCategory.nameOfCategory) edited", style: .init(font: .systemFont(ofSize: 12), color: .black))
                let image = EKProperty.ImageContent(image: UIImage(named: "photo")!, size: CGSize(width: 35, height: 35))
                let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
                let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
                let contentView = EKNotificationMessageView(with: notificationMessage)
                SwiftEntryKit.display(entry: contentView, using: attributesNotification)
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
    
    func showAlertNotPinned(SelectedCategory : Category) {
        
        var textField : [EKProperty.TextFieldContent] = []
        let title = EKProperty.LabelContent(text: "Create New Task", style: .init(font: .systemFont(ofSize: 16), color: EKColor.Gray.a800, alignment: .center, numberOfLines: 1))
        let buttonText = EKProperty.LabelContent(text: "Create", style: .init(font: .systemFont(ofSize: 16), color: .white))
        
        let description1 = EKProperty.LabelContent(text: "Task Name", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image1 = UIImage(named: "pencil")
        let textField1 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description1, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image1 , bottomBorderColor: .darkGray)
        
        let button = EKProperty.ButtonContent(label: buttonText, backgroundColor: .flatPurple, highlightedBackgroundColor: .flatBlue) {
            
            if SelectedCategory != nil && (textField1.output.count > 0) {
                do {
                    try self.realm.write {
                        let newItem = Todo()
                        newItem.todoName = textField1.output
                        newItem.pinned = false
                        newItem.dateCreatedInDays = Int ((self.dateOfVC?.timeIntervalSince1970)!/(60*60*24))
                        print(newItem.dateCreatedInDays)
                        SelectedCategory.theTasks.append(newItem)
                        SwiftEntryKit.dismiss()
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            else {
                Drop.down("Incorrect inputs", state: .error)
            }
            
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
            if SelectedCategory != nil && (textField1.output.count > 0){
                do {
                    try self.realm.write {
                        let newItem = Todo()
                        newItem.todoName = textField1.output
                        newItem.pinned = true
                        newItem.dateCreatedInDays = Int ((self.dateOfVC?.timeIntervalSince1970)!/(60*60*24))
                        print(newItem.dateCreatedInDays)
                        SelectedCategory.theTasks.append(newItem)
                        SwiftEntryKit.dismiss()
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
            }
            else {
                Drop.down("Incorrect inputs", state: .error)
            }
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
        tableView.register(UINib(nibName: "assignmentCellTableViewCell", bundle: nil) , forCellReuseIdentifier: "assignmentCell")
        
        tableView.backgroundColor = UIColor.init(hexString: "#f6f6f7", withAlpha: 1)
        
        // tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    /// --- LOAD FROM REALM --- ///
    func loadCategories() {
        let dateOfVCinDays = Int ((dateOfVC?.timeIntervalSince1970)!)/(60*60*24)
        print(dateOfVCinDays)
        categories  = realm.objects(Category.self).filter("isAssignment==false OR (\(dateOfVCinDays) >= assignmentStartDateInDays AND \(dateOfVCinDays) <= assignmentDateDueInDays AND isAssignment==true )").sorted(byKeyPath: "isAssignment", ascending: false)
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
        
        guard case let cell as FoldingCell = cell else {
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
        
        
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        
        
        if let category = categories?[indexPath.row] {
            
            if category.isAssignment == true {
                let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath) as! assignmentCellTableViewCell
                cell.delegate = self
                cell.dateOfViewController = dateOfVC
                cell.selectedAssignment = category
                cell.assignmentTag?.text = category.assignmentTag
                cell.assignmentClosedName?.text = category.nameOfAssignment
                // cell.openClosedName?.text = category.nameOfAssignment
                cell.course?.text = category.assignmentTag
                cell.subject?.text = category.nameOfAssignment
                
                cell.weighting?.text = String("\(category.assignmentWeighting)%")
                //cell.weighting2?.text = String("\(category.assignmentWeighting)%")
                
                
                let addedDate = category.assignmentDueDate
                let formatter = DateFormatter()
                formatter.dateFormat = "dd/MM/yyyy"
                let dueDate = formatter.date(from: addedDate)
                
                if dueDate != nil {
                    let dueDateInDays = Int ((dueDate?.timeIntervalSince1970)!)/(60*60*24)
                    let dateOfVCinDays = Int ((dateOfVC?.timeIntervalSince1970)!)/(60*60*24)
                    var daysLeftInDays = dueDateInDays - dateOfVCinDays
                    cell.daysDue?.text = "D - \(daysLeftInDays )"
                    // cell.daysDue2?.text = "D - \(daysLeftInDays)"
                }
                else{
                    cell.daysDue?.text = "D - "
                    //  cell.daysDue2?.text = "D - "
                }
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let date = dateFormatter.date(from: category.assignmentDueDate )
                if date != nil {
                    dateFormatter.dateFormat = "MMM dd, yyyy"
                    let goodDate = dateFormatter.string(from: date!)
                    cell.dueDate?.text = "Due Date:    \(goodDate)"
                }
                else{
                    cell.dueDate?.text = ""
                }
                
                let dateFormatter2 = DateFormatter()
                dateFormatter2.dateFormat = "dd/MM/yyyy"
                let date2 = dateFormatter2.date(from: category.assignmentStartDate)
                if date2 != nil {
                    dateFormatter2.dateFormat = "MMM dd, yyyy"
                    let goodDate2 = dateFormatter2.string(from: date2!)
                    cell.startDate?.text = "Start Date:   \(goodDate2)"
                }
                else{
                    cell.dueDate?.text = ""
                }
                
                cell.durationsForExpandedState = durations
                cell.durationsForCollapsedState = durations
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "customTaskCell", for: indexPath) as! DemoCell
                cell.delegate = self
                cell.dateOfViewController = dateOfVC
                cell.selectedCategory = category
                cell.Label?.text = category.notes
                cell.closeNumberLabel?.text = category.nameOfCategory
                cell.openNumberLabel?.text = category.nameOfCategory
                cell.durationsForExpandedState = durations
                cell.durationsForCollapsedState = durations
                return cell
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "assignmentCell", for: indexPath) as! assignmentCellTableViewCell
        return cell
    }
    
    
    
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        indexPathAYE = indexPath
        
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
        
        
        if let item = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item.theTasks)
                    realm.delete(item)
                }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
        
        
    }
}




