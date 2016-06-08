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
#import "AppDelegate.h"
#define DEFAULTS_KEY_TARGET_CURRENCIES @"currencyDisplay"
#define DEFAULTS_KEY_SOURCE_CURRENCY @"baseCurrency"
@interface ConvertViewController ()<AddCurrencyViewControllerDelegate>
//@property (strong,nonatomic)UITextField *firstResponder;
@property (assign,nonatomic)BOOL keyBoardShown;

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) NSMutableArray *currencyDisplay;//用于存放展示在主界面的自选国家名称
@property(strong,nonatomic)CurrencyManager *cManager;//实例对象
@property(strong,nonatomic)MainViewController *mainvc;
@property(strong,nonatomic)NSString *baseCurrencyName;
@property(strong,nonatomic)ExchangeRate *rates;

@end

@implementation ConvertViewController
{
    NSMutableArray *currencyUnit;//用于存储货币单位
}

#pragma mark - 界面生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化从雅虎获取汇率的方法
    [self initFetchDataFromYahoo];
    
    _cManager = [CurrencyManager sharedInstance];
    _currencyDisplay = [NSMutableArray arrayWithArray:_cManager.defaultsCountries];
    
    [self initTableViewSetting];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initBaseFromMvc:) name:@"initBase" object:nil];

    
    //self.tableView.backgroundColor = BASIC_COLOR;
    
 
}

#pragma mark - 接收用于传递 当前基准汇率国家的通知
- (void)initBaseFromMvc:(NSNotification *)notification
{
    //初始化 cvc 中的baseCurrencyName
    NSString *initBaseName = notification.object;
    _baseCurrencyName = initBaseName;
   // NSLog(@"AAA");
}



#pragma mark - 一些初始化的方法
- (void)initFetchDataFromYahoo
{
    YahooFinanceClient *yahoo = [[YahooFinanceClient alloc]init];
    [yahoo getParsedDictionaryFromResults];
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
   
    
}

- (void)setBaseCurrency:(NSString *)baseCurrency
{
//    ！！！！！！
    self.baseCurrency = baseCurrency;
}

#pragma mark - 表格数据源--Data Source Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currencyDisplay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //method2 获取本地的base
    NSString *currentBaseRate = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTS_KEY_SOURCE_CURRENCY];
    
    static NSString *reuseIdentifier = @"convertCell";
    ConvertCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[ConvertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
   
    NSString *name = _currencyDisplay[indexPath.row];
    NSInteger index = [_cManager.namesArray indexOfObject:name];
    NSString *flagName = _cManager.flagImage[index];
    
   // cell.backgroundColor = BASIC_COLOR;
    cell.countryImage.image = [UIImage imageNamed:flagName];
    cell.countryName.text = name;
    cell.currencyUnit.text = _cManager.currencyUnit[index];
    //转换汇率操作
    ExchangeRate *exchange = [[ExchangeRate alloc]init];
    double baseAmount = [self baseAmount];
    
    
    //method1
    //    MainViewController *mvc = [[MainViewController alloc]init];
    //    [mvc initDefaultBaseCurrency];
    //    id currentBaseRate = mvc.baseCurrency;
    

    double targetAmount =[exchange convertRate:currentBaseRate to:[_currencyDisplay objectAtIndex:indexPath.row] with:baseAmount];
    cell.targetCurrency.text =[NSString stringWithFormat:@"%f",targetAmount];
    
    return cell;
}

#pragma mark - 选择该row即切换成基准利率

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //旧的汇率已经同步，现在解决baseView
    NSString *exBase = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTS_KEY_SOURCE_CURRENCY];

    //注册代理
    [self registDelegate];
    //选中的国家：
    NSString *baseCurrencyName = [self.currencyDisplay objectAtIndex:indexPath.row];
    NSLog(@"选中的国家 %@",baseCurrencyName);
    
    //判断响应的方法selectBaseCurrency有没有实现
    
    if ([_delegate respondsToSelector:@selector(selectBaseCurrency:)]) {
        NSLog(@"self - from disSelect (CONVERT) %@",self);
        [_delegate selectBaseCurrency:baseCurrencyName];
        //NSLog(@"第一部分已完成");
    }
    //重写一个方法用来响应Main那边那个setupBaseCurrencyByConvertViewController:
    
    
    
    
    
    
    
    [_currencyDisplay replaceObjectAtIndex:indexPath.row withObject:exBase];
    [self.tableView reloadData];
    
    
}









- (void)getBaseName:(NSNotification *)notification{
    NSString *baseName = notification.object;
    _baseCurrencyName = baseName;
    NSLog(@"getbase接受来自通知中的 基准汇率: %@",_baseCurrencyName);
    NSLog(@"5");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


- (void)registDelegate
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MainViewController *mvc = (MainViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"mainStoryboard"];
    [self setDelegate:mvc];
}


#pragma mark - 编辑模式下的样式设置
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //通过模型层实例的对象 调用一个方法删除掉模型层displayCurrency里面的当前选中数据
        NSString *name = _currencyDisplay[indexPath.row];
        [_cManager removeDisplayCurrencyName:name];
        _currencyDisplay = _cManager.defaultsCountries;
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        NSLog(@"添加模式");
        // 添加一条数据
        [_currencyDisplay insertObject:[NSString stringWithFormat:@"%@", @"增加的Cell"] atIndex:indexPath.row + 1];
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
    NSString *fromObj = [_currencyDisplay objectAtIndex:sourceIndexPath.row];
    [_currencyDisplay insertObject:fromObj atIndex:destinationIndexPath.row];
    [_currencyDisplay removeObjectAtIndex:sourceIndexPath.row];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AddCurrencyViewController *avc = (AddCurrencyViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"AddCurrencyView"];
    
    avc.delegate = self;

    
    [self presentViewController:avc animated:YES completion:nil];
    
}

- (void)selectedCurrency:(NSString *)selectedCurrencyCode
{
    //调用模型层的方法使得模型层的displayArray 添加当前选中的国家
    NSLog(@"选中的国家是 %@",selectedCurrencyCode);
    
    [_cManager addDisplayCurrencyName:selectedCurrencyCode];
    [_currencyDisplay addObject:selectedCurrencyCode];
    

    [self.tableView reloadData];
    
    NSLog(@"此时defaultsCountries为 is %@ currencyDisplay is %@",_cManager.defaultsCountries,_currencyDisplay);

    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)persistTargetCurrencies
{
    NSLog(@"3 保存自选国家");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.currencyDisplay forKey:DEFAULTS_KEY_TARGET_CURRENCIES];
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
