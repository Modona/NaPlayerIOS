//
//  NaCrawl.m
//  Naplayer
//
//  Created by Modona on 2017/3/17.
//  Copyright © 2017年 Modona. All rights reserved.
//
#ifdef DEBUG
#define NSLog(format,...) printf("%s",[[NSString stringWithFormat:(format),##__VA_ARGS__]UTF8String])
#endif
#import "NaCrawl.h"
#import "PlayItem.h"

static NSString* ret;
@interface NaCrawl()
@end

@implementation NaCrawl
+(void)getPageData:(NSString*)pageUrl andCallBack:(void (^)(NSData*))callBack{
   
    pageUrl=[pageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"pageUrl%@",pageUrl);
    NSURL* url=[NSURL URLWithString:pageUrl];
   
    NSString *userAgentString = @"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36";
     NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders=@{@"User-Agent": userAgentString};
    NSURLSession* session=[NSURLSession sessionWithConfiguration:config];
    NSURLSessionTask* task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",error);
        callBack(data);
        
    }];
    [task resume];
}
+(void)mainPageCrawl:(void (^)(NSMutableArray *))callBack{
    
   [NaCrawl getPageData:@"http://navod.scse.com.cn/nn_cms/data/template/100000/200003/index_v3_001.php" andCallBack:^(NSData* data){
            NSString* result=[[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
      
        NSRegularExpression *clearRegex=[NSRegularExpression regularExpressionWithPattern:@"[\t\n\r]" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *dataRegex = [NSRegularExpression regularExpressionWithPattern:@"(?:(?:\\\"><ul>)|(?:</li>))<li><a href=\\\"(.*?)\\\"><div  class=\\\"shadow\\\"><img src=\\\"img/shadow.png\\\" alt=\\\"\\\" /></div><img style=\\\"width:116px;height:156px;\\\" src=\\\"(.*?)\\\" alt=\\\"\\\"><span class=\\\"programName\\\">(.*?)</span></a>" options:NSRegularExpressionCaseInsensitive error:nil];
        result=[clearRegex stringByReplacingMatchesInString:result options:0 range:NSMakeRange(0, result.length) withTemplate:@""];
        NSArray* dataResult=[dataRegex matchesInString:result options:0 range:NSMakeRange(19842, result.length-19843)];
       NSMutableArray* tmpMutArray=[[NSMutableArray alloc] init];
       NSMutableArray* tmpListArray=[[NSMutableArray alloc] init];
       int i=0;
       NSInteger fetchCount=[dataResult count];
        for (NSTextCheckingResult *match in dataResult) {
            PlayItem* tmpItem=[PlayItem alloc];
            tmpItem.playurl= [result substringWithRange:[match rangeAtIndex:1]];
            tmpItem.imgurl= [result substringWithRange:[match rangeAtIndex:2]];
            tmpItem.playname= [result substringWithRange:[match rangeAtIndex:3]];
           
            if(i<6)
            {
                [tmpListArray addObject:tmpItem];
                if(i==5)
                {
                    [tmpMutArray addObject:tmpListArray];
                    tmpListArray=[[NSMutableArray alloc] init];
                }
            }else if (i < 18) {
                
                    [tmpListArray addObject:tmpItem];
                    if (i == 17) {
                        
                        [tmpMutArray addObject:tmpListArray];
                        tmpListArray=[[NSMutableArray alloc] init];
                    }
                } else if (i < 30) {
                    
                   [tmpListArray addObject:tmpItem];
                    if (i== 29) {
                        [tmpMutArray addObject:tmpListArray];
                        tmpListArray=[[NSMutableArray alloc] init];
                    }
                    
                } else if (i < 36) {
                    
                    [tmpListArray addObject:tmpItem];
                    if (i== 35) {
                        [tmpMutArray addObject:tmpListArray];
                        tmpListArray=[[NSMutableArray alloc] init];
                    }
                } else if (i< 42) {
                    
                    [tmpListArray addObject:tmpItem];
                    if (i== 41) {
                        [tmpMutArray addObject:tmpListArray];
                        tmpListArray=[[NSMutableArray alloc] init];
                    }
                    
                } else if (i< 54) {
                    
                    [tmpListArray addObject:tmpItem];
                    if (i == 53) {
                        [tmpMutArray addObject:tmpListArray];
                        tmpListArray=[[NSMutableArray alloc] init];
                    }
                }else if(fetchCount>65)
                {
                 if(i<65){
                
                }
            
                else if (i < 77) {
                    [tmpListArray addObject:tmpItem];
                    if (i== 76) {
                        [tmpMutArray addObject:tmpListArray];
                  
                    }
                }}else if(fetchCount<70){
                     if (i < 66) {
                        [tmpListArray addObject:tmpItem];
                        if (i== 65) {
                            [tmpMutArray addObject:tmpListArray];
                            
                        }
                }
            }
            i++;
        }

       dispatch_sync(dispatch_get_main_queue(), ^{
           callBack(tmpMutArray);
       });
   }];

    }
+(void)searchPageCrawl:(NSString*)searchUrl andCallBack:(void (^)(NSMutableArray *))callBack{
    [NaCrawl getPageData:searchUrl andCallBack:^(NSData* data){
        
        NSString* result=[[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
        NSRegularExpression *clearRegex=[NSRegularExpression regularExpressionWithPattern:@"[\t\n\r]" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *dataRegex = [NSRegularExpression regularExpressionWithPattern:@"<li ><a href=\\\"(.*?)\\\"><div  class=\\\"shadow\\\"><img src=\\\"img/shadow.png\\\" alt=\\\"\\\" /></div><img style=\\\"width:116px;height:156px;\\\" src=\\\"(.*?)\\\" alt=\\\"\\\"><span class=\\\"programName\\\">(.*?)</span></a></li>" options:NSRegularExpressionCaseInsensitive error:nil];
        result=[clearRegex stringByReplacingMatchesInString:result options:0 range:NSMakeRange(0, result.length) withTemplate:@""];
        NSArray* dataResult=[dataRegex matchesInString:result options:0 range:NSMakeRange(0, result.length)];
        NSMutableArray* resultArray=[[NSMutableArray alloc] init];
        for (NSTextCheckingResult *match in dataResult) {
            PlayItem* tmpItem=[PlayItem alloc];
            tmpItem.playurl= [result substringWithRange:[match rangeAtIndex:1]];
            tmpItem.imgurl= [result substringWithRange:[match rangeAtIndex:2]];
            tmpItem.playname= [result substringWithRange:[match rangeAtIndex:3]];
            [resultArray addObject:tmpItem];
            
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            callBack(resultArray);
        });
    }];
    
}
+(void)videoIndexCrawl:(NSString*)playUrl ndCallBack:(void (^)(NSMutableArray *))callBack{
    [NaCrawl getPageData:playUrl andCallBack:^(NSData* data){
        NSString* result=[[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSRegularExpression *clearRegex=[NSRegularExpression regularExpressionWithPattern:@"[\t\n\r]" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *dataRegex = [NSRegularExpression regularExpressionWithPattern:@"<a href=\"(.*?)\" class=\"button1 movie_page_indexa.*?\">(.*?)</a>" options:NSRegularExpressionCaseInsensitive error:nil];
        result=[clearRegex stringByReplacingMatchesInString:result options:0 range:NSMakeRange(0, result.length) withTemplate:@""];
        result=[result substringWithRange:NSMakeRange([result rangeOfString:@"<div class=\"selectNum\">"].location,result.length-[result rangeOfString:@"<div class=\"selectNum\">"].location-1)];
        NSArray* dataResult=[dataRegex matchesInString:result options:0 range:NSMakeRange(0, result.length)];
        NSMutableArray* indexArray=[[NSMutableArray alloc] init];
        for (NSTextCheckingResult *match in dataResult) {
            NSString* indexName= [result substringWithRange:[match rangeAtIndex:2]];
            [indexArray addObject:indexName];
            NSLog(@"%@",indexName);
            
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            callBack(indexArray);
        });
    }];

}
+(void)detailPageCrawl:(NSString*)playUrl andCallBack:(void (^)(NSString *))callBack{

    [NaCrawl getPageData:playUrl andCallBack:^(NSData* data){
        NSString* result=[[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSRegularExpression *clearRegex=[NSRegularExpression regularExpressionWithPattern:@"[\t\n\r]" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *dataRegex = [NSRegularExpression regularExpressionWithPattern:@"play_url=(.*?)\\.mp4" options:NSRegularExpressionCaseInsensitive error:nil];
        result=[clearRegex stringByReplacingMatchesInString:result options:0 range:NSMakeRange(0, result.length) withTemplate:@""];
        NSArray* dataResult=[dataRegex matchesInString:result options:0 range:NSMakeRange(0, result.length)];
        NSString* videoUrl;
        for(NSTextCheckingResult* result2 in dataResult){
            videoUrl=[NaCrawl urlDecode:[[NSString alloc] initWithFormat:@"%@.mp4",[result substringWithRange:[result2 rangeAtIndex:1]]]];
            if([videoUrl rangeOfString:@"102:"].location!=NSNotFound)
                break;
        }
      
        NSLog(@"%@",videoUrl);
        dispatch_sync(dispatch_get_main_queue(), ^{
            callBack(videoUrl);
        });
        }];
}
+(void)introduceCrawl:(NSString*)playUrl{
    [NaCrawl getPageData:playUrl andCallBack:^(NSData* data){
        NSString* result=[[NSMutableString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSRegularExpression *clearRegex=[NSRegularExpression regularExpressionWithPattern:@"[\t\n\r]" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *dataRegex = [NSRegularExpression regularExpressionWithPattern:@"<div class=\"article\">(.*?)</div>" options:NSRegularExpressionCaseInsensitive error:nil];
        result=[clearRegex stringByReplacingMatchesInString:result options:0 range:NSMakeRange(0, result.length) withTemplate:@""];
        NSArray* dataResult=[dataRegex matchesInString:result options:0 range:NSMakeRange(0, result.length)];
        NSString* preIntroduce=[result substringWithRange:[dataResult[1] rangeAtIndex:1]];
        
        NSRegularExpression* introduceRegex=[NSRegularExpression regularExpressionWithPattern:@"<p>(.*?)</p>" options:NSRegularExpressionCaseInsensitive error:nil];
        NSArray* intruduce=[introduceRegex matchesInString:preIntroduce options:0 range:NSMakeRange(0, preIntroduce.length)];
        for(NSTextCheckingResult* match in intruduce)
        {
            NSString* tmpStr=[preIntroduce substringWithRange:[match rangeAtIndex:1]];
            NSLog(@"%@",tmpStr);
        }
        }];
}
+(void)print{
    NSString* test=[NSString stringWithFormat:@"1234cb"];
     NSRegularExpression *rpRegex=[NSRegularExpression regularExpressionWithPattern:@"(\\d*)([a-z]*)" options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray* datRet=[rpRegex matchesInString:test options:0 range:NSMakeRange(0,6)];
    for (NSTextCheckingResult *match in datRet) {
        NSString* substringForMatch = [test substringWithRange:[match rangeAtIndex:0]];
        NSLog(@"Extracted: %@",substringForMatch);
    
    }

}
+(NSString*)urlDecode:(NSString*)url{
    NSString* decodedString=(__bridge_transfer NSString*)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)url, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
   
    return decodedString;
}
   @end
