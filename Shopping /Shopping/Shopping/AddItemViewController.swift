

import UIKit
import CoreData

protocol AddItemViewControllerDelegate {
    func addButtonPressed(title: String, imgName: String, price: Double, qty: Int32)
    func updateButtonPressed()
}

class UpdateViewController: UIViewController {
    
    var delegate: AddItemViewControllerDelegate?
    @IBOutlet weak var tableView: UITableView!
    
    var sortTag: Int = 0;
    let titles = [["Chicken Burger",
                   "Fish Burger",
                   "Beef Burger",
                   "Bacon Burger",
                   "King Burger",
                   "Vegetable Burger"],
                  
                  ["Chicken Burger",
                   "Fish Burger",
                   "Beef Burger",
                   "Bacon Burger",
                   "King Burger",
                   "Vegetable Burger"],
                  
                  ["Chicken Burger",
                   "Fish Burger",
                   "Beef Burger",
                   "Bacon Burger",
                   "King Burger",
                   "Vegetable Burger"]]
    
    let imgNames = [
                    ["001", "002", "003", "004", "005", "006"],
                    ["002", "005", "006", "001", "003", "004"],
                    ["003", "006", "002", "005", "004", "001"]
                ]
    
    let prices = [
                  ["13", "27", "5", "10", "79", "28"],
                  ["8", "6", "12", "1", "39", "32"],
                  ["75", "14", "1", "0", "19", "13"]
                    ]
    


    var updateitem: ItemEntity! = nil
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    

    @IBOutlet weak var itemTypePickerView: UIPickerView!
    @IBOutlet weak var itemTitleLabel: UITextField!
    @IBOutlet weak var itemPriceLabel: UITextField!
    @IBOutlet weak var itemQtyLabel: UITextField!
    @IBAction func stepper(_ sender: UIStepper) {
        self.itemQtyLabel.text = Int(sender.value).description
    }

    
    @IBAction func showFirstList(_ sender: Any) {
        sortTag = 0
        tableView.reloadData()
        tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    @IBAction func showSecondList(_ sender: Any) {
        sortTag = 1
        tableView.reloadData()
        tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    @IBAction func showThirdList(_ sender: Any) {
        sortTag = 2
        tableView.reloadData()
        tableView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self as? UITableViewDelegate
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addItem(title:String!, img:String!, price:Double!) {

        let itemEntity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "ItemEntity", in: self.appDelegate.coreDataStack.managedObjectContext)
        let historyEntity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "HistoryEntity", in: self.appDelegate.coreDataStack.managedObjectContext)
        
        let newItem: ItemEntity = ItemEntity(entity: itemEntity!, insertInto: self.appDelegate.coreDataStack.managedObjectContext)
        newItem.title = title!
        newItem.imageName = img!
        newItem.price = price!
        newItem.quantity = 1
        newItem.isPurchased = HistoryEntity(entity: historyEntity!, insertInto: self.appDelegate.coreDataStack.managedObjectContext)
        self.appDelegate.coreDataStack.saveContext()
    }
    
    func updateItem() {
        delegate?.updateButtonPressed()
    }
    
    
    
    func cartItems() -> [ItemEntity]? {
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        fetchRequest.predicate = NSPredicate(format: "isPurchased.purchased == false")
        do {
            if let results = try self.appDelegate.coreDataStack.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                let fetchedItems: [ItemEntity]? = results as? [ItemEntity]
                if fetchedItems != nil {
                    return fetchedItems!
                }else{
                    return []
                }
            }else{
                return nil
            }
        }
        catch {
            fatalError("There was an error fetching the items")
        }
    }


    
}

extension UpdateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles[sortTag].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ItemCell? = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemCell
        
        if cell == nil {
            cell = ItemCell(style: .default, reuseIdentifier: "itemCell")
        }
        
        //let item: ItemEntity = self.delegate!.getPurchasedItemForRowAtIndexPath(indexPath: indexPath)
        cell!.itemTitleLabel.text = titles[sortTag][indexPath.row]
        cell!.itemImageView.image = UIImage(named: imgNames[sortTag][indexPath.row])
        cell!.itemPriceLabel.text = String(prices[sortTag][indexPath.row])
        
        cell!.delegate = self
        cell!.selectionStyle = .none
        return cell!
    }
}

extension UpdateViewController: ItemCellDelegate {
    
    func addItem(cell: UITableViewCell) {
        let indexPath: IndexPath! = self.tableView.indexPath(for: cell)
        let title: String = titles[sortTag][indexPath.row]
        let img: String = imgNames[sortTag][indexPath.row]
        let price: Double = Double(prices[sortTag][indexPath.row])!
        
        var isAdd: Bool = true
        if (cartItems() != nil) {
            for item in cartItems()! {
                if title == item.title && img == item.imageName && price == item.price {
                    isAdd = false;
                    item.quantity+=1
                    self.appDelegate.coreDataStack.saveContext()
                    updateItem()
                }
            }
        }
        if isAdd {
            addItem(title:title, img:img, price:price)
        }
    }
    
    func buttonPressed(cell: UITableViewCell) {
        
    }
    
    func addCount(cell: UITableViewCell) {
        
    }
    
    func reduceCount(cell: UITableViewCell) {
        
    }
    
    func selectItem(cell: UITableViewCell) {
    }
    
    
}

