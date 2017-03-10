//
//  SystemNotificationVC.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "SystemNotificationVC.h"
#import "SystemNotificationCell.h"
#import "SystemNotificationModel.h"

@interface SystemNotificationVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView; /**< tableview */
@property (nonatomic, strong) NSArray *dataArr; /**< 数据 */

@property (nonatomic, strong) SystemNotificationCell *cellTool; /**< 计算行高 */

@end

static NSString *cellid = @"SystemNotificationCell";

@implementation SystemNotificationVC
- (void)loadData {
    NSDictionary *dict = @{
                           @"token":[UserInfo getUserInfo].token,
                           @"isread":@"1"
                           };
    [self getRequestWithPath:API_systeminform params:dict success:^(id successJson) {
        NSLog(@"系统通知%@", successJson);
        if ([successJson[@"code"] integerValue] == 1) {
            self.dataArr = [SystemNotificationModel mj_objectArrayWithKeyValuesArray:successJson[@"data"]];
            [self.tableView reloadData];
        }
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"系统通知";
    [self.view addSubview:self.tableView];
    [self setNavBarItem];
    [self loadData];
    // 给计算高度的cell工具对象 赋值
    self.cellTool = [self.tableView dequeueReusableCellWithIdentifier:cellid];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
        [self.tableView.mj_header endRefreshing];
    }];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        
        [_tableView registerNib:[UINib nibWithNibName:cellid bundle:nil] forCellReuseIdentifier:cellid];
    }
    return _tableView;
}
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemNotificationModel *model = self.dataArr[indexPath.row];
    self.cellTool.systemModel = model;
    return [self.cellTool getCellHeight];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.systemModel = self.dataArr[indexPath.row];
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
