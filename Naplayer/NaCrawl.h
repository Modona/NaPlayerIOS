//
//  NaCrawl.h
//  Naplayer
//
//  Created by Modona on 2017/3/17.
//  Copyright © 2017年 Modona. All rights reserved.
//

#ifndef NaCrawl_h
#define NaCrawl_h


#endif /* NaCrawl_h */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FirstViewController.h"
@interface NaCrawl : NSObject
+(void)getPageData:(NSString*)pageUrl andCallBack:(void(^)(NSData*))callBack;
+(void)mainPageCrawl:(void(^)(NSMutableArray*))callBack;
+(void)searchPageCrawl:(NSString*)searchUrl andCallBack:(void (^)(NSMutableArray *))callBack;
+(void)videoIndexCrawl:(NSString*)playUrl ndCallBack:(void (^)(NSMutableArray *))callBack;
+(void)detailPageCrawl:(NSString*)playUrl andCallBack:(void (^)(NSString *))callBack;
+(void)introduceCrawl:(NSString*)playUrl;
+(void)print;
+(NSString*)urlDecode:(NSString*)url;
@end
