//
//  FirstViewController.m
//  Naplayer
//
//  Created by Modona on 2017/3/12.
//  Copyright © 2017年 Modona. All rights reserved.
//

#import "FirstViewController.h"
#import "RecipeCollectionHeaderView.h"
#import "PlayItem.h"
#import "ImageLoader.h"
#import "MyImageView.h"
#import "MyScrollView.h"
@interface FirstViewController ()
@property (strong, nonatomic) IBOutlet UIView *mainPage;
@property (strong,nonatomic)  NSMutableDictionary* scrollDict;
@property (strong,nonatomic)  NSMutableDictionary* pageCtrls;
@property (strong,nonatomic) NSMutableArray* dataArray;
@property (nonatomic) ImageLoader* imageLoader;
@property (nonatomic) CGFloat screenHeight;
@property (nonatomic) CGFloat screenWidth;
@end

@implementation FirstViewController
- (void)viewDidLoad {
    NSLog(@"reload");
    [super viewDidLoad];
    _screenWidth=self.view.frame.size.width;
    _screenHeight=self.view.frame.size.height;
    _scrollDict=[[NSMutableDictionary alloc] init];
    _pageCtrls=[[NSMutableDictionary alloc] init];
    _imageLoader=[[ImageLoader alloc] init];
    // Do any additional setup after loading the view, typically from a nib.

    
}
-(void)scrollViewDidEndDecelerating:(MyScrollView *)scrollView{
    
    switch ([scrollView tag]) {
        case 0:
          
            
            break;
        case 1:
            
            
            break;
        case 2:
            NSLog(@"2");
            break;
        case 3:
            NSLog(@"3");
            break;
        case 4:
            NSLog(@"4");
            break;
        case 5:
            NSLog(@"5");
            break;
        case 6:
            NSLog(@"6");
            break;
        case 7:
            NSLog(@"7");
            break;
        default:
            break;
    }
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader){
        
        RecipeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
                headerView.text.text=@"电影";
                
                break;
            case 1:
                headerView.text.text=@"电视剧";
                
                break;
            case 2:
                headerView.text.text=@"综艺";
                
                break;
            case 3:
                headerView.text.text=@"动漫";
                break;
            case 4:
                headerView.text.text=@"体育";
                
                break;
            case 5:
                headerView.text.text=@"校园视频";
                break;
            case 6:
                headerView.text.text=@"日韩";
                
                break;
            default:
                break;
        }
        reusableview = headerView;
        
    }
    
    if (kind == UICollectionElementKindSectionFooter){
        
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        
        reusableview = footerview;
        
    }
    
    return reusableview;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    UIScrollView* scrollView=[_scrollDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
    for(UIView* view in [scrollView subviews])
    {
        [view removeFromSuperview];
    }
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    MyScrollView* scrollView;
    UIPageControl* pageCtrl;
    for (UIView *subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    if((scrollView=[_scrollDict objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]])!=nil){
        
        pageCtrl=[_pageCtrls objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
        if([_dataArray count]==0)
        {
            [self scrollAddItem:scrollView andPageCtrl:pageCtrl andDataArray:_dataArray];
        }
        else{
            [self displayInit:scrollView andPageCtrl:pageCtrl andSection:indexPath.section];
        }
        [cell.contentView addSubview:scrollView];
        [cell.contentView addSubview:pageCtrl];
        
    }
    else{
        
        scrollView=[[MyScrollView alloc] initWithFrame:CGRectMake(_screenWidth*0.021, 0, _screenWidth*0.958, _screenHeight*0.464)];
        pageCtrl=[[UIPageControl alloc] initWithFrame:CGRectMake(0,_screenHeight*0.490, _screenWidth*0.958,_screenHeight*0.042)];
        
        //        UILabel* label=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        //        label.text=@"1";
        //        label.backgroundColor=[UIColor redColor];
        //        UILabel* label2=[[UILabel alloc] initWithFrame:CGRectMake(359, 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        //        label2.text=@"2";
        //        label2.backgroundColor=[UIColor blueColor];
        [scrollView setTag:indexPath.section+1];
        //        [scrollView addSubview:label];
        //        [scrollView addSubview:label2];
        if([_dataArray count]==0)
        {
            [self scrollAddItem:scrollView andPageCtrl:pageCtrl andDataArray:_dataArray];
        }
        else{
            NSLog(@"Initnewdata");
            [self displayInit:scrollView andPageCtrl:pageCtrl andSection:indexPath.section];
        }
        [scrollView setDelegate:self];
        [scrollView setScrollEnabled:NO];
        UISwipeGestureRecognizer *recogizerRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        recogizerRight.direction=UISwipeGestureRecognizerDirectionRight;
        
        [scrollView addGestureRecognizer:recogizerRight];
        
        UISwipeGestureRecognizer *recogizerLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        recogizerLeft.direction=UISwipeGestureRecognizerDirectionLeft;
        [scrollView addGestureRecognizer:recogizerLeft];
        
        [scrollView setAlwaysBounceHorizontal:YES];
        
        //pageControl Test
        
        pageCtrl.currentPage=0;
        pageCtrl.currentPageIndicatorTintColor=[UIColor blackColor];
        pageCtrl.pageIndicatorTintColor=[UIColor lightGrayColor];
        [pageCtrl setTag:indexPath.section+8];
        [pageCtrl addTarget:self action:@selector(actionPage:) forControlEvents:UIControlEventValueChanged];
        [_scrollDict setObject:scrollView forKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
        [_pageCtrls setObject:pageCtrl forKey:[NSString stringWithFormat:@"%ld",indexPath.section]];
        [cell.contentView addSubview:scrollView];
        [cell.contentView addSubview:pageCtrl];
        
    }

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString* cellIdentifier=@"myCell";
    UICollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    return cell;
    
}
-(void)displayInit:(MyScrollView*)scrollview andPageCtrl:(UIPageControl*)pageCtrl andSection:(NSInteger)section{
    switch (section) {
        case 0:
            [self scrollAddItem:scrollview andPageCtrl:pageCtrl andDataArray:_dataArray[0]];
            break;
        case 1:
             [self scrollAddItem:scrollview andPageCtrl:pageCtrl andDataArray:_dataArray[1]];
            break;
        case 2:
             [self scrollAddItem:scrollview andPageCtrl:pageCtrl andDataArray:_dataArray[2]];
            break;
        case 3:
             [self scrollAddItem:scrollview andPageCtrl:pageCtrl andDataArray:_dataArray[3]];
            break;
        case 4:
             [self scrollAddItem:scrollview andPageCtrl:pageCtrl andDataArray:_dataArray[4]];
            break;
        case 5:
             [self scrollAddItem:scrollview andPageCtrl:pageCtrl andDataArray:_dataArray[5]];
            break;
        case 6:
             [self scrollAddItem:scrollview andPageCtrl:pageCtrl andDataArray:_dataArray[6]];
            break;
            
        default:
            break;
    }
}

-(void)scrollAddItem:(MyScrollView*)scrollview andPageCtrl:(UIPageControl*)pageCtrl andDataArray:(NSMutableArray*)data{
    NSInteger count=[data count];
    scrollview.contentSize= CGSizeMake(ceil((double)count/4)*(scrollview.frame.size.width),scrollview.frame.size.height);
    pageCtrl.numberOfPages=ceil((double)count/4);
    int allCount=0;
    __weak typeof(self) weakSelf=self;
    CGFloat scrollThrought=weakSelf.screenWidth*0.958;
    CGFloat viewWidth=weakSelf.screenWidth*0.446;
    CGFloat imgHeight=weakSelf.screenHeight*0.1574;
    CGFloat labelHeight=weakSelf.screenHeight*0.044;
    CGFloat padding=weakSelf.screenWidth*0.0186;
    CGFloat secondRow=weakSelf.screenWidth*0.493;
    CGFloat labelFirst=weakSelf.screenHeight*0.170;
    CGFloat imgSecond=weakSelf.screenHeight*0.243;
    CGFloat labelSecond=weakSelf.screenHeight*0.402;
    for(int i=0;i<ceil((double)count/4);i++)
    {
        for(int q=0;q<4;q++)
        {
            if(allCount<count)
            {
                PlayItem* playItem=(PlayItem*)data[allCount];
                allCount++;
                if(q==0){
                MyImageView* tmpImageview0=[[MyImageView alloc] initWithFrame:CGRectMake(padding+scrollThrought*i, padding, viewWidth, imgHeight)];
                tmpImageview0.imgUrl=playItem.imgurl;
                tmpImageview0.playUrl=playItem.playurl;
                tmpImageview0.layer.cornerRadius=padding;
                tmpImageview0.contentMode=UIViewContentModeScaleAspectFill;
                tmpImageview0.clipsToBounds=YES;
                tmpImageview0.layer.borderWidth=padding/10;
                tmpImageview0.layer.borderColor=[UIColor lightGrayColor].CGColor;
                tmpImageview0.userInteractionEnabled=YES;
                    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
                    [tmpImageview0 addGestureRecognizer:singleTap];
                    [_imageLoader loadImage:tmpImageview0];
                UILabel* tmpLabel0=[[UILabel alloc] initWithFrame:CGRectMake(padding+scrollThrought*i, labelFirst, viewWidth, labelHeight)];
                    tmpLabel0.font=[UIFont systemFontOfSize:labelHeight/2.4];
                tmpLabel0.numberOfLines=0;
                tmpLabel0.textColor=[UIColor darkGrayColor];
                tmpLabel0.text=playItem.playname;
                [scrollview addSubview:tmpImageview0];
                [scrollview addSubview:tmpLabel0];
                }
                else if(q==1){
                    MyImageView* tmpImageview0=[[MyImageView alloc] initWithFrame:CGRectMake(secondRow+scrollThrought*i, padding, viewWidth, imgHeight)];
                    tmpImageview0.imgUrl=playItem.imgurl;
                    tmpImageview0.playUrl=playItem.playurl;
                    tmpImageview0.layer.cornerRadius=padding;
                    tmpImageview0.contentMode=UIViewContentModeScaleAspectFill;
                    tmpImageview0.clipsToBounds=YES;
                    tmpImageview0.layer.borderWidth=padding/10;
                    tmpImageview0.layer.borderColor=[UIColor lightGrayColor].CGColor;
                    tmpImageview0.userInteractionEnabled=YES;
                    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
                    [tmpImageview0 addGestureRecognizer:singleTap];
                     [_imageLoader loadImage:tmpImageview0];
                    UILabel* tmpLabel0=[[UILabel alloc] initWithFrame:CGRectMake(secondRow+scrollThrought*i, labelFirst, viewWidth, labelHeight)];
                    tmpLabel0.font=[UIFont systemFontOfSize:labelHeight/2.4];
                    tmpLabel0.numberOfLines=0;
                    tmpLabel0.text=playItem.playname;
                    tmpLabel0.textColor=[UIColor darkGrayColor];
                    [scrollview addSubview:tmpImageview0];
                    [scrollview addSubview:tmpLabel0];
                }
                else if(q==2){
                    MyImageView* tmpImageview0=[[MyImageView alloc] initWithFrame:CGRectMake(padding+scrollThrought*i, imgSecond, viewWidth, imgHeight)];
                    tmpImageview0.imgUrl=playItem.imgurl;
                    tmpImageview0.playUrl=playItem.playurl;
                    tmpImageview0.contentMode=UIViewContentModeScaleAspectFill;
                    tmpImageview0.layer.cornerRadius=padding;
                    tmpImageview0.clipsToBounds=YES;
                    tmpImageview0.layer.borderWidth=padding/10;
                    tmpImageview0.layer.borderColor=[UIColor lightGrayColor].CGColor;
                    tmpImageview0.userInteractionEnabled=YES;
                    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
                    [tmpImageview0 addGestureRecognizer:singleTap];
                     [_imageLoader loadImage:tmpImageview0];
                    UILabel* tmpLabel0=[[UILabel alloc] initWithFrame:CGRectMake(padding+scrollThrought*i, labelSecond, viewWidth, labelHeight)];
                    tmpLabel0.font=[UIFont systemFontOfSize:labelHeight/2.4];
                    tmpLabel0.numberOfLines=0;
                    tmpLabel0.textColor=[UIColor darkGrayColor];
                    tmpLabel0.text=playItem.playname;
                    [scrollview addSubview:tmpImageview0];
                    [scrollview addSubview:tmpLabel0];
                }
                else if(q==3){
                    MyImageView* tmpImageview0=[[MyImageView alloc] initWithFrame:CGRectMake(secondRow+scrollThrought*i,imgSecond, viewWidth, imgHeight)];
                    tmpImageview0.imgUrl=playItem.imgurl;
                    tmpImageview0.playUrl=playItem.playurl;
                    tmpImageview0.layer.cornerRadius=padding;
                    tmpImageview0.contentMode=UIViewContentModeScaleAspectFill;
                    tmpImageview0.clipsToBounds=YES;
                    tmpImageview0.layer.borderWidth=padding/10;
                    tmpImageview0.layer.borderColor=[UIColor lightGrayColor].CGColor;
                    tmpImageview0.userInteractionEnabled=YES;
                    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapAction:)];
                    [tmpImageview0 addGestureRecognizer:singleTap];
                     [_imageLoader loadImage:tmpImageview0];
                    UILabel* tmpLabel0=[[UILabel alloc] initWithFrame:CGRectMake(secondRow+scrollThrought*i, labelSecond,viewWidth, labelHeight)];
                    tmpLabel0.font=[UIFont systemFontOfSize:labelHeight/2.4];
                    tmpLabel0.numberOfLines=0;
                    tmpLabel0.textColor=[UIColor darkGrayColor];
                    tmpLabel0.text=playItem.playname;
                    [scrollview addSubview:tmpImageview0];
                    [scrollview addSubview:tmpLabel0];
                }
            }
        }
    }
}
-(void)imageTapAction:(UITapGestureRecognizer *)recognizer{
    
    MyImageView* imgView=(MyImageView*)recognizer.view;
    [VideoDetailControlerViewController preLoadVideoDetail:self andImageView:imgView];
}
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
   __weak MyScrollView* scrollview=(MyScrollView*)[recognizer view];
    __weak typeof(self) weakSelf=self;
    NSString* index;
    for(NSString* key in _scrollDict)
    {
        if([_scrollDict[key] isEqual:scrollview])
            index=key;
        
    }
    switch (recognizer.direction) {
            
            
        case UISwipeGestureRecognizerDirectionLeft:
            if((scrollview.contentOffset.x+5)>=(scrollview.contentSize.width-weakSelf.screenWidth*0.958))
            {
                [scrollview setContentOffset:CGPointMake(scrollview.contentOffset.x, 0) animated:YES];
                
            }else if(scrollview.scrollLock!=YES){
                scrollview.scrollLock=YES;
                NSLog(@"contentX:%f",scrollview.contentOffset.x);
                NSLog(@"contentX:%f",weakSelf.screenWidth*0.958);
                [scrollview setContentOffset:CGPointMake(scrollview.contentOffset.x+weakSelf.screenWidth*0.958, 0) animated:YES];
                [(UIPageControl*)[_pageCtrls objectForKey:index] setCurrentPage:[(UIPageControl*)[_pageCtrls objectForKey:index] currentPage]+1];
            }
            break;
        case UISwipeGestureRecognizerDirectionRight:
            if((scrollview.contentOffset.x+40)<=scrollview.frame.size.width)
            {
                [scrollview setContentOffset:CGPointMake(0, 0) animated:YES];
            }else if(scrollview.scrollLock!=YES){
                scrollview.scrollLock=YES;
                 [scrollview setContentOffset:CGPointMake(scrollview.contentOffset.x-weakSelf.screenWidth*0.958, 0) animated:YES];
                 [(UIPageControl*)[_pageCtrls objectForKey:index] setCurrentPage:[(UIPageControl*)[_pageCtrls objectForKey:index] currentPage]-1];
            }
            break;
        default:
            break;
    }
}
-(void)scrollViewDidEndScrollingAnimation:(MyScrollView *)scrollView{
    scrollView.scrollLock=NO;
}
-(void)actionPage:(id)sender{
    __weak typeof(self)weakSelf=self;
    UIPageControl* pageCtrl=(UIPageControl*)sender;
    [(MyScrollView*)[_scrollDict objectForKey:[NSString stringWithFormat:@"%ld",pageCtrl.tag-8]] setContentOffset:CGPointMake(pageCtrl.currentPage*weakSelf.screenWidth*0.958, 0) animated:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 7;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
-(void)updateDateSource:(NSMutableArray *)tmpArray{
    NSLog(@"%@",tmpArray);
}
-(void)test:(id)sender{
    __weak typeof(self) weakSelf=self;
    [NaCrawl mainPageCrawl:^(NSMutableArray* resultArray){
       weakSelf.dataArray=resultArray;
        [weakSelf.collectionView reloadData];
    }];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL)shouldAutorotate{
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
