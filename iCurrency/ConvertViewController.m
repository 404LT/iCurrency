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
#import "AddCurrencyViewController.h"
#define DEFAULTS_KEY_TARGET_CURRENCIES @"currencyDisplay"

@interface ConvertViewController ()<AddCurrencyViewControllerDelegate>
@property (strong,nonatomic)UITextField *firstResponder;
@property (assign,nonatomic)BOOL keyBoardShown;
@property (strong,nonatomic)YahooFinanceClient *info;//用于传输抓取的信息
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *currencyDisplay;
@property(strong,nonatomic)CurrencyManager *cManager;//实例对象

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
    
    _cManager = [CurrencyManager sharedInstance];
    _currencyDisplay = [[NSMutableArray alloc]initWithArray:_cManager.defaultsCountries copyItems:NO];
    
    NSLog(@"此时currencyDisplay的值来源于cManager中的defaultsCountries %@",_currencyDisplay);
   
    [self initCuurenciesInfo];
    [self initTableViewSetting];
    
    self.tableView.tableFooterView = [[UIView alloc]init];
}
#pragma mark - 一些初始化的方法
- (void)initCuurenciesInfo
{
    /*
     将模型层的namesArray 传过来赋值给 namesitems
     */
    NSLog(@"初始化nameitems---");

    nameitems = _cManager.namesArray;
    
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //这里要是返回值为0的话 就不可能有任何内容出现在tableview中
    NSLog(@"此时一共加载了%lu个国家",_cManager.defaultsCountries.count);
    return _cManager.defaultsCountries.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CellForRow is called");
    
    //显示自选的国家的信息
    //cell的基本配置
    static NSString *reuseIdentifier = @"convertCell";
    ConvertCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ConvertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
   

    NSString *name = _currencyDisplay[indexPath.row];
    NSLog(@"在上面这一行爆炸的 %@ ",name);
    
    
    
    NSInteger index = [_cManager.namesArray indexOfObject:name];
    NSString *flagName = _cManager.flagImage[index];
    
    cell.countryImage.image = [UIImage imageNamed:flagName];
    cell.countryName.text = name;
    cell.currencyUnit.text = _cManager.currencyUnit[index];
    
    NSLog(@"此时的国家是 %@",name);
    
    
    //转换汇率操作
    ExchangeRate *exchange = [[ExchangeRate alloc]init];
    double baseAmount = [self baseAmount];
    MainViewController *mvc = [[MainViewController alloc]init];
    [mvc initDefaultBaseCurrency];
    id currentBaseRate = mvc.baseCurrency;
    double targetAmount =[exchange convertRate:currentBaseRate to:[_currencyDisplay objectAtIndex:indexPath.row] with:baseAmount];
    cell.targetCurrency.text =[NSString stringWithFormat:@"%f",targetAmount];

    
    return cell;
}

#pragma mark - 选中该row即切换成基准利率

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当选中当前的row时候，自动将其切换成基准汇率
//    NSString *willBeBaseCurrency = [self->nameitems objectAtIndex:indexPath.row];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"switchBaseCurrency" object:[self->nameitems objectAtIndex:indexPath.row]];
    
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
    return 1;
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
    return 80.f;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{

    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return YES;
}
- (void)didReceiveMemoryWarning {

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
#pragma mark - 添加国家的相关方法
- (void)addTargetCurrency
{
    NSMutableArray *currencies = [[NSMutableArray alloc]init];
    [currencies addObjectsFromArray:[[CurrencyManager sharedInstance] allCurrencyCodes]];
    
//    [currencies removeObjectsInArray:self.targetCurrencies];
//    [currencies removeObject:self.sourceCurrency];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AddCurrencyViewController *avc = (AddCurrencyViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"AddCurrencyView"];
    
    avc.delegate = self;
    avc.currencies = currencies;
     NSLog(@"cvc注册成avc的代理");
    
    [self presentViewController:avc animated:YES completion:nil];
    
}

- (void)selectedCurrency:(NSString *)selectedCurrencyCode
{
    //调用模型层的方法使得模型层的displayArray 添加当前选中的国家
    NSLog(@"选中的国家是 %@",selectedCurrencyCode);
    [_cManager addDisplayCurrencyName:selectedCurrencyCode];
    //然后刷新
    [self.tableView reloadData];
    
//    NSLog(@"select tableview is %@",self.tableView);
    
    [_currencyDisplay addObject:selectedCurrencyCode];
    
    NSLog(@"此时默认国家为 is %@",_cManager.defaultsCountries);
    NSLog(@"此时默认国家为 is %@",_currencyDisplay);
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)persistTargetCurrencies
{
    NSLog(@"3 固定在主界面");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_cManager.defaultsCountries forKey:DEFAULTS_KEY_TARGET_CURRENCIES];
    [defaults synchronize];
    
}

#pragma mark - delegate --------
- (void)cancelled
{
    NSLog(@"3-2关闭添加国家的view的方法实现");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 添加国家



@end
