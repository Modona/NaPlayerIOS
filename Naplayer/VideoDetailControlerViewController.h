//
//  VideoDetailControlerViewController.h
//  Naplayer
//
//  Created by Modona on 2017/3/22.
//  Copyright © 2017年 Modona. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLoader.h"
#import "MyImageView.h"
#import "MyButton.h"
#import "DetailCollectionViewCell.h"
#import "DetailCollectionHeaderViewCollectionReusableView.h"
#import "IJKMoviePlayerViewController.h"
#import "NaCrawl.h"
#import "DetailCollectionviewImpl.h"
@interface VideoDetailControlerViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIView *bar;
@property (nonatomic) BOOL isDeatilPanelOpen;
@property (nonatomic) NSInteger selected;
@property(strong,nonatomic) MyImageView* forDataImgview;
@property (nonatomic,strong) DetailCollectionviewImpl* collectionDelegate;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UITextView *videoIntroduce;
//@property (weak, nonatomic) IBOutlet UILabel *labelBar;
@property (weak, nonatomic) IBOutlet UICollectionView *detailCollectionview;
@property (weak, nonatomic) IBOutlet UIImageView *blueImage;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *introducePanel;
@property (weak, nonatomic) IBOutlet UIView *videoPanel;
+(void) preLoadVideoDetail:(UIViewController*)fromControler andImageView:(MyImageView*)imageView;
+(void) preLoadWithString:(UIViewController*)fromControler andImgUrl:(NSString*)imgUrl andPlayUrl:(NSString*)playUrl;

@end
