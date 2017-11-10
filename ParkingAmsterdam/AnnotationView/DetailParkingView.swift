import Foundation
import UIKit

protocol GarageDetailMapViewDelegate: class {
    func detailsRequested(for parkingGarages: ParkingObjects)
    func routeToRequested(for parkingGarages: ParkingObjects)
}

class DetailParkingView: UIView {
    
    @IBOutlet weak var goToDetailButton: UIButton!
    @IBOutlet weak var routeToGarageButton: UIButton!
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var parkingSpaceLabel: UILabel!
    @IBOutlet weak var backgroundContentButton: UIButton!
    
    var parkingGarages: ParkingObjects!
    weak var delegate: GarageDetailMapViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
    backgroundContentButton.applyArrowDialogAppearanceWithOrientation(arrowOrientation: .down)

    }
    
    func configureWithGarage(parkingGarages: ParkingObjects) {
        self.parkingGarages = parkingGarages
        
        ImageView.image = #imageLiteral(resourceName: "carexample")
        TitleLabel.text = parkingGarages.Name.removeFirstCharacters()
        parkingSpaceLabel.text = parkingGarages.State
    }
    
    @IBAction func goToDetailButton(_ sender: Any) {
        delegate?.detailsRequested(for: parkingGarages)
    }
    
    @IBAction func routeToGarageButton(_ sender: Any) {
        delegate?.routeToRequested(for: parkingGarages)
    }
    
    func configureWithParkingGarages(parkingGarages: ParkingObjects) {
        self.parkingGarages = parkingGarages

        ImageView.image = #imageLiteral(resourceName: "carexample")
        TitleLabel.text = parkingGarages.Name.removeFirstCharacters()
        parkingSpaceLabel.text = parkingGarages.State
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if let result = goToDetailButton.hitTest(convert(point, to: goToDetailButton), with: event) {
            return result
        }
        
        if let route = routeToGarageButton.hitTest(convert(point, to: routeToGarageButton), with: event) {
            return route
        }
        return backgroundContentButton.hitTest(convert(point, to: backgroundContentButton), with: event)
    }
    
}
