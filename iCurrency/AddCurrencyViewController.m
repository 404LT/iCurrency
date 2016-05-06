//
//  AddCurrencyViewController.m
//  iCurrency
//
//  Created by 陆文韬 on 16/3/8.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import "AddCurrencyViewController.h"
#import "MainViewController.h"
#import "AddCurrencyCell.h"
#import "SettingViewController.h"
#import "CurrencyManager.h"

@interface AddCurrencyViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;//搜索栏
@property (retain, nonatomic) IBOutlet UITableView *addCurrencyTableView;//表格

@property(strong,nonatomic)CurrencyManager *cManager;

@end

@implementation AddCurrencyViewController
{
    NSMutableArray *nameitems;//用于存储国家名称
    NSArray *images;//用于存储国旗图片
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //CurrencyManager单例
    _cManager = [CurrencyManager sharedInstance];
    
    [self initNavigationItems];
    [self initSearchBar];
}

#pragma mark - 初始化方法
- (void)initNavigationItems
{
    //初始化导航栏按钮
    [self.navigationItem setTitle:@"添加货币"];
}

- (void)initSearchBar
{
    //初始化搜索栏
    //将tableview表头设置为搜索栏
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
}

#pragma mark - 返回主界面的方法
- (IBAction)finishedPressed:(id)sender {
    
    NSLog(@"cancelPressed is called");
    if ([self respondsToSelector:@selector(cancelled)]) {
        [self cancelled];
    }
    
}
- (void)cancelled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"number of row");
    return _cManager.namesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *reuseIdentifier = @"AddCurrencyCell";
    AddCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[AddCurrencyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    NSString *names = _cManager.namesArray[indexPath.row];
    NSString *flags = _cManager.flagImage[indexPath.row];

    cell.countryImage.image = [UIImage imageNamed:flags];
    cell.countryName.text = names;

    return cell;
}
#pragma mark - 表格主要的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - 表格次要的方法
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60;
//}




#pragma ------------UISearcherBar Delegate---------

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self refreshTableView];
}

- (void)refreshTableView
{
    if ([self.searchBar isFirstResponder]) {
//        NSString *searchString =
    }
}







//在搜索框内搜索内容，并展示搜索结果
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    //移除mArr2中所有元素，来存放搜索结果
//    [self.mArr2removeAllObjects];
//    //对数组mArr1遍历，看数组中是否包含搜索框里的内容
//    for(NSString *pstrin self.mArr1)
//    {
//        //如果包含搜索框里的内容，就把数组中的元素添加到mArr2中
//        if([pstr hasPrefix:searchBar.text])
//        {
//            [self.mArr2addObject:pstr];
//        }
//    }
//    
//    [self.mSearcherBarresignFirstResponder];
//    //展示搜索结果
//    [self.mTableViewreloadData];
//    
//}


@end
