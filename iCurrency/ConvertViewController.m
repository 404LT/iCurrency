//
//  ConvertViewController.m
//  iCurrency
//
//  Created by 陆文韬 on 16/2/25.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import "ConvertViewController.h"
#import "ConvertCell.h"
#import "ExchangeRate.h"
#import "CurrencyManager.h"
#import "YahooFinanceClient.h"
#import "SettingViewController.h"
#import "AddCurrencyViewController.h"

@interface ConvertViewController ()

@property (strong,nonatomic)UITextField *firstResponder;
@property (assign,nonatomic)BOOL keyBoardShown;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)YahooFinanceClient *info;//用于传输抓取的信息
@property (strong,nonatomic) NSMutableArray   * currencyDisplay;



//@property (weak,nonatomic)UITextField *inputNumField;

@end

@implementation ConvertViewController
{
    NSMutableArray *nameitems;//用于存储国家名称
    NSMutableArray *currencyUnit;//用于存储货币单位
    NSArray *images;//用于存储图片
    NSMutableArray *nowCurrency;
    NSNumber *staticCurrency;//用于存储当前汇率，这个NSMutableString是用于测试动态更新cell内容的，一个静态值
}

- (IBAction)editMode:(id)sender {
//    编辑按钮触发的事件，暂时用不上
    
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
//   [self setupForDismissKeyboard];
    //可以在这里设置左右导航按钮
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    以下数据均经网络由雅虎财经获取
//    有可能需要把每个国家的信息用字典来装载
    nameitems = [@"USA CNY JPY HKD GBP AUD CAD EUR SWIZ MOP KOR" componentsSeparatedByString:@" "];
    currencyUnit = [@"美元 人民币 日元 港币 英镑 澳大利亚元 加拿大美元 欧元 瑞士法郎 葡币 韩元"componentsSeparatedByString:@" "];
    images = [@"usa china jp hkd uk aud cad eur swiz mop kor"componentsSeparatedByString:@" "];
    nowCurrency = [@"100 300 500 128 778 879 227 998 657 887 367"componentsSeparatedByString:@" "];
    staticCurrency = @"100";
    
    self.tableView.allowsSelection = false;
    
    
//    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 动态改变cell里的内容

- (IBAction)inputEditingChanged:(id)sender {
    
}




#pragma mark - 表格数据源

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //    表格的区段数

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    该区段的行数
    NSLog(@"此时一共加载了%lu个国家",nameitems.count);
    return nameitems.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //表格高度
    return 85.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"convertCell";
    
    ConvertCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.countryName.text = [nameitems objectAtIndex:indexPath.row];
    NSLog(@"the currency name is %@,the row is %ld",nameitems,indexPath.row);
    
    cell.countryImage.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    cell.currencyUnit.text = [currencyUnit objectAtIndex:indexPath.row];
    
    //再次编辑清空文本框内容
//    cell.targetCurrency.clearsOnBeginEditing = YES;
    
    //    设置每个cell里面文本框的初始默认内容为当日汇率
    cell.targetCurrency.text = [nowCurrency objectAtIndex:indexPath.row];
    
    
    //    新建一个数据模型的类，由数据模型类提供表格里的内容再import到本类里面  在cell.countryName=..这样引入数据
    
    
    return cell;
}


#pragma mark - 隐藏键盘
//最终可用版本
- (void)setupKeyboardDismissGestures
{
    //    Example for a swipe gesture recognizer. it was not set-up since we use scrollViewDelegate for dissmin-on-swiping, but it could be useful to keep in mind for views that do not inherit from UIScrollView
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    //this prevents the gestureRecognizer to override other Taps, such as Cell Selection
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
}

- (void)dismissKeyboard
{
    NSLog(@"dismissKeyboard is called");
    [self.tableView endEditing:YES];
}

#pragma mark - 表格中其他的一些设置

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当选中当前的row时候，自动将其切换成基准汇率
    

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//当进入编辑模式下时，左导航按钮变为添加
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除");
        [nameitems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }

    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        NSLog(@"添加模式");
