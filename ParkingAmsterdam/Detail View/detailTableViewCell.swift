import UIKit

class detailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TableViewLabel: UILabel!

    var garage: String!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureWithItem(garage: String) {
        self.garage = garage
        self.TableViewLabel?.text = garage
    }
}

