//
//  OrderNotificationVC.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "OrderNotificationVC.h"
#import "OrderNotificationCell.h"
#import "OrderNotificationModel.h"
#import "WebViewViewController.h"

@interface OrderNotificationVC ()<UITableViewDelegate, UITableViewDataSource>
{
    int page;
}
@property (nonatomic, strong) UITableView *tableView; /**< tableview */

@property (nonatomic, strong) NSMutableArray *dataArr; /**< 数据 */

@end

static NSString *cellid = @"OrderNotificationCell";

@implementation OrderNotificationVC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];    
}
- (void)loadData {
    // 订单列表的
    NSDictionary *dict = @{
                           @"status":@(0),
                           @"pageindex":@(page),
                           @"pagesize":@(10),
                           @"token":[UserInfo getUserInfo].token
                           };
    [self getRequestWithPath:API_orderlist params:dict success:^(id successJson) {
        NSLog(@"订单通知---%@", successJson);
        if (page == 1) {
            [self.tableView.mj_footer resetNoMoreData];
            if ([successJson[@"code"] isEqualToString:@"0000"]) {
                self.dataArr = [OrderNotificationModel mj_objectArrayWithKeyValuesArray:successJson[@"data"]];
                [self.tableView reloadData];
            }
        }else{
            NSIndexPath *index = [NSIndexPath indexPathForRow:self.dataArr.count - 1 inSection:0];
            NSArray *arr = [OrderNotificationModel mj_objectArrayWithKeyValuesArray:successJson[@"data"]];
            [self.dataArr addObjectsFromArray:arr];
            if (arr.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                page -= 1;
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
            [self.tableView scrollToRowAtIndexPath:index atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
        }
        } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单通知";
    [self.view addSubview:self.tableView];
    
    [self setNavBarItem];
    page = 1;
    [self loadData];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page = 1;
        [self loadData];
        [self.tableView.mj_header endRefreshing];
    }];
    self.tableView.mj_footer.automaticallyHidden = YES;
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page ++;
        [self loadData];
    }];
}
- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
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
    return 260;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.orderModel = self.dataArr[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderNotificationModel *orderModel = self.dataArr[indexPath.row];
    NSString *orderURL;
    if (orderModel.status == 1) {
        //"待确认";
        orderURL = [NSString stringWithFormat:@"http://mxe-pc.fh25.com/app/ordercoal.html?id=%@", orderModel.ID];
    }else if (orderModel.status == 2){
        //"待装煤";
        orderURL = [NSString stringWithFormat:@"http://mxe-pc.fh25.com/app/ordercoal.html?id=%@", orderModel.ID];
    }else if (orderModel.status == 3){
        //"已取消";
        orderURL = [NSString stringWithFormat:@"http://mxe-pc.fh25.com/app/ordercancel.html?id=%@", orderModel.ID];
    }else if (orderModel.status == 4){
        //"已完成";
        orderURL = [NSString stringWithFormat:@"http://mxe-pc.fh25.com/app/orderwancheng.html?id=%@", orderModel.ID];
    }
    
    self.view.window.rootViewController = [[WebViewViewController alloc] init];
    
    NSDictionary *dict = @{@"url":orderURL};
    NSNotification* notification = [NSNotification notificationWithName:@"URLSTRING" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
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
