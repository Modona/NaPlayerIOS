//
//  ImageLoader.h
//  Naplayer
//
//  Created by Modona on 2017/3/20.
//  Copyright © 2017年 Modona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyImageView.h"
@interface ImageLoader :NSObject
-(void)loadImage:(MyImageView*)imaeview;
-(void)loadImage:(UIImageView*)imaeview andImgUrl:(NSString*)imgUrl;
@end
