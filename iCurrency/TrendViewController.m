//
//  TrendViewController.m
//  iCurrency
//
//  Created by 陆文韬 on 16/4/26.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import "TrendViewController.h"

@interface TrendViewController ()

@end

@implementation TrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavigationBars];


}

- (void)initNavigationBars
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backToMain)];
    
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)backToMain
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToMain:(id)sender {
    NSLog(@"cancelPressed is called");
    if ([self respondsToSelector:@selector(cancelled)]) {
        [self cancelled];
    }
}

- (void)cancelled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
