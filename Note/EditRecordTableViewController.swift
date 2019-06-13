import UIKit

class EditRecordTableViewController: UITableViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    var record: Record?
    // check whether this is use to edit a current data , or adding a new one
    var add = false

    @IBOutlet weak var DateTextField: UITextField!
    @IBOutlet weak var AmountTextField: UITextField!
    @IBOutlet weak var TypeTextField: UITextField!
    @IBOutlet weak var DescribeTextView: UITextView!
    
    let type = ["正餐","宵夜","飲料","學費","房租","課金","治裝","罰款","通訊","水電","保險","其他"]
    
    var YearFormatter : DateFormatter! = nil
    var MonthFormatter : DateFormatter! = nil
    var DayFormatter : DateFormatter! = nil
    var WeekFormatter : DateFormatter! = nil
    
    var year:String!
    var month:String!
    var day:String!
    var week:String!
    // create a UIDatePicker
    var myDatePicker : UIDatePicker!
    
    // clicked Done button
    @IBAction func doneButtonClicked(_ sender: Any) {
        
        // if user didnt input the amount of money
        if AmountTextField.text?.count == 0{
            // show alert message
            // create a alertContorller with AlertTitle
            let alertController = UIAlertController(title: "錯誤", message: "忘記輸入金額了哦！", preferredStyle:.actionSheet)
            // add a action to the alertController that user can click
            alertController.addAction(UIAlertAction(title: "哎呀我忘了！", style: .default, handler: nil))
            // show the alert on screen
            present(alertController, animated: true, completion: nil)
            return
        }
        // go back to previous view with segue and send edited data together
        // the other way to use it is notifications, but performSegue is the easy way to do the same thing
        performSegue(withIdentifier: "goBackToRecordTableWithSegue", sender: nil)
        
    }
    
    // while load this view, create a typePicker to set the type of money costs, then create four DateFormatter to store the data from datePicker
    override func viewDidLoad() {
        super.viewDidLoad()
        // create UIPickerView
        let typePickerView = UIPickerView()
        // set delegate and dataSource
        typePickerView.delegate = self
        typePickerView.dataSource = self
        // set TypeTextField to customize UIPickerView
        TypeTextField.inputView = typePickerView
        // set default value of TypeTextField as insdex 0
        TypeTextField.text = type[0]
        
        //set the date format
        YearFormatter = DateFormatter()
        YearFormatter.dateFormat = "YYYY"
        MonthFormatter = DateFormatter()
        MonthFormatter.dateFormat = "MM"
        // this is weird that when I set the datFormatter.dateFormat as "DD",the day date will shows up with all the days in the year, but if I change it to "dd", it works as I wish, btw, many samples on the internet shows that the format as "yyyy-MM-dd"
        
        DayFormatter = DateFormatter()
        DayFormatter.dateFormat = "dd"
        WeekFormatter = DateFormatter()
        WeekFormatter.dateFormat = "WWW"
        
        // create a UIDatePicker
        myDatePicker = UIDatePicker()
        // set DatePickerMode
        myDatePicker.datePickerMode = .date
        // set default date to Today
        myDatePicker.date = Date()
        
        DateTextField.inputView = myDatePicker
        
        year = YearFormatter.string(from: myDatePicker.date)
        month = MonthFormatter.string(from: myDatePicker.date)
        day = DayFormatter.string(from: myDatePicker.date)
        week = WeekFormatter.string(from: myDatePicker.date)
        //create a toolBar object
        let toolBar = UIToolbar()
        toolBar.barStyle = .black
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        // create doneButton and cancelButton and a sapce in the mid , stuck these items into the toolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        // set the list of buttons into cancelButton in the left, space in the middle, and the doneButton i the right.
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        // set the input type of DateTextField as customize toolBar
        DateTextField.inputAccessoryView = toolBar
        
        // add a touch event
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard(tapG:)))
        
        tap.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tap)
        
        if let record = record {
            DateTextField.text = "\(record.year)\\\(record.month)\\\(record.day)"
            AmountTextField.text = String(record.amount)
            TypeTextField.text = record.type
            DescribeTextView.text = record.describe
        }
    }

    
    // this is a object type function that is used by the button in toolBar we add it.
    @objc func doneClick() {
        year = YearFormatter.string(from: myDatePicker.date)
        month = MonthFormatter.string(from: myDatePicker.date)
        day = DayFormatter.string(from: myDatePicker.date)
        week = WeekFormatter.string(from: myDatePicker.date)
        DateTextField.text = year + "\\" + month + "\\" + day
        DateTextField.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        DateTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
/*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
*/
    
    // set the number of components that can be selected in UIPickerView
    //this function is required
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // set the number of columns of each row
    // this function is required too
    // here we set the number
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return type.count
    }
    
    // set the data of each selection
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return type[row]
    }
    
    // refresh the data after re-select
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        TypeTextField.text = type[row]
    }
    
    // hide keyboard while tap on space
    @objc func hideKeyboard(tapG:UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    
    // cause we send data without notification so we must use the prepare func before using segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if record == nil {
            record = Record(year: year!, month: month!, day: day!, week: week!, amount: Int(AmountTextField.text!)!, type: TypeTextField.text!, describe: DescribeTextView.text!)
        } else {
            record?.year = year!
            record?.month = month!
            record?.day = day!
            record?.week = week!
            record?.amount = Int(AmountTextField.text!)!
            record?.type = TypeTextField.text!
            record?.describe = DescribeTextView.text!
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
