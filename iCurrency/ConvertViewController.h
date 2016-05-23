//
//  ConvertViewController.h
//  iCurrency
//
//  Created by 陆文韬 on 16/2/25.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConvertViewControllerDelegate <NSObject>

//定义这个协议用来传基准汇率国家名称的
- (void)selectBaseCurrency:(NSString *)selectedBaseCurrencyName;

@end



@interface ConvertViewController : UITableViewController<UIScrollViewDelegate>
@property (nonatomic) double baseAmount;


//声明委托变量
@property (nonatomic,weak)id<ConvertViewControllerDelegate>delegate;

- (void)addTargetCurrency;








@end
