//
//  BarTableViewCell.m
//  PlaceFinder
//
//  Created by Sanginfo on 03/03/17.
//  Copyright © 2017 Sanginfo. All rights reserved.
//

#import "BarTableViewCell.h"
#import "ImageCacheManager.h"
#import "PlaceFinderKeys.h"
@interface BarTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgBarImage;
@property (weak, nonatomic) IBOutlet UILabel *lblBarName;
@property (retain, nonatomic)  NSString *strBarRef;
@property (strong, nonatomic)  NSString *cellurl;
@end
@implementation BarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillData:(NSDictionary *)data{
  self.lblBarName.text=[data objectForKey:@"barname"];
  self.strBarRef=[data objectForKey:@"imageRef"];
  NSString *url=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?key=%@&photoreference=%@&maxwidth=320",GOOGLE_PLACEAPI, self.strBarRef];
  
  self.cellurl=url;
  
  __weak typeof (BarTableViewCell *) weakCell=self;
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *ImageURL=[NSString stringWithFormat:@"%@",url];
    ImageCacheManager *icm=[[ImageCacheManager alloc]init];
    UIImage *image = [icm getCachedImage:ImageURL];
    if (image) {
      dispatch_async(dispatch_get_main_queue(), ^{
        if (weakCell!=nil) {
          if ([weakCell.cellurl isEqualToString:url]) {
            weakCell.imgBarImage.image = image;
          }
        }
      });
    }
  });
//  NSURL *url = [NSURL URLWithString:imageURL];
//  NSData * imageData = [NSData dataWithContentsOfURL:url];
//  self.imgBarImage.image=[UIImage imageWithData:imageData];
}

@end
