//
//  GoogleApiClient.h
//  PlaceFinder
//
//  Created by Sanginfo on 03/03/17.
//  Copyright © 2017 Sanginfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
@interface GoogleApiClient:NSObject

+(void)googleRequest:(NSDictionary *)query result:(void (^)(NSArray *results, NSError *error))block;

@end
