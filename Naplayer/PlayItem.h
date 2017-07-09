//
//  PlayItem.h
//  Naplayer
//
//  Created by Modona on 2017/3/17.
//  Copyright © 2017年 Modona. All rights reserved.
//

#ifndef PlayItem_h
#define PlayItem_h


#endif /* PlayItem_h */
#import <Foundation/Foundation.h>

@interface PlayItem : NSObject
@property(strong,nonatomic) NSString* playurl;
@property(strong,nonatomic) NSString*  imgurl;
@property(strong,nonatomic) NSString* playname;
-(NSString*)description;
@end
