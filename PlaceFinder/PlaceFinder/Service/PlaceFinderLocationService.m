//
//  PlaceFinderLocationService.m
//  PlaceFinder
//
//  Created by Sanginfo on 03/03/17.
//  Copyright © 2017 Sanginfo. All rights reserved.
//

#import "PlaceFinderLocationService.h"
@interface PlaceFinderLocationService()<CLLocationManagerDelegate>
@end
@implementation PlaceFinderLocationService{
  CLLocationManager *locationManager;
}
-(id)init{
  self=[super init];
  
  
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
- (void)locationManager:(CLLocationManager *)manager     didUpdateLocations:(NSArray<CLLocation *> *)locations{
  CLLocation *firstLocation=locations[0];
  [self.delegate PlaceFinderLocation:self andLocation:firstLocation.coordinate ];
}

@end
