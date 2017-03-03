//
//  ImageCacheManager.m
//  PlaceFinder
//
//  Created by Sanginfo on 04/03/17.
//  Copyright © 2017 Sanginfo. All rights reserved.
//

#import "ImageCacheManager.h"
#import "ImageCacheManager.h"
#import "NSString+MD5.h"
#define TMP NSTemporaryDirectory()
@implementation ImageCacheManager
-(id)init{
  self=[super init];
  if (self) {
    //Customize
    //Create cache directory
    BOOL isDir;
    NSString *path = [TMP stringByAppendingPathComponent: @"cacheImages"];
    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir];
    if (!exists) {
      NSError *error;
      [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:&error];
      
    }
  }
  return self;
}
- (void) cacheImage: (NSString *) ImageURLString
{
  NSURL *ImageURL = [NSURL URLWithString: ImageURLString];
  // Generate a unique path to a resource representing the image you want
  NSString *filename = [ImageURLString MD5String];
  NSString *uniquePath = [[TMP stringByAppendingPathComponent: @"cacheImages"] stringByAppendingPathComponent: filename];
  
  // Check for file existence
  if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
  {
    // The file doesn't exist, we should get a copy of it
    
    // Fetch image
    NSData *data = [[NSData alloc] initWithContentsOfURL: ImageURL];
    UIImage *image = [[UIImage alloc] initWithData: data];
    // Do we want to round the corners?
    //image = [self roundCorners: image];
    // Is it PNG or JPG/JPEG?
    // Running the image representation function writes the data from the image to a file
    if([ImageURLString rangeOfString: @".png" options: NSCaseInsensitiveSearch].location != NSNotFound)
    {
      [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
    }
    else if(
            [ImageURLString rangeOfString: @".jpg" options: NSCaseInsensitiveSearch].location != NSNotFound ||
            [ImageURLString rangeOfString: @".jpeg" options: NSCaseInsensitiveSearch].location != NSNotFound
            )
    {
      [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
    }
    else{
      [UIImageJPEGRepresentation(image, 100) writeToFile: uniquePath atomically: YES];
    }
  }
}

- (UIImage *) getCachedImage: (NSString *) ImageURLString
{
  NSString *filename = [ImageURLString MD5String];
  NSString *uniquePath = [[TMP stringByAppendingPathComponent: @"cacheImages"] stringByAppendingPathComponent: filename];
  UIImage *image;
  // Check for a cached version
  if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
  {
    image = [UIImage imageWithContentsOfFile: uniquePath]; // this is the cached image
  }
  else
  {
    // get a new one
    [self cacheImage: ImageURLString];
    image = [UIImage imageWithContentsOfFile: uniquePath];
  }
  
  return image;
}
@end
