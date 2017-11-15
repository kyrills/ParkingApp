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
    @IBOutlet weak var blur2: UIVisualEffectView!
    @IBOutlet weak var blur3: UIVisualEffectView!
    @IBOutlet weak var blur4: UIVisualEffectView!
    @IBOutlet weak var blur5: UIVisualEffectView!
    
    var parkingGarages: [ParkingObjects]!
    var selectedGarage: ParkingObjects!
    
    let blur = UIVisualEffectView(effect: UIBlurEffect(style:
        UIBlurEffectStyle.light))
    
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black]
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
        label1.text = "\(selectedGarage.ShortCapacity ?? "")"
        label2.text = "\(selectedGarage.FreeSpaceShort ?? "")"
        label3.text = " \(selectedGarage.LongCapacity ?? "")"
        label4.text = "\(selectedGarage.FreeSpaceLong ?? "")"
        carImage.image = #imageLiteral(resourceName: "carplacehlder1")
    }
}
