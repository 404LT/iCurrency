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
    NSLog(@"trend dismiss");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
