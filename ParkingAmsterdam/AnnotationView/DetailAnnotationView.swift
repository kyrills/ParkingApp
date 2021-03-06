import Foundation
import MapKit

private let kGarageMapPinImage = UIImage(named: "location_pin")!
private let kGarageMapAnimationTime = 0.300

class DetailAnnotationView: MKAnnotationView {
    
    
    weak var delegate: GarageDetailMapViewDelegate?
    weak var customCalloutView: DetailParkingView?
    var parkingGarage: ParkingObjects!
    
    var garageDetailMapView: DetailParkingView?
    @objc func setDynamicData(notification: NSNotification) {
        var secondData = notification.userInfo as! Dictionary<String, ParkingObjects>
        let parkingGarage = secondData["data3"] as! ParkingObjects
        garageDetailMapView?.configureWithGarage(parkingGarages: parkingGarage)
        
    }
    
    override var annotation: MKAnnotation? {
        willSet { customCalloutView?.removeFromSuperview() }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.canShowCallout = false // 1
        // put this in annotationView
        self.image = kGarageMapPinImage.resizeImage(image: #imageLiteral(resourceName: "location_pin"), targetSize: CGSize(width: 30.0, height: 30.0))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.canShowCallout = false // 1
        // put this in annotationView
        self.image = kGarageMapPinImage.resizeImage(image: #imageLiteral(resourceName: "location_pin"), targetSize: CGSize(width: 30.0, height: 30.0))
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        if selected {
            self.customCalloutView?.removeFromSuperview() // remove old custom callout (if any)
            
            if let newCustomCalloutView = loadDetailParkingView() {
                // fix location from top-left to its right place.
                newCustomCalloutView.frame.origin.x -= newCustomCalloutView.frame.width / 2.0 - (self.frame.width / 2.0)
                newCustomCalloutView.frame.origin.y -= newCustomCalloutView.frame.height
                
                // set custom callout view
                self.addSubview(newCustomCalloutView)
                self.customCalloutView = newCustomCalloutView

                // animate presentation
                if animated {
                    self.customCalloutView!.alpha = 0.0
                    UIView.animate(withDuration: kGarageMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 1.0
                    })
                }
            }
        } else {
            if customCalloutView != nil {
                if animated { // fade out animation, then remove it.
                    UIView.animate(withDuration: kGarageMapAnimationTime, animations: {
                        self.customCalloutView!.alpha = 0.0
                    }, completion: { (success) in
                        self.customCalloutView!.removeFromSuperview()
                    })
                } else {
                    self.customCalloutView!.removeFromSuperview()
                    
                } // just remove it.
            }
        }
    }
    
    func loadDetailParkingView() -> DetailParkingView? {
        if let views = Bundle.main.loadNibNamed("DetailParkingView", owner: self, options: nil) as? [DetailParkingView], views.count > 0 {
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(DetailAnnotationView.setDynamicData(notification:)),
                                                   name: NSNotification.Name(rawValue: NotificationID.setDynamicData),
                                                   object: nil)
            
            garageDetailMapView = views.first!
            garageDetailMapView?.delegate = self.delegate
            if let detailAnnotation = annotation as? ParkingAnnotations {
                
                if let loadedGarageObjectFromRealm = detailAnnotation.parkingGarage.retrieveData() {
                    ParkingRotterdamService.sharedInstance.getDynamicData(dynamicDataUrl: loadedGarageObjectFromRealm.dynamicDataUrl, garage: loadedGarageObjectFromRealm)
                    garageDetailMapView?.configureWithGarage(parkingGarages:loadedGarageObjectFromRealm)

                }
                return garageDetailMapView
            }
        }
        return nil
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.customCalloutView?.removeFromSuperview()
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // if super passed hit test, return the result
        if let parentHitView = super.hitTest(point, with: event) {
            return parentHitView
        } else { // test in our custom callout.
            if customCalloutView != nil {
                return customCalloutView!.hitTest(convert(point, to: customCalloutView!), with: event)
            } else {
                return nil
                
            }
        }
    }
}
