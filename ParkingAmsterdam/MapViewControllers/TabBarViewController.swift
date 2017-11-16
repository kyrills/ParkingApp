import UIKit
import MapKit
class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    var sourceCoordinate = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let destinationNav = viewController as? UINavigationController,
            let parkingList = destinationNav.viewControllers[0] as? ParkingList{
            
            parkingList.sourceCoordinate = sourceCoordinate
        }
        print(viewController)
    }

 

}
