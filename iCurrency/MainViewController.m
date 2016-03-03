//
//  MainViewController.m
//  iCurrency
//
//  Created by 陆文韬 on 16/2/25.
//  Copyright © 2016年 LunTao. All rights reserved.
//

#import "MainViewController.h"
#import "ConvertCell.h"
@interface MainViewController ()

@property (strong,nonatomic)UITextField *firstResponder;
@property (assign,nonatomic)BOOL keyBoardShown;
//@property (weak,nonatomic)UITextField *inputNumField;

@end

@implementation MainViewController
{
    NSMutableArray *nameitems;//用于存储国家名称
    NSMutableArray *currencyUnit;//用于存储货币单位
    NSArray *images;//用于存储图片
    NSMutableArray *nowCurrency;//用于存储当前汇率
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
    nameitems = [@"USA CNY JPY UK" componentsSeparatedByString:@" "];
    currencyUnit = [@"美元 人民币 日元 英镑"componentsSeparatedByString:@" "];
    images = [@"usa china jp uk"componentsSeparatedByString:@" "];
    nowCurrency = [@"100 300 500 128"componentsSeparatedByString:@" "];
    
//    UITapGestureRecognizer *gestureRecognizer = [[UIGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];
//    gestureRecognizer.cancelsTouchesInView = NO;
//    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 表格协议的代理

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
    return 75.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"convertCell";
    
    ConvertCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.countryName.text = [nameitems objectAtIndex:indexPath.row];
    cell.countryImage.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    cell.currencyUnit.text = [currencyUnit objectAtIndex:indexPath.row];
    
    //再次编辑清空文本框内容
    cell.inputNumField.clearsOnBeginEditing = YES;
    
    //    设置每个cell里面文本框的初始默认内容为当日汇率
    cell.inputNumField.text = [nowCurrency objectAtIndex:indexPath.row];
    
    //    cell.backgroundColor = [UIColor lightGrayColor];
    //    cell.
    
    //    新建一个数据模型的类，由数据模型类提供表格里的内容再import到本类里面  在cell.countryName=..这样引入数据
    
    
    return cell;
}


#pragma mark - 隐藏键盘
//- (IBAction)inputFieldBeginEdit:(id)sender {
//    NSLog(@"//文本输入框开始编辑");
//    self.firstResponder=sender;
//    NSLog(@"firstResponder exists22 ,%p",self.firstResponder);
//    
//}

//- (void)hideKeyboard
//{
//    NSLog(@"关闭键盘");
//    ConvertCell *cell = [[ConvertCell alloc]init];
//    [cell.inputNumField resignFirstResponder];
//}

////设置第一响应者
//-(void) setFirstResponder{
//    NSIndexPath *path=[NSIndexPath indexPathForItem:0 inSection:0];
//    UITextField *field=((ConvertCell*)[self.tableView cellForRowAtIndexPath:path]).inputNumField;
//    [self setFirstResponder:field];
//}
//
////关闭键盘
//- (void) dismissKeyboard{
//    NSLog(@"关闭键盘");
//    //    if(self.firstResponder && self.keyBoardShown)
//    {
//        [self.firstResponder resignFirstResponder];
//        ConvertCell *cell = [[ConvertCell alloc]init];
//        [cell.inputNumField resignFirstResponder];
//         NSLog(@"成功关闭键盘");
//        //        self.firstResponder=nil;
//    }
//}
//
//-(void) setupForDismissKeyboard{
//    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
//    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        [self.tableView addGestureRecognizer:tapRecognizer];
//        self.keyBoardShown=YES;
//        //        self.tableView.showsPullToRefresh=NO;
//    }];
//    [[NSNotificationCenter defaultCenter]addObserverForName:UIKeyboardDidHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        [self.tableView removeGestureRecognizer:tapRecognizer];
//        self.keyBoardShown=NO;
//        //        self.tableView.showsPullToRefresh=YES;
//        
//    }];
//}







- (void)setupKeyboardDismissGestures
{
    
    //    Example for a swipe gesture recognizer. it was not set-up since we use scrollViewDelegate for dissmin-on-swiping, but it could be useful to keep in mind for views that do not inherit from UIScrollView
    //    UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    //    swipeUpGestureRecognizer.cancelsTouchesInView = NO;
    //    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    //    [self.tableView addGestureRecognizer:swipeUpGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    //this prevents the gestureRecognizer to override other Taps, such as Cell Selection
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
}


//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//{
//    [self dismissKeyboard];
//}

- (void)dismissKeyboard
{
    NSLog(@"dismissKeyboard");
//    ConvertCell *customCell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.tableView indexPathForSelectedRow] inSection:0]];
    
//    ConvertCell *customCell =[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    [customCell.inputNumField resignFirstResponder];
//    
    
    [self.tableView endEditing:YES];
    //这个方法不错，当执行隐藏键盘事件的时候  把整个tableView 的编辑功能结束从而实现隐藏键盘
    //this convenience method on UITableView sends a nested message to all subviews, and they resign responders if they have hold of the keyboard
   
    
//    [customCell.inputNumField resignFirstResponder];
//    
//    ConvertCell *customCell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
//    [customCell2.inputNumField resignFirstResponder];
//    
//    ConvertCell *customCell3= [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    [customCell3.inputNumField resignFirstResponder];
//    
//    ConvertCell *customCell4 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
//    [customCell4.inputNumField resignFirstResponder];
    
}

