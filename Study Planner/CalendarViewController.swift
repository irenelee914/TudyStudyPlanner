//import UIKit
//import FoldingCell
//
//class CalendarViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
//
//
//    private let myArray: NSArray = ["First","Second","Third"]
//    private var myTableView: UITableView!
//
//
//
//  init(date: Date) {
//    super.init(nibName: nil, bundle: nil)
//
//
//    let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
//    let displayWidth: CGFloat = self.view.frame.width
//    let displayHeight: CGFloat = self.view.frame.height
//
//    myTableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight - barHeight))
//    myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "HELLO")
//    //myTableView.register(UINib(nibname:"DEMOTableViewCell",bundle:nil),forcellResuseIdentifier: "HELLO")
//    //myTableView.register(DEMOTableViewCell.self, forCellReuseIdentifier: "HELLO")
//    //myTableView.register(UINib(nibName: "DEMOCustomCell", bundle: nil) , forCellReuseIdentifier: "DEMOCustomCell")
////    myTableView.register(UINib(nibName: "MessageCell", bundle: nil) , forCellReuseIdentifier: "customMessageCell")
//    myTableView.dataSource = self
//    myTableView.delegate = self
//    self.view.addSubview(myTableView)
//
//
//
//
//
////
////    let label = UILabel(frame: .zero)
////    label.font = UIFont.systemFont(ofSize: 50, weight: UIFont.Weight.thin)
////    label.textColor = UIColor(red: 95/255, green: 102/255, blue: 108/255, alpha: 1)
////
////    //this displays the text for each VC
////    label.text = DateFormatters.shortDateFormatter.string(from: date)
////    label.sizeToFit()
////
////    view.addSubview(label)
////    view.constrainCentered(label)
////    view.backgroundColor = .white
//  }
//
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
////        let displayWidth: CGFloat = self.view.frame.width
////        let displayHeight: CGFloat = self.view.frame.height
////
////        myTableView = UITableView(frame: CGRect(x: 0, y: barHeight, width: displayWidth, height: displayHeight - barHeight))
////        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
////        myTableView.dataSource = self
////        myTableView.delegate = self
////        self.view.addSubview(myTableView)
////    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Num: \(indexPath.row)")
//        print("Value: \(myArray[indexPath.row])")
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return myArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HELLO", for: indexPath as IndexPath) as! UITableViewCell
//
////        let cell = tableView.dequeueReusableCell(withIdentifier: "customMessageCell", for: indexPath) as! DemoCell
//        cell.textLabel!.text = "\(myArray[indexPath.row])"
//        return cell
//    }
//
//
//
//  required init?(coder: NSCoder) {
//    fatalError("init(coder:) has not been implemented")
//  }
//
//}



import UIKit
import FoldingCell

class CalendarViewController: UITableViewController {
    
//    init(date: Date) {
//        super.init(nibName: nil, bundle: nil)
//        
//    }
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
        static let rowsCount = 10
    }
    
    var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        return 10
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as DemoCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.number = indexPath.row
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customTaskCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
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




