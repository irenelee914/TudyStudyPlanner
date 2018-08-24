//
//  CourseMarksVC.swift
//  Study Planner
//
//  Created by Hojoon Lee on 2018-08-23.
//  Copyright © 2018 Irene Lee. All rights reserved.
//

import UIKit
import ScrollableGraphView
import CenteredCollectionView
import RealmSwift
import SwiftEntryKit
import SwiftyDrop

class CourseMarksVC: UIViewController,ScrollableGraphViewDataSource, UICollectionViewDataSource,GradesCellDelegate, UICollectionViewDelegate {

    
    
    let realm = try! Realm()
    var grades : Results<Grades>?
    var selectedCourse : Course?
    
    
    
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    
    @IBOutlet weak var markLabel: UILabel!
    @IBOutlet weak var myCollectionView: UICollectionView!

    @IBOutlet weak var myGraphView: ScrollableGraphView!
    @IBAction func addNewGrades(_ sender: UIBarButtonItem) {
        var textField : [EKProperty.TextFieldContent] = []
        let title = EKProperty.LabelContent(text: "Add new Grade", style: .init(font: .systemFont(ofSize: 16), color: EKColor.Gray.a800, alignment: .center, numberOfLines: 1))
        let buttonText = EKProperty.LabelContent(text: "Add", style: .init(font: .systemFont(ofSize: 16), color: .white))
        
        let description1 = EKProperty.LabelContent(text: "Assessment Name", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image1 = UIImage(named: "pencil")
        let textField1 = EKProperty.TextFieldContent(keyboardType: .emailAddress, placeholder: description1, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image1 , bottomBorderColor: .darkGray)
        
        let description2 = EKProperty.LabelContent(text: "Grade (%)", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image2 = UIImage(named: "percent")
        let textField2 = EKProperty.TextFieldContent(keyboardType: .decimalPad, placeholder: description2, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image2 , bottomBorderColor: .darkGray)
        
        let description3 = EKProperty.LabelContent(text: "Weighting (%)", style: .init(font: .systemFont(ofSize: 10), color: .darkGray))
        let image3 = UIImage(named: "percent")
        let textField3 = EKProperty.TextFieldContent(keyboardType: .decimalPad, placeholder: description3, textStyle: .init(font: .systemFont(ofSize: 10), color: .black), isSecure: false, leadingImage: image3 , bottomBorderColor: .darkGray)
        
        let button = EKProperty.ButtonContent(label: buttonText, backgroundColor: .flatPurple, highlightedBackgroundColor: .flatBlue) {
            
            let temp1 = Float(textField2.output)
            let temp2 = Float(textField3.output)
            
            if self.selectedCourse == nil || (textField1.output.count <= 0) {
                Drop.down("Missing Inputs", state: .error)
            }
            else if temp1 == nil {
                Drop.down("Incorrect Grade input", state: .error)
            }
            else if temp2 == nil {
                Drop.down("Incorrect Weighting input", state: .error)
            }
            else {
                do {
                    try self.realm.write {
                        let newGrade = Grades()
                        newGrade.nameOfGrade = textField1.output
                        newGrade.mark = temp1!
                        newGrade.weighting = temp2!
                        self.selectedCourse?.theGrades.append(newGrade)
                        self.selectedCourse?.courseAverage = self.averageCalc()
                        
                        
                     
                        SwiftEntryKit.dismiss()
                        
                    }
                } catch {
                    print("Error saving new items, \(error)")
                }
                self.loadGrades()
                //self.setupGraph()
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
        textField.append(textField2)
        textField.append(textField3)
        
        if textField != nil {
            let contentView = EKFormMessageView(with: title, textFieldsContent: textField, buttonContent: button)
            SwiftEntryKit.display(entry: contentView, using: attributes)
        }
        
        
      
    }
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centeredCollectionViewFlowLayout = myCollectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout
        
        
        // Modify the collectionView's decelerationRate (REQURED STEP)
        myCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        // Assign delegate and data source
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
        // Configure the required item size (REQURED STEP)
        let cellPercentWidth: CGFloat = 0.6
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            
            width: view.bounds.width * cellPercentWidth,
            height: view.bounds.height * cellPercentWidth * cellPercentWidth * 0.6
        )
        
        // Configure the optional inter item spacing (OPTIONAL STEP)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 20
        
        // Get rid of scrolling indicators
        myCollectionView.showsVerticalScrollIndicator = false
        myCollectionView.showsHorizontalScrollIndicator = false
        
        //register nib
        let nibName = UINib(nibName: "GradesCell", bundle:nil)
        myCollectionView?.register(nibName, forCellWithReuseIdentifier: "GradesCell")
        myCollectionView?.backgroundColor = UIColor.init(hexString: "#f6f6f7", withAlpha: 1)
        
        //load
        
        loadGrades()
        setupGraph()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return grades?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "GradesCell", for: indexPath) as! GradesCell
        cell.delegate = self
        
        if let gradesCell = grades?[indexPath.row]{
            // gradeCellIndex = gradeCellIndex + 1
            cell.gradeName.text = gradesCell.nameOfGrade
            cell.selectedGrade = gradesCell
            cell.cellIndex.text = "#\(indexPath.row+1)"
            cell.grade.text = "\(gradesCell.mark) %"
            cell.weighting.text = "\(gradesCell.weighting) %"
        }
        return cell
    }
    
    //MARK: Protocol delete Grades Cell
    func deleteMark(selectedGrade : Grades){
        print("hello")
            do {
                try self.realm.write{
                    self.realm.delete(selectedGrade)
                     self.selectedCourse?.courseAverage = self.averageCalc()
                }
            }catch {
                print("Error in deleting Grade Cell")
            }
        
        loadGrades()
        //myGraphView.reload()
     
    }
    
    //MARK: Load Grades From Realm
    func loadGrades(){
        grades = selectedCourse?.theGrades.filter("mark == 0 || mark != 0")
        let average = selectedCourse?.courseAverage ?? 0
        self.markLabel.text = "\(average)%"
        myCollectionView.reloadData()
        
    }
    
    //MARK: Calculate Average
    func averageCalc() -> Float {
        let count = grades?.count ?? 0
        var totalWeight : Float = 0
        var totalSum : Float = 0
        
        for index in 0..<count {
            
            if let mark = grades?[index] {
            totalWeight =  totalWeight + mark.weighting
            totalSum = totalSum + (mark.mark) * (mark.weighting)
            }
        }
        if totalWeight == 0{
            return 0
        }
        return totalSum / totalWeight

    }
    
    func setupGraph(){
        //let graphView1 = ScrollableGraphView(frame: graphView.frame, dataSource: self)
        myGraphView.dataSource = self
        // Setup the line plot.
        let linePlot = LinePlot(identifier: "darkLine")
        
        linePlot.lineWidth = 1
  
        linePlot.lineColor = UIColor.init(hexString: "#777777")!
        linePlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        linePlot.shouldFill = true
        linePlot.fillType = ScrollableGraphViewFillType.gradient
        linePlot.fillGradientType = ScrollableGraphViewGradientType.linear
        linePlot.fillGradientStartColor = UIColor.white
        linePlot.fillGradientEndColor = UIColor.white
        
        linePlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let dotPlot = DotPlot(identifier: "darkLineDot") // Add dots as well.
        dotPlot.dataPointSize = 2
        dotPlot.dataPointFillColor = UIColor.flatPlum
        
        dotPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the reference lines.
        let referenceLines = ReferenceLines()
        
        referenceLines.referenceLineLabelFont = UIFont.boldSystemFont(ofSize: 8)
        referenceLines.referenceLineColor = UIColor.black
        referenceLines.referenceLineLabelColor = UIColor.black
        
        referenceLines.positionType = .absolute
        // Reference lines will be shown at these values on the y-axis.
        referenceLines.absolutePositions = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        referenceLines.includeMinMax = false
        
        referenceLines.dataPointLabelColor = UIColor.flatPlum
        
        // Setup the graph
        myGraphView.backgroundFillColor = UIColor.white
        myGraphView.dataPointSpacing = 80
        
        myGraphView.shouldAnimateOnStartup = true
        myGraphView.shouldAdaptRange = true
        myGraphView.shouldRangeAlwaysStartAtZero = true
        
        myGraphView.rangeMax = 50
        
        // Add everything to the graph.
        myGraphView.addReferenceLines(referenceLines: referenceLines)
        myGraphView.addPlot(plot: linePlot)
        myGraphView.addPlot(plot: dotPlot)
        
        //view.addSubview(graphView1)
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
            if let mark = grades?[pointIndex] {
                return Double(mark.mark)
            }
        return 0
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "\(pointIndex + 1)"
    }
    
    func numberOfPoints() -> Int {
        return (grades?.count) ?? 0
    }
    
    
    
    
    
}

