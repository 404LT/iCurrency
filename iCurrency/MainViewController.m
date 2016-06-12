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
#import "AppDelegate.h"
#import "HudView.h"

#define DEFAULTS_KEY_SOURCE_CURRENCY @"baseCurrency"

@interface MainViewController ()<AddCurrencyViewControllerDelegate,ConvertViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *baseCurrencyView;
@property(strong,nonatomic)CurrencyManager *cManager;
@property(strong,nonatomic)ConvertViewController *convertVC;
// HUDView
@property (strong, nonatomic) HudView *hudView;

@end

@implementation MainViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //单例
    _cManager = [CurrencyManager sharedInstance];
    
    //初始化
    [self initInputField];
    [self initAddSignToNavBar];
    [self initBarButtomItems];
    
    //初始化基准汇率
    [self initDefaultBaseCurrency];
   // [self initColors];
    
    //超时
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dataTimeOut) name:@"TimeOut" object:nil];
    
    NSLog(@"mvc-viewDidLoad");
}

#pragma mark - 一些需要初始化的方法
- (void)initColors
{
    self.view.backgroundColor = TOP_COLOR;
    self.sourceCurrencyView.backgroundColor = TOP_COLOR;
    self.navigationController.navigationBar.barTintColor = TOP_COLOR;
}


//添加按钮
- (void)initAddSignToNavBar
{
    //初始化添加国家按钮
    ConvertViewController *cvc = (ConvertViewController *)[self.childViewControllers lastObject];
    UIBarButtonItem *addBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:cvc action:@selector(addTargetCurrency)];
    self.navigationItem.rightBarButtonItem = addBar;
    
}

-(void)initBarButtomItems
{
    UIBarButtonItem *settingBar=[[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToSetting)];
    self.navigationItem.leftBarButtonItem=settingBar;
}

-(void)initInputField
{
    //点击输入框的时候清除输入框的初始内容
    self.sourceCurrencyInputField.clearsOnBeginEditing = YES;
}

#pragma mark - 页面转跳的方法
- (void)jumpToSetting
{
    NSLog(@"jumpToSetting is called");
    SettingViewController *settingVC = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

//实现委托的cancelled方法
- (void)cancelled
{
    NSLog(@"3-1关闭添加国家的view的方法实现");
}

#pragma mark - 析构函数
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
    //  方案1  监听输入框开始输入的方法
    NSLog(@"输入框开始输入textFieldDidBeginEditing: is called ");
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}


#pragma mark - 隐藏键盘
//最开始的方案的时候用这个
- (void)viewTapped:(UIGestureRecognizer *)gesture
{
    NSLog(@"viewTapped is called 关闭键盘");
    [self.view removeGestureRecognizer:gesture];
    [self.view endEditing:NO];
}

#pragma mark - 基准汇率计算过程
- (double)baseAmount
{
    NSMutableString *baseString = [NSMutableString stringWithFormat:self.sourceCurrencyInputField.text];
    return [baseString doubleValue];
}

- (IBAction)sourceChanged:(id)sender
{
    
    //    输入框一旦有变动就触发该事件
    ConvertViewController *cvc =(ConvertViewController *)[self.childViewControllers lastObject];
    cvc.baseAmount = [self baseAmount];
    [cvc.tableView reloadData];
    NSLog(@"输入了新的数字 %f",cvc.baseAmount);
}

#pragma mark -  初始化基准汇率---------关键操作
- (void)initDefaultBaseCurrency
{
    //从NSUserdefaults中取出之前存储在本地的base，然后调用设置的方法
    NSString *baseCurrency = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTS_KEY_SOURCE_CURRENCY];
    if (baseCurrency) {
        
        NSLog(@"self - from -initDefaults %@",self);
        [self setupBaseCurrency:baseCurrency];
    }
    else{
        [self setupBaseCurrency:@"USD"];
    }
    
    //在初始化默认汇率的同时，发送通知给convertvc 让它初始化那边的基准汇率
    [[NSNotificationCenter defaultCenter]postNotificationName:@"initBase" object:baseCurrency];
}

- (void)selectBaseCurrency:(NSString *)selectedBaseCurrencyName
{
    NSLog(@"self - from -selectBase (MAIN) %@",self);
    [self setupBaseCurrency:selectedBaseCurrencyName];
   // [self setupBaseCurrencyByConvertViewController:selectedBaseCurrencyName];
    
}

- (void)setupBaseCurrency:(NSString *)countryName
{
    //这个方法给本类和CVC类调用，本类只会在初始化的时候调用一次，CVC会经常调用
    //每次有值传过来 都固定在本地
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:countryName forKey:DEFAULTS_KEY_SOURCE_CURRENCY];
    [defaults synchronize];
    NSLog(@"更新操作后最新的Base是  %@",countryName);
    self.baseCurrency = countryName;
    CurrencyManager *manager = [CurrencyManager sharedInstance];
    NSInteger index = [manager.namesArray indexOfObject:countryName];
    NSString *flagname = manager.flagImage[index];
    NSString *unit = manager.currencyUnit[index];
    
    //配置控件信息
    self.sourceCurrencyName.text = countryName;
    self.sourceCurrencyFlag.image = [UIImage imageNamed:flagname];//国旗
    self.sourceCurrencyUnit.text =unit;//单位
    
    NSLog(@"控件属性配置 - self (MAIN)  :%@ %@ %@ %@",self,self.sourceCurrencyName.text,self.sourceCurrencyFlag.image,self.sourceCurrencyUnit.text);
}

//重写一个setupBaseCurrencyForConvertVC
- (void)setupBaseCurrencyByConvertViewController:(NSString *)countryName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:countryName forKey:DEFAULTS_KEY_SOURCE_CURRENCY];
    [defaults synchronize];
    NSLog(@"设置By CVC %@",countryName);
    self.baseCurrency = countryName;
    //配置控件的属性
    CurrencyManager *manager = [CurrencyManager sharedInstance];
    //单例。。。。。
    NSInteger index = [manager.namesArray indexOfObject:countryName];
    NSString *flagname = manager.flagImage[index];
    NSString *unit = manager.currencyUnit[index];
    //以上都没有问题
    
    self.sourceCurrencyName.text = countryName;
    self.sourceCurrencyFlag.image = [UIImage imageNamed:flagname];//国旗
    self.sourceCurrencyUnit.text =unit;//单位
    
    NSLog(@"控件属性配置 - self by CVC (MAIN)  :%@ %@ %@ %@",self,self.sourceCurrencyName.text,self.sourceCurrencyFlag.image,self.sourceCurrencyUnit.text);
}

- (void)dataTimeOut
{
    if (_hudView != nil) {
        [_hudView setHudViewImage:[UIImage imageNamed:@"cross"] text:@"连接超时"];
        [_hudView setNeedsDisplay];
        [_hudView dismissHudViewAfterDelay:0.7 completion:^{
            self.navigationController.view.userInteractionEnabled = YES;
            _hudView = nil;
        }];
    }
}


@end