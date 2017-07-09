//
//  FirstViewController.h
//  Naplayer
//
//  Created by Modona on 2017/3/12.
//  Copyright © 2017年 Modona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaCrawl.h"
#import "updateData.h"
#import "UIMyScrollView.h"
#import "VideoDetailControlerViewController.h"
#import "AppDelegate.h"
@interface FirstViewController : UIViewController<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,updateData>
@property(nonatomic,strong)IBOutlet UICollectionView* collectionView;
-(IBAction)test:(id)sender;
-(IBAction)actionPage:(id)sender;
@end

