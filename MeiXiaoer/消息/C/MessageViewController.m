//
//  MessageViewController.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageCell.h"

#import "OrderNotificationVC.h"
#import "SystemNotificationVC.h"
#import "PaymentAssistantVC.h"
#import "AuditProgressVC.h"
#import "ChatConversionVC.h"

#import "PersonalMessageModel.h"

#import "OrderNotificationModel.h"
#import "SystemNotificationModel.h"
#import "PayMentModel.h"
#import "AuditNotificationModel.h"

//#import <EMSDK.h>

@interface MessageViewController ()<UITableViewDelegate, UITableViewDataSource, EaseConversationListViewControllerDataSource, EaseConversationListViewControllerDelegate, IEMChatManager>

#pragma mark
#pragma mark - session1数据
@property (nonatomic, strong) NSArray *session1icons; /**< session1头像 */
@property (nonatomic, strong) NSArray *session1titles; /**< session1名字 */
@property (nonatomic, strong) NSMutableDictionary *session1dict; /**< session1数据 */

#pragma mark
#pragma mark - session2数据
@property (nonatomic, strong) NSMutableDictionary *session2Icons; /**< session2名字、头像 */
@property (nonatomic, strong) NSMutableArray *session2dataArr; /**< session2数据 */
@property (nonatomic, strong) UITableView *tableView; /**< tableview */

