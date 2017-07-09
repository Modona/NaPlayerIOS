//
//  SearchControlerViewController.m
//  Naplayer
//
//  Created by Modona on 2017/3/20.
//  Copyright © 2017年 Modona. All rights reserved.
//

#import "SearchViewControler.h"
static NSString *cellName =@"cellName";
@interface SearchViewControler ()
@property(nonatomic,retain) NSMutableArray* dataArray;
@property(nonatomic) ImageLoader* imageLoader;
@end

@implementation SearchViewControler

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageLoader=[[ImageLoader alloc] init];
    CGRect statusBarFrame=[[UIApplication sharedApplication] statusBarFrame];
    UIView* statusCover=[[UIView alloc] initWithFrame:statusBarFrame];
    statusCover.backgroundColor=[UIColor colorWithRed:52.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1];
    
    _searchBar=[[UISearchBar alloc] initWithFrame:CGRectMake(0, statusBarFrame.size.height, [UIScreen mainScreen].bounds.size.width, 50)];
    _searchBar.backgroundColor=[UIColor colorWithRed:52.0/255.0 green:73.0/255.0 blue:94.0/255.0 alpha:1];
    _searchBar.placeholder=@"搜索影视";
    _searchBar.delegate=self;
    [_searchBar sizeToFit];
    _dataArray=[[NSMutableArray alloc] init];
    _searchControler=[[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _searchControler.searchResultsDelegate=self;
    _searchControler.delegate=self;
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [_searchControler.searchResultsTableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:cellName];
    [_searchControler.searchResultsTableView setTableFooterView:v];
    [_searchControler.searchResultsTableView setSeparatorInset:UIEdgeInsetsMake(0, 8, 0, 8)];

    _searchControler.searchResultsDataSource=self;
    [self.view addSubview:statusCover];
    [self.view addSubview:_searchBar];
    // Do any additional setup after loading the view.
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    

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
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [(UIImageView*)[cell viewWithTag:21] setImage:[UIImage imageNamed:@"test.JPG"]];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    __weak typeof(self) weakSelf=self;
    PlayItem* playItem=(PlayItem*)weakSelf.dataArray[indexPath.row];
    UITableViewCell *cell = [_searchControler.searchResultsTableView dequeueReusableCellWithIdentifier:cellName forIndexPath:indexPath];
    NSLog(@"row:%ld",indexPath.row);
    NSLog(@"%@",playItem.imgurl);
    UIImageView* imageView=[cell viewWithTag:21];
    [[weakSelf imageLoader] loadImage:imageView andImgUrl:playItem.imgurl];
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
       
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyImageView* imageview=[[MyImageView alloc] init];
    PlayItem* item=(PlayItem*)_dataArray[indexPath.row];
    imageview.playUrl=[NaCrawl urlDecode:item.playurl];
    imageview.imgUrl=item.imgurl;
    NSLog(@"MyimageView:%@",imageview.playUrl);
    [VideoDetailControlerViewController preLoadVideoDetail:self andImageView:imageview];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    __weak typeof(self) weakSelf=self;

    
    [NaCrawl searchPageCrawl:[[NSString alloc] initWithFormat:@"http://navod.scse.com.cn/nn_cms/data/template/100000/200003/index_v3_001.php?nns_template_type=100000&nns_template_id=200003&nns_tag=31&nns_page_name=search&nns_search=%@&nns_category_id=1000&nns_media_asset_id=movies|TVseries|variety|animation|softmovies|schoolmv|KoreaJapan&nns_search_type=2&nns_search_method=2&nns_include_category=1",searchBar.text] andCallBack:^(NSMutableArray* resultArray){
        weakSelf.dataArray=resultArray;
      
        
        
        [weakSelf.searchControler.searchResultsTableView reloadData];
    }];
    
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
