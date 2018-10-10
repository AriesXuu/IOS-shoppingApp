

import UIKit

protocol ItemCellDelegate {
    func addItem(cell: UITableViewCell)
    func buttonPressed(cell: UITableViewCell)
    func addCount(cell: UITableViewCell)
    func reduceCount(cell: UITableViewCell)
    func selectItem(cell: UITableViewCell)
}

class ItemCell: UITableViewCell {
    
    var delegate: ItemCellDelegate?
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemTitleLabel: UILabel!
    @IBOutlet weak var itemQtyLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemPurchasedButton: UIButton!
    @IBOutlet weak var reduceBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var itemTotalPriceLabel: UILabel!
    
    @IBOutlet weak var selectBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addItem(_ sender: UIButton) {
        delegate?.addItem(cell: self)
    }
    
    @IBAction func itemPurchasedButtonAction(_ sender: Any) {
        self.delegate?.buttonPressed(cell: self)
    }
    
    
    @IBAction func reduceQty(_ sender: UIButton) {
        delegate?.reduceCount(cell: self)
    }
    
    @IBAction func addQty(_ sender: UIButton) {
        delegate?.addCount(cell: self)
    }
    
    @IBAction func selectItem(_ sender: UIButton) {
        delegate?.selectItem(cell: self)
        //.imageView?.image = UIImage(named:(selectBtn.currentImage?.isEqual("selected"))! ? "unselected" : "selected")
    }
    
}