@end
static NSString *cellid = @"MessageCell";
@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loginHuanxin];
    
    if ([UserInfo getUserInfo].ID.length > 0) {
        [self getSystemMessage];
    }else{
        [self.tabBarController setSelectedIndex:3];
    }
    // 获得聊天回话
    if ([EMClient sharedClient].isLoggedIn) {
        NSArray *arr = [[[EMClient sharedClient].chatManager getAllConversations] mutableCopy];
        [self.session2dataArr removeAllObjects];
        [self.session2Icons removeAllObjects];
        // 只要单聊对话
        for (EMConversation *conversation in arr) {
            if (conversation.type == EMConversationTypeChat) {
                [self.session2dataArr addObject:conversation];
                [self.tableView reloadData];
            }
        }
    }else{
        [self.session2dataArr removeAllObjects];
        [self.tableView reloadData];
    }
}
- (void)getSystemMessage {
    
    // 订单列表的
    NSDictionary *orderDict = @{
                           @"status":@(0),
                           @"pageindex":@(1),
                           @"pagesize":@(10),
                           @"token":[UserInfo getUserInfo].token
                           };
    [self getRequestWithPath:API_orderlist params:orderDict success:^(id successJson) {
        if ([successJson[@"code"] isEqualToString:@"0000"]) {
            NSArray *orderArr = [OrderNotificationModel mj_objectArrayWithKeyValuesArray:successJson[@"data"]];
            if (orderArr.count > 0) {
                OrderNotificationModel *model = [orderArr firstObject];
                NSString *message = [NSString stringWithFormat:@"%@ %ld大卡", model.supply.goodsType, (long)model.supply.calorificValue];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@"0" forKey:@"noread"];
                [dict setObject:message forKey:@"message"];
                [dict setObject:model.createdAt forKey:@"time"];
                [self.session1dict setObject:dict forKey:@"order"];
            }else{
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@"0" forKey:@"noread"];
                [dict setObject:@"暂无" forKey:@"message"];
                [dict setObject:@"1" forKey:@"time"];
                [self.session1dict setObject:dict forKey:@"order"];
            }
            [self.tableView reloadData];
        }
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];

    NSDictionary *systemDict = @{
                           @"token":[UserInfo getUserInfo].token,
                           @"isread":@"1"
                           };
    [self getRequestWithPath:API_systeminform params:systemDict success:^(id successJson) {
        if ([successJson[@"code"] integerValue] == 1) {
            NSArray *systemArr = [SystemNotificationModel mj_objectArrayWithKeyValuesArray:successJson[@"data"]];
            if (systemArr.count > 0) {
                SystemNotificationModel *model = [systemArr firstObject];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:successJson[@"noreadcount"] forKey:@"noread"];
                [dict setObject:model.title forKey:@"message"];
                [dict setObject:model.createdAt forKey:@"time"];
                [self.session1dict setObject:dict forKey:@"system"];
            }else{
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@"0" forKey:@"noread"];
                [dict setObject:@"暂无" forKey:@"message"];
                [dict setObject:@"1" forKey:@"time"];
                [self.session1dict setObject:dict forKey:@"system"];
            }
            
            [self.tableView reloadData];
        }
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];

    NSDictionary *payDict = @{
                           @"token":[UserInfo getUserInfo].token
                           };
    [self getRequestWithPath:API_payhelper params:payDict success:^(id successJson) {
        if ([successJson[@"code"] isEqualToString:@"0000"]) {
            NSArray *payArr = [PayMentModel mj_objectArrayWithKeyValuesArray:successJson[@"data"]];
            
            if (payArr.count > 0) {
                PayMentModel *model = [payArr firstObject];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:successJson[@"noreadcount"] forKey:@"noread"];
                NSString *message = [NSString stringWithFormat:@"￥%@", model.fee];
                [dict setObject:message forKey:@"message"];
                [dict setObject:model.createdAt forKey:@"time"];
                [self.session1dict setObject:dict forKey:@"pay"];
            }else{
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@"0" forKey:@"noread"];
                [dict setObject:@"￥0" forKey:@"message"];
                [dict setObject:@"1" forKey:@"time"];
                [self.session1dict setObject:dict forKey:@"pay"];
            }
            [self.tableView reloadData];
        }
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    
    NSDictionary *auditDict = @{
                           @"token":[UserInfo getUserInfo].token
                           };
    [self getRequestWithPath:API_audit params:auditDict success:^(id successJson) {
        if ([successJson[@"code"] integerValue] == 1) {
            NSArray *auditArr = [AuditNotificationModel mj_objectArrayWithKeyValuesArray:successJson[@"data"]];
            if (auditArr.count > 0) {
                AuditNotificationModel *model = [auditArr lastObject];
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:successJson[@"noreadcount"] forKey:@"noread"];
                [dict setObject:model.title forKey:@"message"];
                [dict setObject:model.createdAt forKey:@"time"];
                [self.session1dict setObject:dict forKey:@"audit"];
            }else{
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:@0 forKey:@"noread"];
                [dict setObject:@"暂无" forKey:@"message"];
                [dict setObject:@"1" forKey:@"time"];
                [self.session1dict setObject:dict forKey:@"audit"];
            }
            [self.tableView reloadData];
        }
    } error:^(NSError *error) {
        NSLog(@"%@", error);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = @"消息";
    
    UIButton *btn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn setImage:[UIImage imageNamed:@"图层-860"] forState:(UIControlStateNormal)];
    [btn setContentMode:(UIViewContentModeCenter)];
    [btn addTarget:self action:@selector(call) forControlEvents:(UIControlEventTouchDown)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    

    NSDictionary *titleDict = @{
                                NSFontAttributeName:[UIFont systemFontOfSize:17],
                                NSForegroundColorAttributeName:[UIColor blackColor]
                                };
    [self.navigationController.navigationBar setTitleTextAttributes:titleDict];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg"] forBarMetrics:(UIBarMetricsDefault)];

    [self.view addSubview:self.tableView];
    [self refer];
  
}
- (void)refer {
    // 上下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 重新获取数据
        if ([UserInfo getUserInfo].ID.length > 0) {
            [self getSystemMessage];
        }else{
            [self.tabBarController setSelectedIndex:3];
        }
  
        // 获得聊天回话
        if ([EMClient sharedClient].isLoggedIn) {
            NSArray *arr = [[[EMClient sharedClient].chatManager getAllConversations] mutableCopy];
            [self.session2dataArr removeAllObjects];
            [self.session2Icons removeAllObjects];
            // 只要单聊对话 且发送者属于当前登录账户
            for (EMConversation *conversation in arr) {
                if (conversation.type == EMConversationTypeChat ) {
                    
                    [self.session2dataArr addObject:conversation];
                    [self.tableView reloadData];
                }
            }

        }else{
            [self.session2dataArr removeAllObjects];
            [self.tableView reloadData];
        }
        
        [self.tableView.mj_header endRefreshing];
    }];

}
- (void)call{
    //打电话
    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:400-044-0806"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
//    UIWebView *callWebview = [[UIWebView alloc] init];
//    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
//    [self.view addSubview:callWebview];
//    [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:str]];
}

- (void)loginHuanxin {
    if ([UserInfo getUserInfo].ID.length != 0) {
        // 退出登录
        EMError *logoutErr = [[EMClient sharedClient] logout:YES];
        if (logoutErr) {
            NSLog(@"退出登录%@", logoutErr.errorDescription);
        }
        NSString *userId = [UserInfo getUserInfo].ID;
        
        EMError *error2 = [[EMClient sharedClient] loginWithUsername:userId password:[NSString md5WithString:userId]];
        if (!error2) {
            NSLog(@"登录成功");
        }else{
            NSLog(@"登录失败--%@", error2.errorDescription);
        }
    }else{
        [self showTabBar];
        [self.tabBarController setSelectedIndex:3];
    }
}

