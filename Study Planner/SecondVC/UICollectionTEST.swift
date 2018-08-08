//
//  UICollectionTEST.swift
//  Study Planner
//
//  Created by Hojoon Lee on 2018-08-06.
//  Copyright © 2018 Irene Lee. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftEntryKit
import SwiftyDrop

class UICollectionTEST: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    //set up Variables
    let realm = try! Realm()
    var courses: Results<Course>?
    
    
    
    
    fileprivate let cellId = "CollectionViewCell"
    @IBAction func addNewCourse(_ sender: UIBarButtonItem) {
        
        var textField : [EKProperty.TextFieldContent] = []
        let title = EKProperty.LabelContent(text: "Add New Course", style: .init(font: .systemFont(ofSize: 16), color: EKColor.Gray.a800, alignment: .center, numberOfLines: 1))
        let buttonText = EKProperty.LabelContent(text: "Add", style: .init(font: .systemFont(ofSize: 16), color: .white))
        let description1 = EKProperty.LabelContent(text: "Course Title", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image1 = UIImage(named: "pencil")
        let textField1 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description1, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image1 , bottomBorderColor: .darkGray)

        
        let button = EKProperty.ButtonContent(label: buttonText, backgroundColor: .flatPurple, highlightedBackgroundColor: .flatBlue) {
            
            if (textField1.output.count > 0 ){
                //Create New Category
                let newCourse = Course()
                newCourse.nameOfCourse = textField1.output
                self.save(course: newCourse)
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
                let description = EKProperty.LabelContent(text: "New Course: \(newCourse.nameOfCourse) Added", style: .init(font: .systemFont(ofSize: 12), color: .black))
                let image = EKProperty.ImageContent(image: UIImage(named: "photo")!, size: CGSize(width: 35, height: 35))
                let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
                let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)
                let contentView = EKNotificationMessageView(with: notificationMessage)
                SwiftEntryKit.display(entry: contentView, using: attributesNotification)
                self.loadCourses()
                
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
            let contentView = EKFormMessageView(with: title, textFieldsContent: textField, buttonContent: button)
            SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    @IBOutlet weak var myCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.navigationBar.barTintColor = UIColor.clear
    }
    
    override func viewDidLoad() {
        let backImage = UIImage(named: "backf")
        
        self.navigationController?.navigationBar.backIndicatorImage = backImage
        
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
        self.navigationController?.navigationBar.tintColor = UIColor.white
        /*** If needed Assign Title Here ***/
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        let nibName = UINib(nibName: cellId, bundle:nil)
        myCollectionView?.register(nibName, forCellWithReuseIdentifier: cellId)
        myCollectionView?.backgroundColor = UIColor.init(hexString: "#f6f6f7", withAlpha: 1)
        
        let numberOfCellsPerRow: CGFloat = 2
        if let flowLayout = myCollectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
            let cellWidth = (myCollectionView.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth*1.1)
            print(cellWidth)
            print(cellWidth*1.1)
        }
        loadCourses()
    }
    
    //SAVE to Realm
    func save(course: Course){
        do{
            try realm.write{
                realm.add(course)
            }
        }catch {
            print("Error saving Course")
        }
    }
    
    //LOAD from Realm
    func loadCourses(){
        courses = realm.objects(Course.self)
        myCollectionView.reloadData()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCell
        
        if let courseCell = courses?[indexPath.row]{
            cell.courseName.text = courseCell.nameOfCourse
            cell.averageMark = courseCell.courseAverage
            
            let average : CGFloat = CGFloat(courseCell.courseAverage)
            cell.progressRing.startProgress(to: average, duration: 2.0) {
                print("Done animating!")
                // Do anything your heart desires...
            }
        }
        
        return cell
    }


    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (courses?.count) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toCourseMarks", sender: self)
        //courses[indexPath.item]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let destinationVC = segue.destination as! CourseMarksVC
        
        if let indexPath = self.myCollectionView.indexPathsForSelectedItems {
            destinationVC.selectedCourse = self.courses?[(indexPath.first?.item)!]
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
         self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    
}
