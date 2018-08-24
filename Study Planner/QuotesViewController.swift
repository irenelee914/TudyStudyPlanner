//
//  QuotesViewController.swift
//  Study Planner
//
//  Created by Hojoon Lee on 2018-08-24.
//  Copyright © 2018 Irene Lee. All rights reserved.
//

import UIKit
import Alamofire
import Pastel
import SwiftyJSON

class QuotesViewController: UIViewController {

    let URL = "https://quotes.rest/qod"
    
    
    @IBAction func generateButton(_ sender: UIButton) {
    }
    @IBOutlet weak var quote: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let params : [String : String] = ["category" : "inspire"]
        
        getQuote(url: URL, parameters: params)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Do any additional setup after loading the view.
        
        let pastelView = PastelView(frame: view.bounds)
        
        // Custom Direction
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 1.0
        
        // Custom Color
        
                pastelView.setColors([UIColor.init(hexString: "#8ec5fc")!,
                                      UIColor.init(hexString: "#e0c3fc")!,
                                      UIColor.init(hexString: "#a6c1ee")!,
                                      UIColor.init(hexString: "#fbc2eb")!])

        
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    
    func getQuote(url: String, parameters: [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Success! Got the quote data")
                let quoteJSON : JSON = JSON(response.result.value!)
                
                
                print(quoteJSON)
                
                self.updateQuote(json: quoteJSON)
                
            }
            else {
                print("Error \(String(describing: response.result.error))")
                self.quote.text = "Connection Issues"
            }
        }
        
    }
    
    func updateQuote(json : JSON) {
        
        let quoteResult = json["contents"]["quotes"][0]["quote"].stringValue
        
        quote.text = " \"\(quoteResult)\" "
        
        
        
        
    }
    

    
}
