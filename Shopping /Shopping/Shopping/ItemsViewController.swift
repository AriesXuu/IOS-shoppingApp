
import UIKit
import CoreData

class ItemsViewController: UIViewController {
    
    @IBOutlet weak var currentlyPriceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var items: [ItemEntity] = []
    var purchasedItems: [ItemEntity] = []
    var appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var currentlyPrice: Double = 0.0
    var totallyPrice: Double = 0.0
    var totallyQty: Int = 0
    var ePrice: Double = 0.0
    var eTitle: String = ""
    var isEdit: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstStart: Bool? = UserDefaults.standard.object(forKey: "firstStart") as? Bool
        
        if firstStart == nil {
            //self.createInitData()
            UserDefaults.standard.set(false, forKey: "firstStart")
        }
        
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.fetchItems()
        self.fetchPurchasedItems()
        self.tableView.dataSource = self
        self.tableView.delegate = self as? UITableViewDelegate
        self.getCurrentlyPrice()
        self.getTotallyPrice()
        self.getTotallyQty()
        self.getExpensiveItem()
    }
    
    func updateTotalInfo() {
        self.getCurrentlyPrice()
        self.getTotallyPrice()
        self.getTotallyQty()
        self.getExpensiveItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        items.removeAll()
        fetchItems()
        tableView.reloadData()
        updateTotalInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createInitData() {
        let itemEntity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "ItemEntity", in: self.appDelegate.coreDataStack.managedObjectContext)
        let invitationEntity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "HistoryEntity", in: self.appDelegate.coreDataStack.managedObjectContext)
        
        if itemEntity != nil {
            let item1: ItemEntity = ItemEntity(entity: itemEntity!, insertInto: self.appDelegate.coreDataStack.managedObjectContext)
            item1.title = "Chicken Burger"
            item1.imageName = "001"
            item1.price = 2
            item1.quantity = 5
            item1.isSelected = false
            item1.isPurchased = HistoryEntity(entity: invitationEntity!, insertInto: self.appDelegate.coreDataStack.managedObjectContext)
            
            let item2: ItemEntity = ItemEntity(entity: itemEntity!, insertInto: self.appDelegate.coreDataStack.managedObjectContext)
            item2.title = "Beef Burger"
            item2.imageName = "002"
            item2.price = 4
            item2.quantity = 2
            item2.isSelected = false
            item2.isPurchased = HistoryEntity(entity: invitationEntity!, insertInto: self.appDelegate.coreDataStack.managedObjectContext)
            
            let item3: ItemEntity = ItemEntity(entity: itemEntity!, insertInto: self.appDelegate.coreDataStack.managedObjectContext)
            item3.title = "Fish Burger"
            item3.imageName = "003"
            item3.price = 100
            item3.quantity = 3
            item3.isSelected = false
            item3.isPurchased = HistoryEntity(entity: invitationEntity!, insertInto: self.appDelegate.coreDataStack.managedObjectContext)
            
            
            
            self.appDelegate.coreDataStack.saveContext()
        }
    }
    
    func fetchItems() {
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        fetchRequest.predicate = NSPredicate(format: "isPurchased.purchased == false")
        do {
            if let results = try self.appDelegate.coreDataStack.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                let fetchedItems: [ItemEntity]? = results as? [ItemEntity]
                if fetchedItems != nil {
                    self.items = fetchedItems!
                }
            }
        }
        catch {
            fatalError("There was an error fetching the items")
        }
    }
    
    
    func fetchPurchasedItems() {
        let fetchRequest: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ItemEntity")
        fetchRequest.predicate = NSPredicate(format: "isPurchased.purchased == true")
        do {
            if let results = try self.appDelegate.coreDataStack.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] {
                let fetchedItems: [ItemEntity]? = results as? [ItemEntity]
                if fetchedItems != nil {
                    self.purchasedItems = fetchedItems!
                }
            }
        }
        catch {
            fatalError("There was an error fetching the items")
        }
    }
    
    func getCurrentlyPrice() {
        let count = items.count
        currentlyPrice = 0.0
        for i in 0..<count{
            if items[i].isSelected {
                let a = Double(items[i].price)
                let b = Double(items[i].quantity)
                let itemsPrice = a * b
                currentlyPrice += itemsPrice
            }
        }
        currentlyPriceLabel.text = String(currentlyPrice)
    }
    
    func getTotallyPrice() {
        let count = purchasedItems.count
        totallyPrice = 0.0
        for i in 0..<count{
            let a = Double(purchasedItems[i].price)
            let b = Double(purchasedItems[i].quantity)
            let purchaseditemsPrice = a * b
            totallyPrice += purchaseditemsPrice
        }
    }
    
    func getTotallyQty() {
        let count = purchasedItems.count
        totallyQty = 0
        for i in 0..<count{
            let qty = Int(purchasedItems[i].quantity)
            totallyQty += qty
        }
    }
    
    func getExpensiveItem() {
        let count = purchasedItems.count
        ePrice = 0.0
        eTitle = ""
        if purchasedItems.count > 0{
            for i in 0..<count{
                if purchasedItems[i].price >= ePrice {
                    eTitle = purchasedItems[i].title!
                    ePrice = purchasedItems[i].price
                }
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historySegue" {
            let navigationController: UINavigationController? = segue.destination as? UINavigationController
            if navigationController != nil {
                let historyVC: HistoryViewController? = navigationController!.viewControllers[0] as? HistoryViewController
                if historyVC != nil {
                    historyVC!.delegate = self
                }
            }
        }
        else if segue.identifier == "addSegue" {
            let updateVC: UpdateViewController = segue.destination as! UpdateViewController
            updateVC.delegate = self

        }
        else if segue.identifier == "updateSegue" {
            let updateVC: UpdateViewController = segue.destination as! UpdateViewController
            updateVC.delegate = self
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let item: ItemEntity = items[indexPath!.row]
            let destination = segue.destination as! UpdateViewController
            destination.updateitem = item
        }
        
        
    }

    @IBAction func showEditCount(_ sender: Any) {
        isEdit = !isEdit
        tableView.reloadData()
    }
    
    @IBAction func buyAction(_ sender: UIButton) {
        
        for item in items {
            if item.isSelected {
                item.isPurchased?.purchased = true
                self.appDelegate.coreDataStack.saveContext()
                self.purchasedItems.append(item)
                self.items.remove(at: items.index(of: item)!)
            }
        }
        tableView.reloadData()
        getCurrentlyPrice()
        getTotallyPrice()
        getTotallyQty()
        getExpensiveItem()
    }
    
    
}



