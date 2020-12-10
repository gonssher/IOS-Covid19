//
//  ViewController.swift
//  Assignment2_SherwinGonsalves_991489757
//
//  Created by Sherwin Gonsalves on 2020-11-20.
//

import UIKit
import SpriteKit
import GameplayKit



class ViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    

    @IBOutlet weak var pickerView : UIPickerView!
    @IBOutlet weak var labelToday : UILabel!
    @IBOutlet weak var labelTotal : UILabel!
    @IBOutlet weak var skView: SKView!
    var scene: ChartScene!
    
    
    var dates = [String]()
    var dateSet: Set<String> = [] // create a temp set
    var passedIndexvalue : Int = -1
    var values = [Int]()
    var jsonPassData = [[String:Any]]()

    
    @IBOutlet weak var provinceselction: UISegmentedControl!
    var provincePass : String = ""
    var passDate : String = ""
    let selectedINdex = 0
    override func viewDidLoad() {
     
        super.viewDidLoad()
        requestJson()
        pickerView.delegate = self
        pickerView.dataSource = self
        provincePass = "Canada"
        DispatchQueue.main.async
        {
           self.pickerView.reloadAllComponents()
        }
        
        provinceselction.selectedSegmentIndex = selectedINdex
        if let scene = SKScene(fileNamed: "ChartScene")
        {
            scene.scaleMode = .aspectFit
            skView.presentScene(scene)
            skView.showsFPS = true
            skView.showsNodeCount = true

        }

        
    }


    
    @IBAction func changeProvince(_ sender: Any) {
        
        if provinceselction.selectedSegmentIndex == 0
        {
            self.pickerView.reloadComponent(0)
            self.pickerView.selectRow(self.dates.count-1,inComponent: 0, animated: false)
            passedIndexvalue = dates.count-1
            passDate = String(dates.last!)
            labelToday.text = "N/A"
            labelTotal.text = "N/A"
            let province = "Canada"
            provincePass = province
            print(passDate)
            self.passProvinceData(_Country: provincePass)
           print("Loading Cases For Picker Index Value 0 \(provincePass)")
            
        }
        else if provinceselction.selectedSegmentIndex == 1
        {
            self.pickerView.reloadComponent(0)
            self.pickerView.selectRow(self.dates.count-1,inComponent: 0, animated: false)
            passedIndexvalue = dates.count-1
            passDate = String(dates.last!)
            labelToday.text = "N/A"
            labelTotal.text = "N/A"
            let province = "Ontario"
            provincePass = province
            self.passProvinceData(_Country: provincePass)
           print("Loading Cases For Picker Index Value 1 \(provincePass)")
        }
        else if provinceselction.selectedSegmentIndex == 2
        {
            self.pickerView.reloadComponent(0)
            self.pickerView.selectRow(self.dates.count-1 ,inComponent: 0, animated: false)
            passedIndexvalue = dates.count-1
            passDate = String(dates.last!)
            labelToday.text = "N/A"
            labelTotal.text = "N/A"
            let province = "Quebec"
            provincePass = province
            print(passDate)
            self.passProvinceData(_Country: provincePass)

           print("Loading Cases For Picker Index Value 2 \(provincePass)")
        }
        else if provinceselction.selectedSegmentIndex == 3
        
        {
            self.pickerView.reloadComponent(0)
            self.pickerView.selectRow(self.dates.count-1 ,inComponent: 0, animated: false)
            passedIndexvalue = dates.count-1
            passDate = String(dates.last!)
            labelToday.text = "N/A"
            labelTotal.text = "N/A"
            let province = "British Columbia"
            provincePass = province
            print(passDate)
            self.passProvinceData(_Country: provincePass)
           print("Loading Cases For Picker Index Value 3 \(provincePass)")

        }
 
    }
    

    func requestJson()
    {
        let url = URL(string:"http://ejd.songho.ca/ios/covid19.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                self.parseJson(data!)
            }
            else if let error = error
            {
                self.showAlert(message: error.localizedDescription)
                return
            }
            
        }.resume()
     
    }
    

    
    func parseJson(_ data: Data)
    {
     do
     {
     if let json = try JSONSerialization.jsonObject(with:data,
     options:[]) as? [[String:Any]]
     {
        self.jsonPassData = json
        
        for dict in json// json is array of dictionaries
        {
            if let date = dict["date"] as? String {
             dateSet.insert(date)
             }
            self.dates = dateSet.sorted()

        }
  
        if passedIndexvalue == -1
        {
            DispatchQueue.main.async
            {
           self.labelToday.text = "N/A"
           self.labelTotal.text = "N/A"
                self.pickerView.reloadComponent(0)
                self.pickerView.selectRow(self.dates.count-1 ,inComponent: 0, animated: false)
                
            }
            let prov = provincePass
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
        
            let SecPerDay: Double = 60 * 60 * 24 // seconds a day
            let firstDate = formatter.date(from: dates.first!) ?? Date()
            let lastDate = formatter.date(from: dates.last!) ?? Date()
            let sec = lastDate.timeIntervalSince(firstDate)
            let dayCount = Int(sec / SecPerDay + 0.5) + 1
            self.values = [Int](repeating: 0, count: dayCount)
            for i in 0 ..< values.count
                {
                let date = firstDate.addingTimeInterval(Double(i) * SecPerDay)
                let dateStrs = formatter.string(from: date)
                    
                if let index = json.firstIndex(where: { $0["prname"] as? String == prov && $0["date"] as? String == dateStrs })
                {
                    values[i] = json[index]["numtoday"] as? Int ?? 0
                }
                    
                }
                print(values)
            print("No Data Available as yet")
        if let scene = skView.scene as? ChartScene
        {
            scene.updateChart(values)
        }

        }
        
     }
     
        }
        catch
        {
            showAlert(message: "Erro Parsing Data")
            return
        }
    }
    
    func showAlert(title:String = "Error", message:String)
    {

        DispatchQueue.main.async {
  
    let alert = UIAlertController(title: "Failure To Load", message:"Please re load Application", preferredStyle:.alert)
    // add default button
    alert.addAction(UIAlertAction(title:"OK", style:.default, handler:nil))
    // show it
    self.present(alert, animated:true, completion:nil)
    }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     
        return dates.count
    }
    
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

    return dates[row]

    
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    
        let selectedDate = dates[row]
        passDate = selectedDate
        let index = pickerView.selectedRow(inComponent: 0)
        passedIndexvalue = index
        self.passProvinceData(_Country: provincePass)
        
        
  /*      ********* TESTiING USER DATA **********
        print("Selected Index Value \(index)");
        print("Selected Date  " + selectedDate);
 */
        
 }
 
    
    
    
    func passProvinceData(_Country : String)
    
    {
        let prov = provincePass
        let dateStr = self.pickerView(pickerView, titleForRow: passedIndexvalue, forComponent: 0) ?? ""
        
       // let prov = provincePass
       // let dateStr = self.pickerView(pickerView, titleForRow: passedIndexvalue, forComponent: 0) ?? ""
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
           // let dateString = "2020-01-31"
            let SecPerDay: Double = 60 * 60 * 24 // seconds a day
            let firstDate = formatter.date(from: dates.first!) ?? Date()
            let lastDate = formatter.date(from: passDate) ?? Date()
            let sec = lastDate.timeIntervalSince(firstDate)
            let dayCount = Int(sec / SecPerDay + 0.5) + 1

            self.values = [Int](repeating: 0, count: dayCount)
            for i in 0 ..< values.count
                {
                
                let date = firstDate.addingTimeInterval(Double(i) * SecPerDay)
                let dateStrs = formatter.string(from: date)
                    
                if let index = jsonPassData.firstIndex(where: { $0["prname"] as? String == prov && $0["date"] as? String == dateStrs })
                {
                    // found date, put the value from JSON
                    values[i] = jsonPassData[index]["numtoday"] as? Int ?? 0
                }
                    
                }
            if let scene = skView.scene as? ChartScene
            {
            
                scene.updateChart(values)
                
            }
        
        if let i = jsonPassData.firstIndex(where: { $0["prname"] as? String == prov && $0["date"] as? String == dateStr })
        {
      
            DispatchQueue.main.async
            {
            
                self.labelToday.text =  ("Daily \n \(String(self.jsonPassData[i]["numtoday"] as? Int ?? 0)) ")
                self.labelTotal.text = ("Total \n \(String(self.jsonPassData[i]["numtotal"] as? Int ?? 0)) ")
                
                /*      ********* TESTiING USER DATA **********
                print((" ************************** Province Data for \(String((self.jsonPassData[i]["prname"] as? String)!)) ************************"))
                print("Passed index value from picker view is \(self.passedIndexvalue)");
                print("Date Selected is \(self.passDate)")
                print( "Daily Cases are \(String(self.jsonPassData[i]["numtoday"] as? Int ?? 0)) ")
                print("Total Cases are \(String(self.jsonPassData[i]["numtotal"] as? Int ?? 0)) ")
                print((" *********************************** The End **********************************"))
                 */
            }
            
         
        }
        
        else {
            DispatchQueue.main.async
            {
                self.labelToday.text = "N/A"
                self.labelTotal.text = "N/A"
                print("No Data Available for this date ")
            }
           
        }
        
    }
    
  
}

