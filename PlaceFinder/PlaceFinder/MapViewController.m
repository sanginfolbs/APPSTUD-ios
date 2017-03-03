//
//  MapViewController.m
//  PlaceFinder
//
//  Created by Sanginfo on 03/03/17.
//  Copyright © 2017 Sanginfo. All rights reserved.
//

#import "MapViewController.h"
#import "PlaceFinderLocationService.h"
#import <GoogleMaps/GoogleMaps.h>
#import "GoogleApiClient.h"
#import "BarMarkers.h"

@interface MapViewController ()<PlaceFinderLocationDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *vwGoogleMap;
@property (retain, nonatomic)  NSMutableArray<BarMarkers *> *listPlaces;
@end

@implementation MapViewController{
  PlaceFinderLocationService * locationUpdate;
  GMSMarker *blueDot;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  locationUpdate=[[PlaceFinderLocationService alloc] init];
  locationUpdate.delegate=self;
  [self.listPlaces removeAllObjects];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onTapLocateMe:(UIButton *)sender {
  if(blueDot!=nil){
    GMSCameraPosition *lastCameraPosition=self.vwGoogleMap.camera;
    [self.vwGoogleMap animateToCameraPosition:[GMSCameraPosition cameraWithLatitude:blueDot.position.latitude longitude:blueDot.position.longitude zoom:lastCameraPosition.zoom]];
  }
}

#pragma mark Location Update
-(void) PlaceFinderLocation:(id)sender andLocation:(CLLocationCoordinate2D)currentLocation{
  if(blueDot==nil){
    blueDot=[[GMSMarker alloc] init];
    blueDot.position=currentLocation;
    blueDot.icon=[UIImage imageNamed:@"blue-dot.png"];
    blueDot.map=self.vwGoogleMap;
    
    self.vwGoogleMap.camera=[GMSCameraPosition cameraWithLatitude:blueDot.position.latitude longitude:blueDot.position.longitude zoom:15.00];
    [self fetchPlaces:currentLocation];
  }
  else{
    blueDot.position=currentLocation;
  }
}
#pragma mark Google Places api
-(void)fetchPlaces:(CLLocationCoordinate2D)currentLocation{
  NSString *locationString=[NSString stringWithFormat:@"%f,%f",currentLocation.latitude,currentLocation.longitude];
  NSDictionary *queryParameter=[NSDictionary dictionaryWithObjectsAndKeys:locationString,@"location",@2000,@"radius", nil];
  [GoogleApiClient googleRequest:queryParameter result:^(NSArray *results, NSError *error) {
    if(error==nil){
      NSLog(@"%@",results);
      for (GMSMarker *item in self.listPlaces) {
        item.map=nil;
      }
      [self.listPlaces removeAllObjects];
      NSArray *arrTempInfo=[results[0] objectForKey:@"results"];
      for (NSDictionary *info in arrTempInfo) {
        BarMarkers *mark=[self createPlaceMarker:info];
        if(mark!=nil){
          mark.map=self.vwGoogleMap;
          [self.listPlaces addObject:mark];
        }
      }
    }
    
  }];
}

-(BarMarkers *)createPlaceMarker:(NSDictionary *)placeInfo{
  BarMarkers *placeMarker=[[BarMarkers alloc] init];
  placeMarker.icon=[UIImage imageNamed:@"dummyBaricon.jpg"];
  if([[placeInfo objectForKey:@"photos"] count]>0){
    NSDictionary *photo=[placeInfo objectForKey:@"photos"][0];
    placeMarker.barImage=[photo objectForKey:@"photo_reference"];
  }
  else{
  //Not to display on map
    return nil;
  }
  
  NSDictionary *location=[[placeInfo objectForKey:@"geometry"] objectForKey:@"location"];
  placeMarker.position=CLLocationCoordinate2DMake([[location objectForKey:@"lat"] doubleValue], [[location objectForKey:@"lng"] doubleValue]);
  return placeMarker;
  
}
@end
