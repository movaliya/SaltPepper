//
//  OurLocationVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 31/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "OurLocationVC.h"

@interface OurLocationVC ()

@end

@implementation OurLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
    self.mapVIew.delegate = self;
    _mapVIew.showsUserLocation = YES;
    
    CLLocationCoordinate2D ourLocation;
    
    ourLocation.latitude = [[_locationDetail objectForKey:@"Latitude"] doubleValue];
    ourLocation.latitude = [[_locationDetail objectForKey:@"Longitude"] doubleValue];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = ourLocation;
    point.title = [_locationDetail objectForKey:@"mapAddress"];
    point.subtitle = @"We'are here!!!";
    [self.mapVIew addAnnotation:point];
    
//    Latitude = "52.5006386";
//    Longitude = "-2.1307233";
//    mapAddress = "106 High St, Brierley Hill, DY5 4DP";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapVIew setRegion:[self.mapVIew regionThatFits:region] animated:YES];
}

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
