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
#import "CurrencyManager.h"
@interface AddCurrencyViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UITableView *addCurrencyTableView;

@end

@implementation AddCurrencyViewController
{
    NSMutableArray *nameitems;//用于存储国家名称
    NSArray *images;//用于存储国旗图片
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationItems];
    [self initSearchBar];
}

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


//- (void)backToMain{
//    MainViewController *mainVC = [[MainViewController alloc]init];
////    [self.navigationController pushViewController:mainVC animated:YES];
//    mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//    mainVC.modalTransitionStyle = UIModalTransitionStylePartialCurl;
//   
//
//}
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"AddCurrencyCell";
    AddCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier ];
    
    if (cell == nil) {
        cell = [[AddCurrencyCell alloc] init];
    }
    
    CurrencyManager *manager = [[CurrencyManager alloc]init];
    
//    cell.countryImage.image = [manager imageForCountriesFlag:coutryName.text];
    
    
//    
//    cell.backgroundColor = [UIColor lightGrayColor];
//    cell.countryName.text =[nameitems objectAtIndex:indexPath.row];
//    cell.countryImage.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    return cell;
}

#pragma ---------------------------------UISearcherBar Delegate------------------

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
