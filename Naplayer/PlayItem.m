//
//  PlayItem.m
//  Naplayer
//
//  Created by Modona on 2017/3/17.
//  Copyright © 2017年 Modona. All rights reserved.
//

#import "PlayItem.h"

@interface PlayItem ()

@end

@implementation PlayItem

@synthesize playurl,imgurl,playname;
-(NSString*)description{
    return [NSString stringWithFormat:@"playurl:%@\nimgurl:%@\nplayname:%@",playurl,imgurl,playname];
}
@end