//        NSArray *indexPaths = @[indexPath];
//        [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationRight)];

        // 添加一条数据
        [nameitems insertObject:[NSString stringWithFormat:@"%@", @"增加的Cell"] atIndex:indexPath.row + 1];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0];
        // 注意点:数组中插入的条数必须和tableview界面上插入的cell条一致
        // 否则程序会报错
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationBottom];

    }
    
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    //移动行
    NSLog(@"进入移动行模式");
    NSString *fromObj = [nameitems objectAtIndex:sourceIndexPath.row];
    [nameitems insertObject:fromObj atIndex:destinationIndexPath.row];
    [nameitems removeObjectAtIndex:sourceIndexPath.row];
}



// 用于告诉系统开启的编辑模式是什么模式
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //编辑模式用于删除cell
    return UITableViewCellEditingStyleDelete;
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    本函数用于修改 删除按钮显示的信息
    return @"delete this country";
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
//    判断是否可以移动行
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"可以编辑行");
    return YES;
}


#pragma mark - 更新表格数据部分
//
//- (void)initCurrencyDisplay
//{
////    用于初始化汇率显示
//    //_currencyShown=[[NSMutableArray alloc]initWithObjects:@"CNY",@"USD",@"EUR",@"HKD", @"JPY",@"KRW",@"GBP",@"TWD",@"MOP",@"CAD",nil];
////    _currencyShown=[[CurrencyShown getCurrencyShown] mutableCopy];
////    _currencyDisplay= [[]
//}
//
//-(void) initCurrencyInfo{
////    _info=[[DownloadInfo alloc]initWithDelegate:self];
////用上info 初始化汇率的info
//}
//
//- (NSMutableArray *)  NumberShown  {
////    if(_NumberShown==nil){
////        _NumberShown=[[NSMutableArray alloc]init];
////        NSNumber *firstNumber=[FirstNumber getFirstNumber];
////        [_NumberShown addObject:firstNumber];
////        float value=[firstNumber floatValue];
////        NSString *firstName=self.currencyShown[0];
////        for (int i=1; i<self.currencyShown.count; i++) {
////            float newCurrencyValue=[self.info exchangeToCurrency:self.currencyShown[i] withNumber:value oldCurrency:firstName];
////            [_NumberShown addObject:[NSNumber numberWithFloat:newCurrencyValue]];
////        }
////    }
////    return _NumberShown;
//    
////}
//
//-(void) setFirstResponder{
////    设置首个响应者
////    NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:0];
////    UITextField *filed=((UICustomCell*)[self.tableView cellForRowAtIndexPath:path]).inputText;
////    [self setFirstResponder:filed];
//}
//
//-(void) updateUI {
////    NSLog(@"UI is updated");
////    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
////    [self updateCellWithIndexPath:indexpath];
//    
//}
//
//- (void) updateCell:(ConvertCell *) cellA inputText:(float)currencyNumber{
////    NSLog(@"updateCell is called");
////    if(fabs((float)(int)currencyNumber-currencyNumber)<pow(10, -10))
////        cellA.inputText.text=[NSString stringWithFormat:@"%.0f",currencyNumber];
////    else
////        cellA.inputText.text=[NSString stringWithFormat:@"%.2f",currencyNumber];
//}
//
//- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
////    self.deleteOnRow=YES;
//}
//
//-(void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
////    if(indexPath.row>=0 && indexPath.row<self.currencyShown.count )
//    {
////        [self setEditing:NO animated:YES];
////        
//    }
//}
//
////- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
////    NSLog(@"set editing is called");
////    [super setEditing:editing animated:animated];
////    [self.tableView setEditing:editing animated:YES];
////    [self dismissKeyboard];
////    if (editing) {
////        //save and clear;
////        if(!self.deleteOnRow)   [self clearAndSaveNumberStatus];
////    }
////    else {
////        if(!self.deleteOnRow)   [self restoreStatus];
////        [self saveCurrencyShown];
////        [self saveFirstNumber];
////        
////    }
////}
//
//
//-(void) clearAndSaveNumberStatus{
////    self.NumberShown_temp=[self.NumberShown mutableCopy];
////    if(self.NumberShown_temp.count>0){
////        [self.NumberShown replaceObjectAtIndex:0 withObject:[NSNumber numberWithFloat:0]];
////        NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:0];
////        UICustomCell *cell=(UICustomCell*)[self.tableView cellForRowAtIndexPath:path];
////        [self updateCell:cell inputText:0];
////        [self updateCellWithIndexPath:0];
////        
////    }
//    
//}
//
//-(void) restoreStatus{
////    self.NumberShown=[self.NumberShown_temp mutableCopy];
////    [self refreshTableView];
////    
//}
//
//- (IBAction)inputField:(UITextField *)sender {
////    // NSLog([[[[[sender superview] superview]superview] class] debugDescription]);
////    NSLog(@"input Field is called");
////    float OSversion=[[[UIDevice currentDevice] systemVersion] floatValue];
////    UIView *view;
////    if(OSversion >=7.0 && OSversion<8.0)
////        view=[[[sender superview] superview]superview];
////    else if (OSversion>=8.0)
////        view=[[sender superview]superview];
////    else return ;
////    if([view isKindOfClass:[UICustomCell class]]){
////        UICustomCell *hotCell=(UICustomCell*)view;
////        NSIndexPath *indexpath=[self.tableview indexPathForCell:hotCell];
////        NSLog(@"the %ld",indexpath.row);
////        [self updateCellWithIndexPath:indexpath];
////    }
//    
//}
//
//- (IBAction)inputFieldBeginEdit:(UITextField *)sender {
//    self.firstResponder=sender;
//    NSLog(@"firstResponder exists22 ,%p",self.firstResponder);
//    
//}
//
//- (IBAction)TouchDown:(UITextField *)sender {
//    NSLog(@"I am touching down");
//    //  BOOL abc=[sender becomeFirstResponder];
//    //  if (abc) {
//    //      NSLog(@"abc is true");
//    ///  }
//}
//
//// update other cell 's data source and Text Field Shown , not update itself
//// To use this function ,the data source[row] must be newest
//-  (void) updateOtherCellByRow:(NSUInteger) row {
////    float oldCurrencyNumbr=[[self.NumberShown objectAtIndex:row]floatValue];
////    NSString *oldCurrencyName=self.currencyShown[row];
////    for (int i=0; i<self.currencyShown.count; i++) {
////        if(row==i) continue;
////        NSString *newCurrencyName=self.currencyShown[i];
////        float currencyNumber=[self.info exchangeToCurrency:newCurrencyName withNumber:oldCurrencyNumbr oldCurrency:oldCurrencyName];
////        [self.NumberShown replaceObjectAtIndex:i withObject:[NSNumber numberWithFloat:currencyNumber]];
////        UICustomCell *cell_new=(UICustomCell*)[self.tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
////        if (cell_new==nil) {
////            NSLog(@"cell new is nil");
////        }
////        [self updateCell:cell_new inputText:currencyNumber];
////        NSLog(@"cell is updated to %f",currencyNumber);
////    }
//}
//
////get the first number from the UI ,then it update all the data source and UI according that
//-  (void) updateCellWithIndexPath:(NSIndexPath*)indexPath{
////    UICustomCell *cell_old=(UICustomCell*)[self.tableview cellForRowAtIndexPath:indexPath];
////    float oldCurrencyNumbr=[cell_old.inputText.text floatValue];
////    [self.NumberShown replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithFloat:oldCurrencyNumbr]];
////    [self updateOtherCellByRow:indexPath.row];
////    
//}
//
//-(void) refreshTableView{
//    
////    [self.tableview reloadData];
//    
//}
//
//- (void) saveFirstNumber{
////    NSLog(@"save First Number is called");
////    if(self.NumberShown.count>=1){
////        [FirstNumber updateFirstNumber:self.NumberShown[0]];
////    }
//}
//
//- (void) saveCurrencyShown{
////    NSLog(@"save Currency Shown is called");
////    if(self.currencyShown.count>=1){
////        [CurrencyShown updateCurrencyShown:self.currencyShown];
////    }
//}

@end
