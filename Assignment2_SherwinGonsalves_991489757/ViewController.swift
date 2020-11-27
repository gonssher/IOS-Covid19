//
//  ViewController.swift
//  Assignment2_SherwinGonsalves_991489757
//
//  Created by Sherwin Gonsalves on 2020-11-20.
//

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource, UIPickerViewDelegate {
    
   
    var covidDate = [Covid]()
    @IBOutlet weak var pickerView : UIPickerView!
    @IBOutlet weak var labelToday : UILabel!
    @IBOutlet weak var labelTotal : UILabel!
    var dates = [String]()
    var dateSet: Set<String> = [] // create a temp set
    var passedIndexvalue : Int = -1
    @IBOutlet weak var provinceselction: UISegmentedControl!
    var provincePass : String = ""
    var passDate : String = ""
    
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
    }

    @IBAction func changeProvince(_ sender: Any) {
        
        if provinceselction.selectedSegmentIndex == 0
        {
            self.pickerView.reloadComponent(0)
            self.pickerView.selectRow(self.dates.count-1,inComponent: 0, animated: false)
            passedIndexvalue = dates.count-1
            labelToday.text = "N/A"
            labelTotal.text = "N/A"
            let province = "Canada"
            provincePass = province
            requestJson()
         
           print("Loading Cases For Picker Index Value 0 \(provincePass)")
            
        }
        else if provinceselction.selectedSegmentIndex == 1
        {
            self.pickerView.reloadComponent(0)
            self.pickerView.selectRow(self.dates.count-1 ,inComponent: 0, animated: false)
            passedIndexvalue = dates.count-1
            labelToday.text = "N/A"
            labelTotal.text = "N/A"
            let province = "Ontario"
            provincePass = province
            requestJson()
            
           print("Loading Cases For Picker Index Value 1 \(provincePass)")
        }
        else if provinceselction.selectedSegmentIndex == 2
        {
            self.pickerView.reloadComponent(0)
            self.pickerView.selectRow(self.dates.count-1 ,inComponent: 0, animated: false)
            passedIndexvalue = dates.count-1
            labelToday.text = "N/A"
            labelTotal.text = "N/A"
            let province = "Quebec"
            provincePass = province
            requestJson()
           print("Loading Cases For Picker Index Value 2 \(provincePass)")
        }
        else if provinceselction.selectedSegmentIndex == 3
        
        {
            self.pickerView.reloadComponent(0)
            self.pickerView.selectRow(self.dates.count-1 ,inComponent: 0, animated: false)
            passedIndexvalue = dates.count-1
            labelToday.text = "N/A"
            labelTotal.text = "N/A"
            let province = "British Columbia"
            provincePass = province
            requestJson()
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
            }
        print("No Data Available for this index value as yet \(dates.count-1)")
        }
        
 
        else
        {

        let prov = provincePass
        let dateStr = self.pickerView(pickerView, titleForRow: passedIndexvalue, forComponent: 0) ?? ""
    
        if let i = json.firstIndex(where: { $0["prname"] as? String == prov && $0["date"] as? String == dateStr })
        {
            DispatchQueue.main.async
            {
            
                self.labelToday.text =  ("Daily \n \(String(json[i]["numtoday"] as? Int ?? 0)) ")
                self.labelTotal.text = ("Total \n \(String(json[i]["numtotal"] as? Int ?? 0)) ")
              
                //Testing Data
                print((" ************************** Province Data for \(String((json[i]["prname"] as? String)!)) ************************"))
                print("Passed index value from picker view is \(self.passedIndexvalue)");
                print("Date Selected is \(self.passDate)")
                print( "Daily Cases are \(String(json[i]["numtoday"] as? Int ?? 0)) ")
                print("Total Cases are \(String(json[i]["numtotal"] as? Int ?? 0)) ")
                print((" *********************************** The End **********************************"))
            }
          
        
            
        }
        else {
            
            DispatchQueue.main.async
            {
                self.labelToday.text = "N/A"
                self.labelTotal.text = "N/A"
                print("No Data Available for this date \(self.passDate)")
            }
        }
   
     }
     }
     
     else
     {
        return
     }
     // draw chart first time after parsing JSON
        DispatchQueue.main.async
        {
            if self.passedIndexvalue == -1
        {
            
        self.pickerView.reloadComponent(0)
        self.pickerView.selectRow(self.dates.count-1 ,inComponent: 0, animated: false)
        }
        
        }
        }
        catch
        {

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
        //print("Selected Date  " + selectedDate);
        passDate = selectedDate
        let index = pickerView.selectedRow(inComponent: 0)
     //   print("Selected Index Value \(index)");
        passedIndexvalue = index
        requestJson()
    
    }
  
}

