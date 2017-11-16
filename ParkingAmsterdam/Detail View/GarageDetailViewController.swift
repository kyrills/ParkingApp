import Foundation
import UIKit

class GarageDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var carImage: UIImageView!
    
    @IBOutlet weak var blur1: UIVisualEffectView!
    
    var parkingGarages: [ParkingObjects]!
    var selectedGarage: ParkingObjects!
    
    @IBOutlet weak var favouriteButton: UIButton!
    var rightButtonItem: UIBarButtonItem?
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style:
        UIBlurEffectStyle.light))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFavourite()


        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        navigationController?.navigationBar.barTintColor = UIColor.white

        titleLabel.text = selectedGarage.Name!.removeFirstCharacters()
        label1.layer.masksToBounds = true
        label2.layer.masksToBounds = true
        label3.layer.masksToBounds = true
        label4.layer.masksToBounds = true
        label1.layer.cornerRadius = 10
        label2.layer.cornerRadius = 10
        label3.layer.cornerRadius = 10
        label4.layer.cornerRadius = 10
        if let shortCap = selectedGarage.ShortCapacity {
            label1.text = "\(shortCap)"
        }
        if let FreeSpaceShort = selectedGarage.FreeSpaceShort {
            label2.text = "\(FreeSpaceShort)"
        }
        if let LongCapacity = selectedGarage.LongCapacity {
            label3.text = "\(LongCapacity)"
        }
        if let FreeSpaceLong = selectedGarage.FreeSpaceLong {
            label4.text = "\(FreeSpaceLong)"
        }
        carImage.image = #imageLiteral(resourceName: "carplacehlder1")
        
    }
    
    @IBAction func cameraButton(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        carImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func toggleFavourite(_ sender: UIButton) {
        if let toggeldFavourite = selectedGarage.favouriteParkingSpot() {
            favouriteButton.setImage(toggeldFavourite.favourite == true ? #imageLiteral(resourceName: "starYellowBig") : #imageLiteral(resourceName: "starWhiteBig"), for: UIControlState.normal)
        }

    }
    
    func setFavourite() {

        favouriteButton.setImage(self.selectedGarage.favourite == true ? #imageLiteral(resourceName: "starYellowBig") : #imageLiteral(resourceName: "starWhiteBig"), for: UIControlState.normal)
        let rightButtonItem = UIBarButtonItem.init(customView: favouriteButton)
        self.navigationItem.rightBarButtonItem = rightButtonItem
    }
    
}