extension ItemsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ItemCell? = tableView.dequeueReusableCell(withIdentifier: "itemCell") as? ItemCell
        
        if cell == nil {
            cell = ItemCell(style: .default, reuseIdentifier: "itemCell")
        }
        
        let item: ItemEntity = items[indexPath.row]
        cell!.itemTitleLabel.text = item.title
        cell!.itemPriceLabel.text = String(item.price)
        cell!.itemQtyLabel.text = String(item.quantity)
        cell!.reduceBtn.isEnabled = item.quantity <= 1 ? false : true
        cell!.selectBtn.setImage(UIImage(named:(item.isSelected ? "selected" : "unselected")), for: UIControlState(rawValue: 0))
        cell!.itemImageView.image = UIImage(named: item.imageName!)
        cell!.delegate = self
        cell!.selectionStyle = .none
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
       if editingStyle == .delete {

                    let item: ItemEntity = items[indexPath.row]
                    let deleteObjectIndex: Int = indexPath.row
                    self.items.remove(at: deleteObjectIndex)
                    self.tableView.deleteRows(at: [IndexPath(row: deleteObjectIndex, section: 0)], with: .automatic)
                    self.appDelegate.coreDataStack.managedObjectContext.delete(item)
                    self.appDelegate.coreDataStack.saveContext()
        }
        getCurrentlyPrice()
        getTotallyPrice()
        getTotallyQty()
        getExpensiveItem()
    }
    
    
}

extension ItemsViewController: ItemCellDelegate {
    func addItem(cell: UITableViewCell) {
        
    }
    
    func selectItem(cell: UITableViewCell) {
        let indexPath: IndexPath? = self.tableView.indexPath(for: cell)
        if indexPath != nil {
            let item: ItemEntity = items[indexPath!.row]
            item.isSelected = !item.isSelected
            self.appDelegate.coreDataStack.saveContext()
            tableView.reloadData()
            getCurrentlyPrice()
            getTotallyPrice()
            getTotallyQty()
            getExpensiveItem()
        }
    }
    
