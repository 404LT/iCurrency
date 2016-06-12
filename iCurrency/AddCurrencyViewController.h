//
//  AddCurrencyViewController.h
//  iCurrency
//
//  Created by 陆文韬 on 16/3/8.
//  Copyright © 2016年 LunTao. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol AddCurrencyViewControllerDelegate <NSObject>//委托方声明协议
//委托方声明协议需要实现的方法
- (void)selectedCurrency:(NSString *)selectedCurrencyCode;
- (void)cancelled;
@end

@interface AddCurrencyViewController : UIViewController

//委托方声明委托变量
@property (nonatomic,weak) id<AddCurrencyViewControllerDelegate>delegate;


@end
