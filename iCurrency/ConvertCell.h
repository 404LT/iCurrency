//
//  ConvertCell.h
//  iCurrency
//
//  Created by 陆文韬 on 16/2/29.
//  Copyright © 2016年 LunTao. All rights reserved.
//

//主界面操作汇率转换的自定义cell
#import <UIKit/UIKit.h>
@interface ConvertCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *countryImage;
@property (weak, nonatomic) IBOutlet UILabel *countryName;
@property (weak, nonatomic) IBOutlet UILabel *currencyUnit;
@property (weak, nonatomic) IBOutlet UILabel *targetCurrency;



@end
