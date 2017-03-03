//
//  ListViewController.m
//  PlaceFinder
//
//  Created by Sanginfo on 03/03/17.
//  Copyright © 2017 Sanginfo. All rights reserved.
//

#import "ListViewController.h"
#import "BarTableViewCell.h"
#import "GoogleApiClient.h"
#import "PlaceFinderLocationService.h"

@interface ListViewController ()<UITableViewDataSource,UITableViewDelegate,PlaceFinderLocationDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tblBarList;
@property (retain, nonatomic)  NSMutableArray *barListData;
@end

@implementation ListViewController{
PlaceFinderLocationService * locationUpdate;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
  [refreshControl addTarget:self action:@selector(refreshBarData) forControlEvents:UIControlEventValueChanged];
  self.tblBarList.refreshControl=refreshControl;
  self.barListData=[[NSMutableArray alloc] init];
  
  locationUpdate=[[PlaceFinderLocationService alloc] init];
  locationUpdate.delegate=self;
  self.tblBarList.hidden=YES;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  if(CLLocationCoordinate2DIsValid(locationUpdate.knownLocation)){
    [self refreshBarData];
  }
  else{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [self refreshBarData];
    });
  }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark Refresh table data
-(void)refreshBarData
{
  if(CLLocationCoordinate2DIsValid(locationUpdate.knownLocation)){
    [self fetchPlaces:locationUpdate.knownLocation];
  }
}

#pragma mark Bar table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  NSLog(@"%ld",[self.barListData count]);
  return [self.barListData count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
  BarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TB_BAR"];
  
  NSDictionary *barinfoRow = [self.barListData objectAtIndex:[indexPath row]];
  [cell fillData:barinfoRow];
  
  
  return cell;

}
#pragma mark Location Update
-(void) PlaceFinderLocation:(id)sender andLocation:(CLLocationCoordinate2D)currentLocation{
}
#pragma mark Load Bar Detail

#pragma mark Google Places api
-(void)fetchPlaces:(CLLocationCoordinate2D)currentLocation{
  NSString *locationString=[NSString stringWithFormat:@"%f,%f",currentLocation.latitude,currentLocation.longitude];
  NSDictionary *queryParameter=[NSDictionary dictionaryWithObjectsAndKeys:locationString,@"location",@2000,@"radius", nil];
  [GoogleApiClient googleRequest:queryParameter result:^(NSArray *results, NSError *error) {
    if(error==nil){
      
      [self.barListData removeAllObjects];
      NSArray *arrTempInfo=[results[0] objectForKey:@"results"];
      for (NSDictionary *info in arrTempInfo) {
        NSDictionary *barinfo=[self createBarDetail:info];
        if(barinfo!=nil){
          [self.barListData addObject:barinfo];
        }
      }
      NSLog(@"Added Row %ld",[self.barListData count]);
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.tblBarList reloadData];
        [self.tblBarList.refreshControl endRefreshing];
        self.tblBarList.hidden=NO;
      });
    
    }
    
  }];
}

-(NSDictionary *)createBarDetail:(NSDictionary *)placeInfo{
  NSMutableDictionary *barinfo=[[NSMutableDictionary alloc] init];
  
  if([[placeInfo objectForKey:@"photos"] count]>0){
    NSDictionary *photo=[placeInfo objectForKey:@"photos"][0];
    [barinfo setObject:[photo objectForKey:@"photo_reference"] forKey:@"imageRef"];
    [barinfo setObject:[placeInfo objectForKey:@"name"] forKey:@"barname"];
    [barinfo setObject:[placeInfo objectForKey:@"id"] forKey:@"barid"];
  }
  else{
    //Not to display on map
    return nil;
  }
  
  return barinfo;
  
}
@end
