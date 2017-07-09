//
//  DetailCollectionviewImpl.h
//  Naplayer
//
//  Created by Modona on 2017/3/28.
//  Copyright © 2017年 Modona. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCollectionviewImpl : UIView<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) NSMutableArray* indexArray;
@property(nonatomic,strong) NSString* introduceText;
@property(nonatomic) BOOL isIntroduce;//or not for select video
@property(nonatomic,weak) UICollectionView* collectionview;
-(instancetype)initWithView:(UICollectionView*)collection;
@end
