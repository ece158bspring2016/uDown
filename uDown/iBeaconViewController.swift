//
//  iBeaconViewController.swift
//  uDown
//
//  Created by Oscar Pan on 6/7/16.
//  Copyright © 2016 Rachit Crew. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class iBeaconViewController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    var peripheralManager = CBPeripheralManager()
    var advertisedData = NSDictionary()
    
    var lastRSSI:Int = 0
    
    var minor1:Int!
    var minor2:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        let uuid = NSUUID(UUIDString: "FDA50693-A4E2-4FB1-AFCF-C6EB07647825")
        let majorValue: CLBeaconMajorValue = UInt16(Int("10019")!)
        //let minorValue: CLBeaconMinorValue = UInt16(Int("54627")!)
        let minorValue: CLBeaconMinorValue = UInt16(minor1)
        let identifier = "Oscar"
        
        let rangingBeaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: majorValue, minor: minorValue, identifier: identifier)
        
        //locationManager.startMonitoringForRegion(beaconRegion)
        locationManager.startRangingBeaconsInRegion(rangingBeaconRegion)

    
        
        
        let b_majorValue: CLBeaconMajorValue = UInt16(Int("10019")!)
        //let b_minorValue: CLBeaconMinorValue = UInt16(Int("54628")!)
        let b_minorValue: CLBeaconMinorValue = UInt16(minor2)
        let b_identifier = "Broadcast"
        
        print(uuid)
        
        let broadcastBeaconRegion = CLBeaconRegion(proximityUUID: uuid!, major: b_majorValue, minor: b_minorValue, identifier: b_identifier)
        
        self.advertisedData = broadcastBeaconRegion.peripheralDataWithMeasuredPower(nil)
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        if(peripheral.state == CBPeripheralManagerState.PoweredOn) {
            print("powered on")
            print(self.advertisedData)
            self.peripheralManager.startAdvertising(self.advertisedData as? [String : AnyObject])
        } else if(peripheral.state == CBPeripheralManagerState.PoweredOff) {
            print("powered off")
            self.peripheralManager.stopAdvertising()
        }
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: CLLocationManagerDelegate
extension iBeaconViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Failed monitoring region: \(error.description)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location manager failed: \(error.description)")
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        for beacon in beacons {
            print(beacon)
            let accuracy = String(format:"%.2f", beacon.accuracy)
            headingLabel.text = "Proximity: \(beacon.proximity.rawValue.description) +/- \(accuracy)m"
            
            let prevRRSI = lastRSSI
            
            if(prevRRSI > beacon.rssi){
                tempLabel.text = "Colder"
            }
            else{
                tempLabel.text = "Hotter"
            }
            
            lastRSSI = beacon.rssi
        }
    }
}