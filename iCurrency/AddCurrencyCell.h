//
//  AddCurrencyCell.h
//  iCurrency
//
//  Created by 陆文韬 on 16/3/8.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加国家view当中的tableviewcell
@interface AddCurrencyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *countryImage;
@property (weak, nonatomic) IBOutlet UILabel *countryName;

@property(nonatomic,assign)BOOL isSelected;//用于判断当前国家是否被选中

//@property (weak, nonatomic) IBOutlet UITextField *inputNumField;
//@property (weak, nonatomic) IBOutlet UILabel *currencyUnit;

@end
