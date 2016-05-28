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
#import "MCNumberKeyboard.h"

#define DEFAULTS_KEY_SOURCE_CURRENCY @"baseCurrency"

@interface MainViewController ()<MCNumberKeyboardDelegate,AddCurrencyViewControllerDelegate,ConvertViewControllerDelegate>
//遵守了自定义键盘的协议；添加汇率的协议；修改基础汇率的协议
@property (weak, nonatomic) IBOutlet UIView *baseCurrencyView;
@property(strong,nonatomic)CurrencyManager *cManager;
@property(strong,nonatomic)ConvertViewController *convertVC;
@end

@implementation MainViewController

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _cManager = [CurrencyManager sharedInstance];
    
    [self initInputField];
    [self initAddSignToNavBar];
    [self initBarButtomItems];
    [self initDefaultBaseCurrency];
    //设置自己是委托方的被委托者
   // [self initChangeBaseCurrencyDelegate];
    


}




#pragma mark - 一些需要初始化的方法
- (void)initCommunicationWithYahoo
{
    //在view没有加载出来之前完成网络部分的操作。
    YahooFinanceClient *yahooClient = [[YahooFinanceClient alloc]init];
    [yahooClient getParsedDictionaryFromResults];
    NSLog(@"成功从雅虎财经获取当前所有汇率");
    
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
    //    监听输入框开始输入的方法
    NSLog(@"输入框开始输入textFieldDidBeginEditing: is called ");
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    
//   方案2 自定义键盘
//    NSLog(@"调用自定义键盘");
//    MCNumberKeyboard *keyboardView=[[NSBundle mainBundle]loadNibNamed:@"MCNumberKeyboard" owner:nil options:nil][0];
//    keyboardView.delegate=self;
//    [keyboardView showInView:self.navigationController.view];
    
    
}

#pragma mark - 自定义键盘的委托

- (void)numberKeyboardWillShow:(MCNumberKeyboard *)numberKeyboard
{
    //配置一些约束
}

-(void)numberKeyboardDidShow:(MCNumberKeyboard *)numberKeyboard
{
    
}

-(void)numberKeyboardWillDismiss:(MCNumberKeyboard *)numberKeyboard
{
    
}
-(void)numberKeyboardDidDismiss:(MCNumberKeyboard *)numberKeyboard
{
    
}

-(void)numberKeyboardClickPointButton:(MCNumberKeyboard *)numberKeyboard
{
    
}
-(void)numberKeyboardClickOperationButton:(MCNumberKeyboard *)numberKeyboard
{
    
}
-(void)numberKeyboardClickNumberButton:(MCNumberKeyboard *)numberKeyboard
{
    //点击数字按钮后向各国家返回计算结果
    //    [self.sourceCurrencyInputField setCount]
}
-(void)numberKeyboardClickClearButton:(MCNumberKeyboard *)numberKeyboard
{
    //配置清空按钮的功能
    [self.sourceCurrencyInputField clearsOnBeginEditing];
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
    NSLog(@"基准汇率框的数字------sourceAmount");
    NSMutableString *baseString = [NSMutableString stringWithFormat:self.sourceCurrencyInputField.text];
    return [baseString doubleValue];
}

- (IBAction)sourceChanged:(id)sender {
    //    输入框一旦有变动就触发该事件
    NSLog(@"基准汇率改变了~sourceChanged");
    ConvertViewController *cvc =(ConvertViewController *)[self.childViewControllers lastObject];
    cvc.baseAmount = [self baseAmount];
    [cvc.tableView reloadData];
    NSLog(@"输入了新的数字 %f",cvc.baseAmount);
    
}

#pragma mark -  初始化基准汇率---------关键操作
- (void)initDefaultBaseCurrency
{
    
    //似乎在这里读出系统存储的默认设置的时候读取错了~~~~~
    NSString *baseCurrency = [[NSUserDefaults standardUserDefaults]objectForKey:DEFAULTS_KEY_SOURCE_CURRENCY];
    
    if (baseCurrency) {
        //关键操作：：：：：：：
      //  NSLog(@"取回默认");
        [self setupBaseCurrency:baseCurrency];
    }
    else{
        NSLog(@"自定义默认");
        [self setupBaseCurrency:@"USD"];
    }
    
    //在初始化默认汇率的同时，发送通知给convertvc 让它初始化那边的基准汇率
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"initBase" object:baseCurrency];
    
    
    
}

- (void)selectBaseCurrency:(NSString *)selectedBaseCurrencyName
{
//    NSLog(@"基准汇率更换成 ： %@",selectedBaseCurrencyName);
    [self setupBaseCurrency:selectedBaseCurrencyName];
    NSLog(@"2");
}

- (void)setupBaseCurrency:(NSString *)countryName
{
    //如何刷新基准汇率的view呢
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:countryName forKey:DEFAULTS_KEY_SOURCE_CURRENCY];
    [defaults synchronize];
    self.baseCurrency = countryName;
    
    CurrencyManager *manager = [CurrencyManager sharedInstance];
    NSInteger index = [manager.namesArray indexOfObject:countryName];
    NSString *flagname = manager.flagImage[index];
    NSString *unit = manager.currencyUnit[index];

    _sourceCurrencyName.text = countryName;
    _sourceCurrencyFlag.image = [UIImage imageNamed:flagname];//国旗
    _sourceCurrencyUnit.text =unit;//单位

    
   //发送当前基准汇率的通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"currenctBase" object:countryName];
//     NSLog(@"通过NSNotification 发送当前基准汇率名 %@ %@ %@",countryName,flagname,unit);
    
    NSLog(@"3");
    
    
    
}




#pragma mark - 添加汇率 
//- (void)selectedCurrency:(NSString *)selectedCurrencyCode
//{
//    NSLog(@"更换基准汇率");
//    //    根据countryCode来设置基准汇率，还是以USD为基础汇率。。
//    [self setupSourceCurrency:selectedCurrencyCode];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
@end