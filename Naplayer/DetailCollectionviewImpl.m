//
//  DetailCollectionviewImpl.m
//  Naplayer
//
//  Created by Modona on 2017/3/28.
//  Copyright © 2017年 Modona. All rights reserved.
//

#import "DetailCollectionviewImpl.h"

@implementation DetailCollectionviewImpl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithView:(UICollectionView *)collection{
    self=[super init];
    _collectionview=collection;
    return self;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
  
    UICollectionReusableView* headerView;
    if(collectionView.tag==66)
    {
        if(kind==UICollectionElementKindSectionHeader)
        {
            UICollectionReusableView* headerView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
            UIButton* button=[headerView viewWithTag:77];
            [button addTarget:self action:@selector(closeDetai:) forControlEvents:UIControlEventTouchUpInside];
            UILabel* label=[headerView viewWithTag:61];
            if(_isIntroduce)label.text=@"简介";
            else label.text=@"选集";
            return headerView;
            
        }
    }
    return headerView;
}
-(void)closeDetai:(id)sender{
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3f];
    CGFloat height=_collectionview.frame.size.height;
    _collectionview.transform = CGAffineTransformTranslate(_collectionview.transform,0,height);
    [UIView commitAnimations];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"indexCell" forIndexPath:indexPath];

    return cell;
}
@end