//
//- (void)setupKeyboardDismissTaps{
//    
//    UISwipeGestureRecognizer *swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
//    swipeUpGestureRecognizer.cancelsTouchesInView = NO;
//    swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
//    [self.tableView addGestureRecognizer:swipeUpGestureRecognizer];
//    
//    UISwipeGestureRecognizer *swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
//    swipeDownGestureRecognizer.cancelsTouchesInView = NO;
//    swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
//    [self.tableView addGestureRecognizer:swipeDownGestureRecognizer];
//    
//    UISwipeGestureRecognizer *swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    swipeLeftGestureRecognizer.cancelsTouchesInView = NO;
//    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
//    [self.tableView addGestureRecognizer:swipeLeftGestureRecognizer];
//    
//    UISwipeGestureRecognizer *swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    swipeRightGestureRecognizer.cancelsTouchesInView = NO;
//    swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
//    [self.tableView addGestureRecognizer:swipeRightGestureRecognizer];
//    
//    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
//    tapGestureRecognizer.cancelsTouchesInView = NO;
//    [self.tableView addGestureRecognizer:tapGestureRecognizer];
//}

//SS上面的滑动隐藏键盘 但是不能在第二个cell上面实现
//
//*/








//- (void)setFirstResponder:(UITextField *)firstResponder
//{
//    NSLog(@"设置首个响应者");
//    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
//    UITextField *field = ((ConvertCell *)[self.tableView cellForRowAtIndexPath:path]).inputNumField;
//    [self setFirstResponder:field];
//    
//    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.tableView addGestureRecognizer:tapRecognizer];
//    
//}
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
////    if (![touch.view isKindOfClass: [UITextField class]]) {
////        [self hideKeyBoard];
////        return NO;
////    }
////    NSLog(@"shouldReceiveTouch = yes");
////    return YES;
//    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.tableView addGestureRecognizer:tapRecognizer];
//    
//}
//
//
//- (void)dismissKeyboard{
//    NSLog(@"关闭键盘");
//    if (self.firstResponder && self.keyBoardShown) {
//        [self.firstResponder resignFirstResponder];
//        self.firstResponder = nil;
//    }
//    NSLog(@"已经关闭键盘");
//
//}
//
//-(void) setupForDismissKeyboard{
//    UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
//    [self.tableView addGestureRecognizer:tapRecognizer];
//    tapRecognizer.cancelsTouchesInView =NO;
//    
////    [self.view addGestureRecognizer:tapRecognizer];
//    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        [self.tableView addGestureRecognizer:tapRecognizer];
//        self.keyBoardShown=YES;
//        //        self.tableView.showsPullToRefresh=NO;
//    }];
//    [[NSNotificationCenter defaultCenter]addObserverForName:UIKeyboardDidHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        [self.tableView removeGestureRecognizer:tapRecognizer];
//        self.keyBoardShown=NO;
//        //        self.tableView.showsPullToRefresh=YES;
//        
//    }];
//
//}







//- (void)setFirstResponder:(UITextField *)firstResponder
//{
//    NSLog(@"设置第一响应者");
//    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0];
//    UITextField *field = ((ConvertCell *)[self.tableView cellForRowAtIndexPath:path]).inputNumField;
//    [self setFirstResponder:field];
//}
//
//- (void)hideKeyBoard{
//    NSLog(@"hidekeyboard is called");
//    //创建第0区第1行的indexPath
////    NSUInteger newIndex[] = {0, 1};
////    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
//        NSIndexPath *newPath = [NSIndexPath indexPathForItem:0 inSection:0];
//    //    UITextField *field = ((ConvertCell *)[self.tableView cellForRowAtIndexPath:path]).inputNumField;
//    //    [self setFirstResponder:field];
//    
//    
//    //找到对应的cell
//    ConvertCell *nextCell = (ConvertCell*)[self.tableView cellForRowAtIndexPath:newPath];
//    
//    [nextCell.inputNumField resignFirstResponder];//numText就是UITextField
//}





#pragma mark - 表格中其他的一些设置

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    这个函数不一定用得上
//    NSLog(@"点击了一下第 %ld 个cell",indexPath.row+1);
//    //创建一个弹出窗口
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你选择了一个国家" delegate:self cancelButtonTitle:@"暂时不用" otherButtonTitles:@"确定", nil];
////    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alert show];
//
//}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//当进入编辑模式下时，左导航按钮变为添加
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"删除");
        [nameitems removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
//    else if (items.count == 0){
//        NSLog(@"重新加载所有数据");
//        [tableView reloadData];
//    }
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
//    if (indexPath.row % 2 == 0) {
//        // 偶数，添加
//        return UITableViewCellEditingStyleInsert;
//    } else {
//        // 奇数，删除
//        return UITableViewCellEditingStyleDelete;
//    }
    
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

#pragma mark - 还没用的上的函数

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if (![touch.view isKindOfClass: [UITextField class]]) {
//        [self hideKeyBoard];
//        return NO;
//    }
//    NSLog(@"shouldReceiveTouch = yes");
//    return YES;
//}

//- (void)hideKeyBoard{
//    //创建第0区第1行的indexPath
//    NSLog(@"隐藏键盘");
//    NSUInteger newIndex[] = {0, 1};
//    NSIndexPath *newPath = [[NSIndexPath alloc] initWithIndexes:newIndex length:2];
//    //找到对应的cell
//    ConvertCell *nextCell = [self.tableView cellForRowAtIndexPath:newPath];
//
//    [nextCell.inputNumField resignFirstResponder];//numText就是UITextField
//}


// - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
// if (editingStyle == UITableViewCellEditingStyleDelete) {
//
// [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
// } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//
// }
// }

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    //移动
//    NSString* fromObj = [self._arrayName objectAtIndex:sourceIndexPath.row];
//    [self._arrayName insertObject:fromObj atIndex:destinationIndexPath.row];
//    [self._arrayName removeObjectAtIndex:sourceIndexPath.row];
//}


@end
