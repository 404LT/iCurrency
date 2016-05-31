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
#import "ConvertViewController.h"
@interface AddCurrencyViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;//搜索栏
@property (retain, nonatomic) IBOutlet UITableView *addCurrencyTableView;//表格

@property(strong,nonatomic)CurrencyManager *cManager;//模型层实例的对象

@end

@implementation AddCurrencyViewController
{
   
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

#pragma mark - delegate_返回主界面的方法
- (IBAction)finishedPressed:(id)sender {

    if ([self.delegate respondsToSelector:@selector(cancelled)]) {
        [self.delegate cancelled];
    }

}


#pragma mark - 表格数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
#pragma mark - 表格主要的方法！！！！！！！选中行动作的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//把选中的国家添加到 displayArray数组中去
    NSString *countryName = _cManager.namesArray[indexPath.row];
    [_cManager addDisplayCurrencyName:countryName];

    NSString *currencyCode = [_cManager.namesArray objectAtIndex:indexPath.row];

    
    if ([self.delegate respondsToSelector:@selector(selectedCurrency:)]) {
        [self.delegate selectedCurrency:currencyCode];
        
    }
    
    
}

#pragma mark - 表格次要的方法
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



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
//    if ([self.searchBar isFirstResponder]) {
////        NSString *searchString =
//    }
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
