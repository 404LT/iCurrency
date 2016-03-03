//
//  ConvertCell.h
//  iCurrency
//
//  Created by 陆文韬 on 16/2/29.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface ConvertCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *countryImage;
@property (weak, nonatomic) IBOutlet UILabel *countryName;
@property (weak, nonatomic) IBOutlet UITextField *inputNumField;
@property (weak, nonatomic) IBOutlet UILabel *currencyUnit;

@end
