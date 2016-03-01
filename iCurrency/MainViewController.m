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

@end

@implementation MainViewController
{
    NSMutableArray *nameitems;//用于存储国家名称
    NSMutableArray *currencyUnit;//用于存储货币单位
    NSArray *images;//用于存储图片
    
}
- (IBAction)editMode:(id)sender {
    
        
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //可以在这里设置左右导航按钮
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    nameitems = [@"USA CNY JPY UK" componentsSeparatedByString:@" "];
    currencyUnit = [@"美元 人民币 日元 英镑"componentsSeparatedByString:@" "];
    images = [@"usa china jp uk"componentsSeparatedByString:@" "];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    表格的区段数
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    该区段的行数
#warning Incomplete implementation, return the number of rows
    NSLog(@"此时一共加载了%d个国家",nameitems.count);
    return nameitems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"convertCell";
    
    ConvertCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.countryName.text = [nameitems objectAtIndex:indexPath.row];
    cell.countryImage.image = [UIImage imageNamed:[images objectAtIndex:indexPath.row]];
    cell.currencyUnit.text = [currencyUnit objectAtIndex:indexPath.row];
    
    
    
    //    新建一个数据模型的类，由数据模型类提供表格里的内容再import到本类里面  在cell.countryName=..这样引入数据

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了一下第 %ld 个cell",indexPath.row+1);
    //创建一个弹出窗口
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你选择了一个国家" delegate:self cancelButtonTitle:@"暂时不用" otherButtonTitles:@"确定", nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];

}


// - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
// if (editingStyle == UITableViewCellEditingStyleDelete) {
// 
// [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
// } else if (editingStyle == UITableViewCellEditingStyleInsert) {
// 
// }
// }


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

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    //移动
//    NSString* fromObj = [self._arrayName objectAtIndex:sourceIndexPath.row];
//    [self._arrayName insertObject:fromObj atIndex:destinationIndexPath.row];
//    [self._arrayName removeObjectAtIndex:sourceIndexPath.row];
//}


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
    return @"删除";
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








/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
 Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
         Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
         Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
