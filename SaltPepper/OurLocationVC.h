//
//  OurLocationVC.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 31/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface OurLocationVC : UIViewController <MKMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapVIew;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic ,retain) NSMutableDictionary *locationDetail;

@end
