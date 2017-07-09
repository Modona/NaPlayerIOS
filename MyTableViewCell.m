//
//  MyTableViewCell.m
//  Naplayer
//
//  Created by Modona on 2017/3/22.
//  Copyright © 2017年 Modona. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
        UIImageView* imageView=[[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 150,95)];
        imageView.tag=21;
        imageView.layer.borderWidth=0.6;
        imageView.clipsToBounds=YES;
        imageView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        imageView.layer.cornerRadius=6;
        imageView.contentMode=UIViewContentModeScaleAspectFill;
        
        [self addSubview:imageView];
    NSLog(@"init");
    return self;
}

@end