    func addCount(cell: UITableViewCell) {
        let indexPath: IndexPath? = self.tableView.indexPath(for: cell)
        if indexPath != nil {
            let item: ItemEntity = items[indexPath!.row]
            item.quantity+=1
            self.appDelegate.coreDataStack.saveContext()
            tableView.reloadData()
            getCurrentlyPrice()
            getTotallyPrice()
            getTotallyQty()
            getExpensiveItem()
        }
    }
    
    func reduceCount(cell: UITableViewCell) {
        let indexPath: IndexPath? = self.tableView.indexPath(for: cell)
        if indexPath != nil {
            let item: ItemEntity = items[indexPath!.row]
            item.quantity-=1
            self.appDelegate.coreDataStack.saveContext()
            tableView.reloadData()
            getCurrentlyPrice()
            getTotallyPrice()
            getTotallyQty()
            getExpensiveItem()
        }
    }
    
    func buttonPressed(cell: UITableViewCell) {
        let indexPath: IndexPath? = self.tableView.indexPath(for: cell)
        if indexPath != nil {
            let item: ItemEntity = items[indexPath!.row]
            item.isPurchased?.purchased = true
            self.appDelegate.coreDataStack.saveContext()
            self.purchasedItems.append(item)
            self.items.remove(at: indexPath!.row)
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
            getCurrentlyPrice()
            getTotallyPrice()
            getTotallyQty()
            getExpensiveItem()
        }
    }
}

extension ItemsViewController: AddItemViewControllerDelegate {
    func addButtonPressed(title: String, imgName: String, price: Double, qty: Int32){
        let itemEntity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "ItemEntity", in: self.appDelegate.coreDataStack.managedObjectContext)
        let historyEntity: NSEntityDescription? = NSEntityDescription.entity(forEntityName: "HistoryEntity", in: self.appDelegate.coreDataStack.managedObjectContext)
        
        let newItem: ItemEntity = ItemEntity(entity: itemEntity!, insertInto: self.appDelegate.coreDataStack.managedObjectContext)
        newItem.title = title
        newItem.imageName = imgName
        newItem.price = price
        newItem.quantity = qty
        newItem.isPurchased = HistoryEntity(entity: historyEntity!, insertInto: self.appDelegate.coreDataStack.managedObjectContext)
        self.items.append(newItem)
        self.tableView.insertRows(at: [IndexPath(row: self.items.count-1, section: 0)], with: .automatic)
        self.appDelegate.coreDataStack.saveContext()
        getCurrentlyPrice()
        getTotallyPrice()
        getTotallyQty()
        getExpensiveItem()
    }
    func updateButtonPressed() {
        for i in 0..<self.items.count {
            self.tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
        }
        getCurrentlyPrice()
        getTotallyPrice()
        getTotallyQty()
        getExpensiveItem()
    }
}


extension ItemsViewController: HistoryViewControllerDelegate {
    func getPurchasedItemsCount() -> Int {
        return self.purchasedItems.count
    }
    
    func getPurchasedItemForRowAtIndexPath(indexPath: IndexPath) -> ItemEntity {
        return self.purchasedItems[indexPath.row]
    }
    
    func unPurchasedItemAtIndexPath(indexPath: IndexPath) {
        let item: ItemEntity = self.purchasedItems[indexPath.row]
        item.isPurchased?.purchased = false
        self.appDelegate.coreDataStack.saveContext()
        self.purchasedItems.remove(at: indexPath.row)
        self.items.append(item)
        self.tableView.insertRows(at: [IndexPath(row: self.items.count-1, section: 0)], with: .automatic)
        getCurrentlyPrice()
        getTotallyPrice()
        getTotallyQty()
        getExpensiveItem()
    }
    func historyTotallyPrice() -> Double {
        return totallyPrice
    }
    func historyTotallyQty() -> Int {
        return totallyQty
    }
    func historyEtitle() -> String {
        return eTitle
    }
    func historyEprice() -> Double {
        return ePrice
    }
}

