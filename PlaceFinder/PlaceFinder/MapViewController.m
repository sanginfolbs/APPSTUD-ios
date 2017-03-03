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

@interface MapViewController ()<PlaceFinderLocationDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *vwGoogleMap;

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
    GMSCameraPosition *lastCameraPosition=self.vwGoogleMap.camera;
    self.vwGoogleMap.camera=[GMSCameraPosition cameraWithLatitude:blueDot.position.latitude longitude:blueDot.position.longitude zoom:lastCameraPosition.zoom];
  }
  else{
    blueDot.position=currentLocation;
  }
}
@end
