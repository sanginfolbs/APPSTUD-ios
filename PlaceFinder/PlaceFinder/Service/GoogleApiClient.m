//
//  GoogleApiClient.m
//  PlaceFinder
//
//  Created by Sanginfo on 03/03/17.
//  Copyright © 2017 Sanginfo. All rights reserved.
//

#import "GoogleApiClient.h"
#import <UIKit+AFNetworking.h>
#import <CoreLocation/CoreLocation.h>

@implementation GoogleApiClient

+(void)googleRequest:(NSDictionary *)query result:(void (^)(NSArray *results, NSError *error))block{
  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
  [manager GET:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=AIzaSyDxqBNk_2AvTJxE8C1XPZqBAb7RrvaiJdk&type=bar" parameters:query progress:nil success:^(NSURLSessionTask *task, id responseObject) {
    //NSLog(@"JSON: %@", responseObject);
    NSMutableArray *outPath;
    if ([responseObject isKindOfClass:[NSArray class]]){
      outPath=[[NSMutableArray alloc] initWithArray:responseObject];
    }
    else{
      outPath=[[NSMutableArray alloc] initWithObjects:responseObject, nil];
    }
    
    if (block) {
      block([NSArray arrayWithArray:outPath], nil);
    }

  } failure:^(NSURLSessionTask *operation, NSError *error) {
    if (block) {
      NSInteger statusCode = 401;
      if (statusCode==401) {
        block([NSArray array], [[NSError alloc] initWithDomain:@"Network or service temporarily unavailable." code:statusCode userInfo:nil]);
      }
      else{
        block([NSArray array], [[NSError alloc] initWithDomain:@"Please turn on your Wifi or Mobile data and try again when connected." code:statusCode userInfo:nil]);
      }
      
    }
  }];
}
@end
