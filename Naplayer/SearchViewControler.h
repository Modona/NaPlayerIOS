//
//  SearchControlerViewController.h
//  Naplayer
//
//  Created by Modona on 2017/3/20.
//  Copyright © 2017年 Modona. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "NaCrawl.h"
#include "ImageLoader.h"
#include "MyTableViewCell.h"
#include "VideoDetailControlerViewController.h"
#include "PlayItem.h"
@interface SearchViewControler : UIViewController<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,UISearchDisplayDelegate>
@property(nonatomic,retain) UISearchBar* searchBar;

@property(nonatomic,retain) UISearchDisplayController* searchControler;
@end
