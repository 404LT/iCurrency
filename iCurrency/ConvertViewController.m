//
//  ConvertViewController.m
//  iCurrency
//
//  Created by 陆文韬 on 16/2/25.
//  Copyright © 2016年 LunTao. All rights reserved.
//
#import "ConvertViewController.h"
#import "ConvertCell.h"
#import "ExchangeRate.h"
#import "YahooFinanceClient.h"
#import "MainViewController.h"
#import "CurrencyManager.h"
#import "TrendViewController.h"
@interface ConvertViewController ()
@property (strong,nonatomic)UITextField *firstResponder;
@property (assign,nonatomic)BOOL keyBoardShown;
@property (strong,nonatomic)YahooFinanceClient *info;//用于传输抓取的信息
@property (strong,nonatomic) NSMutableArray   * currencyDisplay;

//@property (weak,nonatomic)UITextField *inputNumField;

@end

@implementation ConvertViewController
{
    NSMutableArray *nameitems;//用于存储国家名称
    NSMutableArray *currencyUnit;//用于存储货币单位
    NSArray *images;//用于存储图片
    NSMutableArray *nowCurrency;
    NSNumber *staticCurrency;//用于存储当前汇率，这个NSMutableString是用于测试动态更新cell内容的，一个静态值
}

#pragma mark - 界面生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCuurenciesInfo];
    [self initTableViewSetting];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark - 一些初始化的方法
- (void)initCuurenciesInfo
{
    //初始化汇率的数据
    //目前来说还是静态设定的
    //    以下数据均经网络由雅虎财经获取
    //    有可能需要把每个国家的信息用字典来装载
    //    提取出resultsDic里面所有的键
    //把nameitems数组用作默认在主界面显示的几个汇率国家
    
    NSLog(@"初始化nameitems---");
    nameitems = [@"CNY JPY EUR HKD" componentsSeparatedByString:@" "];
    
}

- (void)initTableViewSetting
{
    //主要负责表格一些细节设置的初始化
    self.tableView.allowsSelection = YES;
}

#pragma mark - 设置基准汇率

- (void)setBaseAmount:(double)baseAmount
{
    _baseAmount = baseAmount;
    [self.tableView reloadData];
    NSLog(@"设置基准汇率");
    
}

- (void)setBaseCurrency:(NSString *)baseCurrency
{
    self.baseCurrency = baseCurrency;
}

#pragma mark - 表格数据源--Data Source Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRowAtIndexPath---------方法start");
    static NSString *reuseIdentifier = @"convertCell";
    ConvertCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ConvertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    
    CurrencyManager *manager = [[CurrencyManager alloc]init];
    ExchangeRate *exchange = [[ExchangeRate alloc]init];
    
    NSString *targetCountryName =[nameitems objectAtIndex:indexPath.row];
    
    cell.countryName.text = [manager nameForCurrency:targetCountryName];
    cell.countryImage.image = [manager imageForCountriesFlag:targetCountryName];
    cell.currencyUnit.text = [manager unitForCurrency:targetCountryName];

    double baseAmount = [self baseAmount];
    
    MainViewController *mvc = [[MainViewController alloc]init];
    [mvc initDefaultBaseCurrency];
   
    id currentBaseRate = mvc.baseCurrency;
    
    double targetAmount =[exchange convertRate:currentBaseRate to:[nameitems objectAtIndex:indexPath.row] with:baseAmount];
    
    cell.targetCurrency.text =[NSString stringWithFormat:@"%f",targetAmount];
    NSLog(@"基准汇率输入值现在是：%f",baseAmount);
//    NSLog(@"---------cell---------方法end");
    
    return cell;
}



#pragma mark - 选中该row即切换成基准利率

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当选中当前的row时候，自动将其切换成基准汇率
//    NSString *willBeBaseCurrency = [self->nameitems objectAtIndex:indexPath.row];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"switchBaseCurrency" object:[self->nameitems objectAtIndex:indexPath.row]];
    
    
    
    MainViewController *mvc = [[MainViewController alloc]init];
//    [mvc initDefaultBaseCurrency];
   
    
    //替换成当前主VC的基准汇率
    //获取当前主vc的基准汇率
//    [self->nameitems replaceObjectAtIndex:indexPath.row withObject:[mvc getCurrenctCountry]];

    NSLog(@"卧槽：%@",mvc.baseCurrency);
    [self.tableView reloadData];

}





#pragma mark - 编辑模式下的样式设置
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除");
        [nameitems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        NSLog(@"添加模式");
        // 添加一条数据
        [nameitems insertObject:[NSString stringWithFormat:@"%@", @"增加的Cell"] atIndex:indexPath.row + 1];
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
        // 注意点:数组中插入的条数必须和tableview界面上插入的cell条一致
        // 否则程序会报错
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationBottom];

    }
    
}
#pragma mark - 表格一些其它的设置
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    表格的区段数
    NSLog(@"1个区段");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    该区段的行数
    
    NSLog(@"此时一共加载了%lu个国家",nameitems.count);
    return nameitems.count;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //移动行
    NSLog(@"进入移动行模式");
    NSString *fromObj = [nameitems objectAtIndex:sourceIndexPath.row];
    [nameitems insertObject:fromObj atIndex:destinationIndexPath.row];
    [nameitems removeObjectAtIndex:sourceIndexPath.row];
}

// 用于告诉系统开启的编辑模式是什么模式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //编辑模式用于删除cell
    return UITableViewCellEditingStyleDelete;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //表格高度
//    NSLog(@"行高是80");
    return 80.f;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    本函数用于修改 删除按钮显示的信息
    return @"删除";
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
//    判断是否可以移动行
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"可以编辑行");
    return YES;
}
- (void)didReceiveMemoryWarning {
    //接收内存警告
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 转跳到历史趋势页面
- (IBAction)segueToTrend:(id)sender {
    
    NSLog(@"走势被点击了");
//    TrendViewController *trendVC = [[TrendViewController alloc]init];
//    [self.navigationController pushViewController:trendVC animated:YES];

    UIStoryboard *trendStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TrendViewController *trendVC = (TrendViewController *)[trendStoryboard instantiateViewControllerWithIdentifier:@"Trend"];
    [self presentViewController:trendVC animated:YES completion:nil];
    
}




@end
