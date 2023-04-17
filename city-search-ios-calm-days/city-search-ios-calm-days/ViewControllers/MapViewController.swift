import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var annotation: MKPointAnnotation?
    
    var city: City? {
        didSet {
            configureTitle()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMapView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func configureMapView() {
        guard let city = city else { return }
        
        mapView.region = MKCoordinateRegion(center: city.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.layer.cornerRadius = 50.0
        
        annotation = MKPointAnnotation()
        annotation?.title = city.formattedString
        annotation?.coordinate = city.coordinate
        mapView.delegate = self
    }
    
    private func configureTitle() {
        guard let city = city else { return }
        
        let titleLabel = UILabel()
        titleLabel.text = city.formattedString
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = UIColor.label
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
}

extension MapViewController {
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if let annotation = annotation {
            mapView.addAnnotation(annotation)
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
}
