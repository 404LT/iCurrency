//
//  MainViewController.m
//  iCurrency
//
//  Created by 陆文韬 on 16/3/14.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import "MainViewController.h"
#import "SettingViewController.h"
#import "AddCurrencyViewController.h"
#import "ConvertViewController.h"
@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *sourceCurrencyFlag;
@property (weak, nonatomic) IBOutlet UILabel *sourceCurrencyName;
@property (weak, nonatomic) IBOutlet UILabel *sourceCurrencyUnit;
@property (weak, nonatomic) IBOutlet UITextField *sourceCurrencyInputField;
@property (weak, nonatomic) IBOutlet UIView *sourceCurrencyView;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateTime;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sourceCurrencyFlag.image = [UIImage imageNamed:@"usa"];
    self.sourceCurrencyUnit.text = @"美元";
//    [self.navigationItem setTitle:@"主页"];
    
    //设置导航条的左右按钮
    //先实例化创建一个UIBarButtonItem，然后把这个按钮赋值给self.navigationItem.leftBarButtonItem即可
    //初始化文字的按钮类型有UIBarButtonItemStylePlain和UIBarButtonItemStyleDone两种类型，区别貌似不大
    UIBarButtonItem *settingBar=[[UIBarButtonItem alloc]initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToSetting)];
    self.navigationItem.leftBarButtonItem=settingBar;
    
//    UIBarButtonItem *addBar = [[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(jumpToAdd)];
//    self.navigationItem.rightBarButtonItem = addBar;
    
     UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    AddCurrencyViewController *addVC = (AddCurrencyViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"AddCurrencyView"];
    
    
  
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(jumpToAdd)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
}

- (void)jumpToAdd
{
    NSLog(@"jumpToAdd is called");
    //    AddCurrencyViewController *addVC = [[AddCurrencyViewController alloc]init];
    //    [self.navigationController pushViewController:addVC animated:YES];
    
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
