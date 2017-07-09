//
//  ImageLoader.m
//  Naplayer
//
//  Created by Modona on 2017/3/20.
//  Copyright © 2017年 Modona. All rights reserved.
//

#import "ImageLoader.h"

@implementation ImageLoader
-(void)loadImage:(MyImageView *)imageview{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imageview.imgUrl]];
        __weak typeof(imageview) weakImageview=imageview;
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakImageview setImage:[UIImage imageWithData:data]];
        });
    });
}
-(void)loadImage:(UIImageView*)imageview andImgUrl:(NSString*)imgUrl{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData* data=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]];
        __weak typeof(imageview) weakImageview=imageview;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakImageview setImage:[UIImage imageWithData:data]];
        });
    });
}
@end
