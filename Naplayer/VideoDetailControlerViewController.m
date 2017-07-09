//
//  VideoDetailControlerViewController.m
//  Naplayer
//
//  Created by Modona on 2017/3/22.
//  Copyright © 2017年 Modona. All rights reserved.
//

#import "VideoDetailControlerViewController.h"

@interface VideoDetailControlerViewController ()
@property(nonatomic) ImageLoader* imageLoader;
@property(nonatomic,strong) NSMutableArray* indexArray;
@property(nonatomic,strong) NSString* introduceText;
@end

@implementation VideoDetailControlerViewController
+(void)preLoadVideoDetail:(UIViewController *)fromControler andImageView:(MyImageView *)imageView{
    [fromControler.navigationController pushViewController:[VideoDetailControlerViewController iniWithImageView:imageView] animated:YES];
}
+(void)preLoadWithString:(UIViewController *)fromControler andImgUrl:(NSString *)imgurl andPlayUrl:(NSString *)playUrl{
      [fromControler.navigationController pushViewController:[VideoDetailControlerViewController initWithStirng:imgurl andPlayUrl:playUrl] animated:YES];
}
+(VideoDetailControlerViewController*)iniWithImageView:(MyImageView*)imageview{
    VideoDetailControlerViewController* vc=[[VideoDetailControlerViewController alloc] init];
    vc.forDataImgview=imageview;
    return vc;
}
+(VideoDetailControlerViewController*)initWithStirng:(NSString*)imgUrl andPlayUrl:(NSString*)playUrl{
    VideoDetailControlerViewController* vc=[[VideoDetailControlerViewController alloc] init];
    
    vc.forDataImgview=[[MyImageView alloc] init];
    vc.forDataImgview.playUrl=playUrl;
    vc.forDataImgview.imgUrl=imgUrl;
    return vc;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [_collectionView reloadData];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _selected=-1;
     _isDeatilPanelOpen=NO;
    //添加手势
    UITapGestureRecognizer* Tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDetail:)];
    [_introducePanel addGestureRecognizer:Tap];
    
    UITapGestureRecognizer* Tap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showSelectDetail:)];
    [_videoPanel addGestureRecognizer:Tap2];
    
    UITapGestureRecognizer* tap3=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeDetailPanel:)];
    [_videoPanel addGestureRecognizer:Tap2];
    [self.view addGestureRecognizer:tap3];
    self.navigationController.interactivePopGestureRecognizer.delegate=self;
    _collectionDelegate=[[DetailCollectionviewImpl alloc] initWithView:_detailCollectionview];
    _detailCollectionview.delegate=_collectionDelegate;
    _detailCollectionview.dataSource=_collectionDelegate;
    [_detailCollectionview registerClass:[DetailCollectionViewCell class] forCellWithReuseIdentifier:@"indexCell"];
    [_detailCollectionview registerNib:[UINib nibWithNibName:@"DetailCollectionHeaderViewCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
//    UICollectionViewFlowLayout* flowLayout=(UICollectionViewFlowLayout*) [_collectionView collectionViewLayout];
//    flowLayout.headerReferenceSize=CGSizeMake(_collectionView.frame.size.width,50);
    UICollectionViewFlowLayout* flowLayout=(UICollectionViewFlowLayout*)[_collectionView collectionViewLayout];
    flowLayout.itemSize=CGSizeMake(120,_collectionView.frame.size.height-35);
    flowLayout.minimumLineSpacing=8;
    _videoImage.layer.cornerRadius=3;
    _videoImage.layer.borderColor=[UIColor whiteColor].CGColor;
    _videoImage.layer.borderWidth=2;
    _imageLoader=[[ImageLoader alloc] init];
    [_imageLoader loadImage:_videoImage andImgUrl:_forDataImgview.imgUrl];
    [_imageLoader loadImage:_blueImage andImgUrl:_forDataImgview.imgUrl];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    [_collectionView registerClass:[DetailCollectionViewCell class] forCellWithReuseIdentifier:@"indexCell"];

    [NaCrawl videoIndexCrawl:_forDataImgview.playUrl ndCallBack:^(NSMutableArray* resultArray){
        _indexArray=resultArray;
        [_collectionView reloadData];
    }];
    _indexArray=[[NSMutableArray alloc] init];


    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if([_indexArray count]>0)
        return 1;
    else return 0;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_indexArray count];
}
-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
  for(UIView* view in cell.subviews)
  {
      [view removeFromSuperview];
  }
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    UIButton* button=[[UIButton alloc] initWithFrame:cell.bounds];
    button.backgroundColor=[UIColor whiteColor];
    button.layer.borderWidth=0.6;
    button.layer.cornerRadius=8;
  
    if(_selected==indexPath.row)
    {
        button.layer.borderColor=[UIColor colorWithRed:231.0/255.0 green:71.0/255.0 blue:55.0/255.0 alpha:1].CGColor;
        [button setTitleColor:[UIColor colorWithRed:231.0/255.0 green:71.0/255.0 blue:55.0/255.0 alpha:1] forState:UIControlStateNormal];
    }
    else{
        button.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    button.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
    [button setTitle:_indexArray[indexPath.row] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(playVideo:)  forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];

}
-(void)closeDetailPanel:(UIGestureRecognizer*) recognizer{
    if(_isDeatilPanelOpen)
    {
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3f];
    CGFloat height=_detailCollectionview.frame.size.height;
    _detailCollectionview.transform = CGAffineTransformTranslate(_detailCollectionview.transform,0,height);
        [UIView commitAnimations];
    }
}
-(void)showDetail:(UITapGestureRecognizer*) recognizer{
    _isDeatilPanelOpen=YES;
    _collectionDelegate.isIntroduce=YES;
    [_detailCollectionview reloadData];
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3f];
    CGFloat height=_detailCollectionview.frame.size.height;
   _detailCollectionview.transform = CGAffineTransformTranslate(_detailCollectionview.transform,0,-height);
    [UIView commitAnimations];
}
-(void)showSelectDetail:(UITapGestureRecognizer*) recognizer{
     _isDeatilPanelOpen=YES;
    _collectionDelegate.isIntroduce=NO;
    [_detailCollectionview reloadData];
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3f];
    CGFloat height=_detailCollectionview.frame.size.height;
    _detailCollectionview.transform = CGAffineTransformTranslate(_detailCollectionview.transform,0,-height);
    [UIView commitAnimations];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell* cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"indexCell" forIndexPath:indexPath];

        return cell;
}

-(void)playVideo:(id)sender{
    
    UIButton* button=(UIButton*)sender;
    button.layer.borderColor=[UIColor colorWithRed:231.0/255.0 green:71.0/255.0 blue:55.0/255.0 alpha:1].CGColor;
    [button setTitleColor:[UIColor colorWithRed:231.0/255.0 green:71.0/255.0 blue:55.0/255.0 alpha:1] forState:UIControlStateNormal];
    NSIndexPath* indexPath=[_collectionView indexPathForCell:(UICollectionViewCell*)[button superview]];
    _selected=indexPath.row;
    [NaCrawl detailPageCrawl:[[NSString alloc] initWithFormat:@"%@&nns_video_index=%ld",_forDataImgview.playUrl,indexPath.row] andCallBack:^(NSString* playurl){
         NSURL* url=[NSURL URLWithString:[playurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [IJKVideoViewController presentFromViewController:self withTitle:[NSString stringWithFormat:@"URL: %@", @"http://172.16.146.81/124.mp4"] URL:url completion:^{
            //            [self.navigationController popViewControllerAnimated:NO];
        }];
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