#pragma mark
#pragma mark - 懒加载
- (NSArray *)session1icons {
    if (!_session1icons) {
        _session1icons = [NSArray arrayWithObjects:@"icon", @"icon_36", @"icon_54", @"icon_30", nil];
    }
    return _session1icons;
}
- (NSArray *)session1titles {
    if (!_session1titles) {
        _session1titles = [NSArray arrayWithObjects:@"订单通知", @"系统通知", @"支付助手", @"审核进度", nil];
    }
    return _session1titles;
}

- (NSMutableDictionary *)session1dict {
    if (!_session1dict) {
        _session1dict = [NSMutableDictionary dictionary];
       
        // 订单通知
        NSMutableDictionary *orderdict = [NSMutableDictionary dictionary];
        [orderdict setObject:@"0" forKey:@"noread"];
        [orderdict setObject:@"暂无" forKey:@"message"];
        [orderdict setObject:@"1" forKey:@"time"];
        [_session1dict setObject:orderdict forKey:@"order"];
        
        // 系统消息
        NSMutableDictionary *systemdict = [NSMutableDictionary dictionary];
        [systemdict setObject:@"0" forKey:@"noread"];
        [systemdict setObject:@"暂无" forKey:@"message"];
        [systemdict setObject:@"1" forKey:@"time"];
        [_session1dict setObject:systemdict forKey:@"system"];
        
        // 支付助手
        NSMutableDictionary *paydict = [NSMutableDictionary dictionary];
        [paydict setObject:@"0" forKey:@"noread"];
        [paydict setObject:@"￥0" forKey:@"message"];
        [paydict setObject:@"1" forKey:@"time"];
        [_session1dict setObject:paydict forKey:@"pay"];
        
        // 审核进度
        NSMutableDictionary *auditdict = [NSMutableDictionary dictionary];
        [auditdict setObject:@0 forKey:@"noread"];
        [auditdict setObject:@"暂无" forKey:@"message"];
        [auditdict setObject:@"1" forKey:@"time"];
        [_session1dict setObject:auditdict forKey:@"audit"];

    }
    return _session1dict;
}
- (NSMutableDictionary *)session2Icons {
    if (!_session2Icons) {
        _session2Icons = [NSMutableDictionary dictionary];
    }
    return _session2Icons;
}
- (NSMutableArray *)session2dataArr {
    if (!_session2dataArr) {
        _session2dataArr = [NSMutableArray array];
    }
    return _session2dataArr;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-44) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1];
        
        [_tableView registerNib:[UINib nibWithNibName:cellid bundle:nil] forCellReuseIdentifier:cellid];
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    }else{
        return self.session2dataArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 32;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 32)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, 32)];
        label.text = @"联系人";
        label.textColor = [UIColor colorWithHexString:@"#666666"];
        label.font = [UIFont systemFontOfSize:16];
        [view addSubview:label];
        return view;
    }else{
        return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        cell.iconView.image = [UIImage imageNamed:self.session1icons[indexPath.row]];
        cell.titleLabel.text = self.session1titles[indexPath.row];
        if (indexPath.row == 0) {
            NSDictionary *dict = [self.session1dict objectForKey:@"order"];
            cell.contentLabel.text = [dict objectForKey:@"message"];
            NSString *time = [dict objectForKey:@"time"];
            if ([time isEqualToString:@"1"]) {
                cell.lastTimeLabel.text = @"";
            }else{
                cell.lastTimeLabel.text = time;
            }
        }
        if (indexPath.row == 1) {
            NSDictionary *dict = [self.session1dict objectForKey:@"system"];
            cell.contentLabel.text = [dict objectForKey:@"message"];
            NSString *time = [dict objectForKey:@"time"];
            if ([time isEqualToString:@"1"]) {
                cell.lastTimeLabel.text = @"";
            }else{
                cell.lastTimeLabel.text = time;
            }
        }
        if (indexPath.row == 2) {
            NSDictionary *dict = [self.session1dict objectForKey:@"pay"];
            cell.contentLabel.text = [dict objectForKey:@"message"];
            NSString *time = [dict objectForKey:@"time"];
            if ([time isEqualToString:@"1"]) {
                cell.lastTimeLabel.text = @"";
            }else{
                cell.lastTimeLabel.text = time;
            }
        }
        if (indexPath.row == 3) {
            NSDictionary *dict = [self.session1dict objectForKey:@"audit"];
            cell.contentLabel.text = [dict objectForKey:@"message"];
            NSString *time = [dict objectForKey:@"time"];
            if ([time isEqualToString:@"1"]) {
                cell.lastTimeLabel.text = @"";
            }else{
                cell.lastTimeLabel.text = time;
            }
        }
    }
    if (indexPath.section == 1) {
        EMConversation *conversation = [self.session2dataArr objectAtIndex:indexPath.row];
        cell.iconView.image = [UIImage imageNamed:@"组-16"];
        if (conversation.type == EMConversationTypeChat) {
//            if (self.session2Icons.count != 0) {
//                PersonalMessageModel *model = [self.session2Icons valueForKey:conversation.conversationId];
//                
//                if (model.userName.length != 0) {
//                    cell.titleLabel.text = model.userName;
//                    if (model.userImgUrl.length != 0) {
//                        NSString *urlString = [@"" stringByAppendingString:model.userImgUrl];
//                        [cell.iconView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"头像"]];//头像网络地址
//                    }
//                }
//            }
            
            if (conversation.latestMessage) {
                cell.titleLabel.text = [KDefcults objectForKey:conversation.conversationId];
                cell.contentLabel.text = [self _latestMessageTitleForConversation:conversation];
                cell.lastTimeLabel.text = [self _latestMessageTimeForConversation:conversation];
                
//                if (conversation.unreadMessagesCount == 0) {
//                    cell.unreadCountLabel.hidden = YES;
//                }else{
//                    cell.unreadCountLabel.text = [@([conversation unreadMessagesCount]) stringValue];
//                }
            }else{
                cell.titleLabel.text = @"";
                cell.contentLabel.text = @"";
                cell.lastTimeLabel.text = @"";
            }
        }
    }
    return cell;
}
// 最后信息
- (NSString *)_latestMessageTimeForConversation:(EMConversation *)conversation
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        double timeInterval = lastMessage.timestamp ;
        if(timeInterval > 140000000000) {
            timeInterval = timeInterval / 1000;
        }
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        latestMessageTime = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:timeInterval]];
    }
    return latestMessageTime;
}
// 最后时间
- (NSString *)_latestMessageTitleForConversation:(EMConversation *)conversation
{
    NSString *latestMessageTitle = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                latestMessageTitle = NSEaseLocalizedString(@"message.image1", @"[image]");
            } break;
            case EMMessageBodyTypeText:{
                NSString *didReceiveText = [EaseConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                latestMessageTitle = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                latestMessageTitle = NSEaseLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case EMMessageBodyTypeLocation: {
                latestMessageTitle = NSEaseLocalizedString(@"message.location1", @"[location]");
            } break;
            case EMMessageBodyTypeVideo: {
                latestMessageTitle = NSEaseLocalizedString(@"message.video1", @"[video]");
            } break;
            case EMMessageBodyTypeFile: {
                latestMessageTitle = NSEaseLocalizedString(@"message.file1", @"[file]");
            } break;
            default: {
            } break;
        }
    }
    return latestMessageTitle;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                OrderNotificationVC *orderVc = [[OrderNotificationVC alloc] init];
                orderVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:orderVc animated:YES];

            }
                break;
            case 1:
            {
                SystemNotificationVC *systemVc = [[SystemNotificationVC alloc] init];
                systemVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:systemVc animated:YES];

            }
                break;
            case 2:
            {
                PaymentAssistantVC *paymentVc = [[PaymentAssistantVC alloc] init];
                paymentVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:paymentVc animated:YES];

            }
                break;
            case 3:
            {
                AuditProgressVC *auditVc = [[AuditProgressVC alloc] init];
                auditVc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:auditVc animated:YES];

            }
                break;
            default:
                break;
        }
        
    }
    if (indexPath.section == 1) {
        EMConversation *conversation = [self.session2dataArr objectAtIndex:indexPath.row];
        ChatConversionVC *singleVC = [[ChatConversionVC alloc] initWithConversationChatter:conversation.conversationId conversationType:(EMConversationTypeChat)];
        singleVC.hidesBottomBarWhenPushed = YES;
        singleVC.userId = conversation.conversationId;
        singleVC.userName =  [KDefcults objectForKey:conversation.conversationId];
        // 动画效果
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        animation.timingFunction = UIViewAnimationTransitionNone;
//        animation.type = @"push";
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self.navigationController presentViewController:singleVC animated:YES completion:nil];
    }
}
// 侧滑删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete) {
        
        if (indexPath.section == 1) {
            EMConversation *conversation = [self.session2dataArr objectAtIndex:indexPath.row];
            
            [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:NO completion:^(NSString *aConversationId, EMError *aError) {
                [KDefcults removeObjectForKey:conversation.conversationId];
                NSArray *arr = [[[EMClient sharedClient].chatManager getAllConversations] mutableCopy];
                [self.session2dataArr removeAllObjects];
                // 只要单聊对话
                for (EMConversation *conversation in arr) {
                    if (conversation.type == EMConversationTypeChat) {
                        [self.session2dataArr addObject:conversation];
                    }
                }
                [self.tableView reloadData];
                
            }];
        }
    }
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
