//
//  MainViewController.m
//  iCurrency
//
//  Created by 陆文韬 on 16/3/14.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import "MainViewController.h"
#import "AddCurrencyViewController.h"
#import "ExchangeRate.h"
#import "YahooFinanceClient.h"
#import "ConvertViewController.h"
#import "CurrencyManager.h"
#import "SettingViewController.h"

#define DEFAULTS_KEY_SOURCE_CURRENCY @"baseCurrency"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initDefaultBaseCurrency];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initInputField];
    [self initBarButtomItems];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchBaseCurrency:) name:@"switchBaseCurrency" object:nil];
    
//    [self someTest];
}



#pragma mark -  初始化基准汇率
- (NSString *)getCurrenctCountry
{
    //获取当前基准汇率国家
    NSString *str = self.baseCurrency;
    NSLog(@"这就有点 %@",str);
    return str;
}

-(void)switchBaseCurrency:(NSNotification*)notification{
    
    NSString *receivedBaseRate = notification.object;
    [self setupBaseCurrency:receivedBaseRate];
    self.baseCurrency = receivedBaseRate;
    
}

- (void)initDefaultBaseCurrency
{
//    初始化基准汇率国家
    NSString *baseCurrency = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTS_KEY_SOURCE_CURRENCY];
    if (baseCurrency) {
        [self setupBaseCurrency:baseCurrency];
    }
    else{
        [self setupBaseCurrency:@"USD"];
    }
    //初始化为USD
//    [self setupBaseCurrency:@"USD"];
}

- (void)setupBaseCurrency:(NSString *)countryName
{
    NSLog(@"设定基准汇率");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:countryName forKey:DEFAULTS_KEY_SOURCE_CURRENCY];
    [defaults synchronize];
    
    self.baseCurrency = countryName;
    
    CurrencyManager *manager = [CurrencyManager default];
    self.sourceCurrencyFlag.image = [manager imageForCountriesFlag:self.baseCurrency];//国旗
    self.sourceCurrencyName.text = [manager nameForCurrency:self.baseCurrency];//名称
    self.sourceCurrencyUnit.text = [manager unitForCurrency:self.baseCurrency];//单位
    
    
}

#pragma mark - 一些需要初始化的方法
- (void)initCommunicationWithYahoo
{
    //在view没有加载出来之前完成网络部分的操作。
    YahooFinanceClient *yahooClient = [[YahooFinanceClient alloc]init];
    [yahooClient getParsedDictionaryFromResults];
    NSLog(@"成功从雅虎财经获取当前所有汇率");
    
}



-(void)initBarButtomItems
{
    //初始化主界面导航栏的按钮
    UIBarButtonItem *settingBar=[[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToSetting)];
    self.navigationItem.leftBarButtonItem=settingBar;
//    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(jumpToAdd)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

-(void)initInputField
{
    //点击输入框的时候清除输入框的初始内容
    self.sourceCurrencyInputField.clearsOnBeginEditing = YES;
}

#pragma mark - 测试一些小的模块~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)someTest
{
    //
}

////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - 页面转跳的方法
- (void)jumpToAdd
{
    NSLog(@"jumpToAdd is called");
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddCurrencyViewController *addVC = (AddCurrencyViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"AddCurrencyView"];
    [self presentViewController:addVC animated:YES completion:nil];
}

- (void)jumpToSetting
{
    NSLog(@"jumpToSetting is called");
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - 一些琐碎的方法
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 输入框代理UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    监听输入框开始输入的方法
    NSLog(@"输入框开始输入textFieldDidBeginEditing: is called ");
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - 隐藏键盘
- (void)viewTapped:(UIGestureRecognizer *)gesture
{
    NSLog(@"viewTapped is called 关闭键盘");
    [self.view removeGestureRecognizer:gesture];
    [self.view endEditing:NO];
}

#pragma mark - 基准汇率相关设置
- (double)baseAmount
{
    NSLog(@"基准汇率框的数字------sourceAmount");
    NSMutableString *baseString = [NSMutableString stringWithFormat:self.sourceCurrencyInputField.text];
    return [baseString doubleValue];
}

//- (NSString *)baseCurrency
//{
//   
//    NSMutableString *baseStr = [NSMutableString stringWithFormat:self.sourceCurrencyName.text];
//     NSLog(@"此刻基准汇率国家是:%@",baseStr);
//    return baseStr;
//}

- (IBAction)sourceChanged:(id)sender {
    //    输入框一旦有变动就触发该事件
    NSLog(@"基准汇率改变了~sourceChanged");
    ConvertViewController *cvc =(ConvertViewController *)[self.childViewControllers lastObject];
    cvc.baseAmount = [self baseAmount];
    [cvc.tableView reloadData];
    NSLog(@"输入了新的数字 %f",cvc.baseAmount);

}


@end
