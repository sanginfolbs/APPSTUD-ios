//
//  PlaceFinderLocationService.m
//  PlaceFinder
//
//  Created by Sanginfo on 03/03/17.
//  Copyright © 2017 Sanginfo. All rights reserved.
//

#import "PlaceFinderLocationService.h"
#import <UIKit/UIKit.h>
@interface PlaceFinderLocationService()<CLLocationManagerDelegate>
@end
@implementation PlaceFinderLocationService{
  CLLocationManager *locationManager;
  CLLocationCoordinate2D lastcoordinate;
}
-(id)init{
  self=[super init];
  lastcoordinate=kCLLocationCoordinate2DInvalid;
  
  if([CLLocationManager locationServicesEnabled]){
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
  
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
      [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
  }
  return self;
}

#pragma mark location service
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  
  if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"App Permission Denied" message:@"To re-enable, please go to Settings and turn on Location Service for this app." preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
      
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
        
      }];
    }]];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    
    
  }
}

- (void)locationManager:(CLLocationManager *)manager     didUpdateLocations:(NSArray<CLLocation *> *)locations{
  CLLocation *firstLocation=locations[0];
  lastcoordinate=firstLocation.coordinate;
  [self.delegate PlaceFinderLocation:self andLocation:firstLocation.coordinate];
}

-(CLLocationCoordinate2D)knownLocation{
  return lastcoordinate;
}

@end
