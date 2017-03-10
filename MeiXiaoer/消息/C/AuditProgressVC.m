//
//  AuditProgressVC.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "AuditProgressVC.h"
#import "AuditNotificationCell.h"
#import "AuditNotificationModel.h"

@interface AuditProgressVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView; /**< tableview */

@property (nonatomic, strong) NSArray *dataArr; /**< 数据 */

@property (nonatomic, strong) AuditNotificationCell *cellToole; /**< 高度计算 */

@end

static NSString *cellid = @"AuditNotificationCell";

@implementation AuditProgressVC
- (void)loadData {
    //    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:MeixiaoerToken];
    NSDictionary *dict = @{
                           @"token":[UserInfo getUserInfo].token
                           };
    [self getRequestWithPath:API_audit params:dict success:^(id successJson) {
        NSLog(@"审核进度%@", successJson);
        if ([successJson[@"code"] integerValue] == 1) {
            self.dataArr = [AuditNotificationModel mj_objectArrayWithKeyValuesArray:successJson[@"data"]];
            [self.tableView reloadData];
        }
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"审核进度";
    [self.view addSubview:self.tableView];
    [self setNavBarItem];
    [self loadData];
    
    self.cellToole = [self.tableView dequeueReusableCellWithIdentifier:cellid];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
        [self.tableView.mj_header endRefreshing];
    }];
}
- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
    return self.dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.cellToole.auditModel = self.dataArr[indexPath.row];
    return [self.cellToole getCellHeight];;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AuditNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.auditModel = self.dataArr[indexPath.row];
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
