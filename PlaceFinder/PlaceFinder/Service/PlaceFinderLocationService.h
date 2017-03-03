//
//  PlaceFinderLocationService.h
//  PlaceFinder
//
//  Created by Sanginfo on 03/03/17.
//  Copyright © 2017 Sanginfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol PlaceFinderLocationDelegate <NSObject>

-(void) PlaceFinderLocation:(id)sender andLocation:(CLLocationCoordinate2D)currentLocation;

@end
@interface PlaceFinderLocationService : NSObject
  @property (nonatomic, weak) id <PlaceFinderLocationDelegate> Delegate;
  

@end
