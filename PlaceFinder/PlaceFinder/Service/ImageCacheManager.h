//
//  ImageCacheManager.h
//  PlaceFinder
//
//  Created by Sanginfo on 04/03/17.
//  Copyright © 2017 Sanginfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageCacheManager : NSObject{
}
// Methods
- (void) cacheImage: (NSString *) ImageURLString;
- (UIImage *) getCachedImage: (NSString *) ImageURLString;
@end

