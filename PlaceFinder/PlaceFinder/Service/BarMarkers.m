//
//  BarMarkers.m
//  PlaceFinder
//
//  Created by Sanginfo on 03/03/17.
//  Copyright © 2017 Sanginfo. All rights reserved.
//

#import "BarMarkers.h"
#import "PlaceFinderKeys.h"

@implementation BarMarkers
-(void)setBarImage:(NSString *)barImage{
  _barImage=barImage;
  NSString *imageURL=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?key=%@&photoreference=%@&maxheight=70",GOOGLE_PLACEAPI,_barImage];
  NSURL *url = [NSURL URLWithString:imageURL];
  self.icon=[self borderImageCircle:self.icon scaledToSize:CGSizeMake(40, 40)];
  //[self processImage:imageData];
  
  dispatch_queue_t callerQueue = dispatch_get_current_queue();
  dispatch_queue_t downloadQueue = dispatch_queue_create("com.sanginfo.processimagequeue", NULL);
  dispatch_async(downloadQueue, ^{
    NSData * imageData = [NSData dataWithContentsOfURL:url];
    dispatch_async(callerQueue, ^{
      [self processImage:imageData];
    });
  });
  
  
}

-(void)processImage:(NSData *)imageData{
  NSLog(@"image Update");
  self.icon=[self borderImageCircle:[UIImage imageWithData:imageData] scaledToSize:CGSizeMake(40, 40)];
}

- (UIImage *)borderImageCircle:(UIImage *)image scaledToSize:(CGSize)newSize{
  UIImage *im=[self imageWithCircleFrame:image scaledToSize:newSize];
  
  UIImageView *imgiew=[[UIImageView alloc] initWithImage:im];
  imgiew.backgroundColor=[UIColor clearColor];
  imgiew.layer.borderColor= [UIColor blackColor].CGColor;
  imgiew.layer.borderWidth=3;
  imgiew.layer.cornerRadius = newSize.width/2;
  //imgiew.layer.masksToBounds = YES;
  UIImage *borderImage=[self imageByRenderingView:imgiew];
  UIImage *roundedImage=[self imageWithRoundedCornersSize:newSize.width/2 usingImage:borderImage ];
  
  return roundedImage;
}


- (UIImage *)imageByRenderingView:(UIView *)view
{
  UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [[UIScreen mainScreen] scale]);
  [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
  UIImage * snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return snapshotImage;
}

- (UIImage *)imageWithCircleFrame:(UIImage *)image scaledToSize:(CGSize)newSize {
  // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
  // Pass 1.0 to force exact pixel size.
  UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
  [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return newImage;
}

- (UIImage *)imageWithRoundedCornersSize:(float)cornerRadius usingImage:(UIImage *)original
{
  UIImageView *imageView = [[UIImageView alloc] initWithImage:original];
  
  // Begin a new image that will be the new image with the rounded corners
  // (here with the size of an UIImageView)
  UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 2.0);
  
  
  // Add a clip before drawing anything, in the shape of an rounded rect
  UIBezierPath *path =[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                                 cornerRadius:cornerRadius];
  [path addClip];
  
  
  // Draw your image
  [original drawInRect:imageView.bounds];
    // Get the image, here setting the UIImageView image
  imageView.image = UIGraphicsGetImageFromCurrentImageContext();
  
  // Lets forget about that we were drawing
  UIGraphicsEndImageContext();
  
  return imageView.image;
}

@end
