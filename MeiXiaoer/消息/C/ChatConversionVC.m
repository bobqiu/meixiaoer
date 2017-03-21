//
//  ChatConversionVC.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/25.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "ChatConversionVC.h"
#import "CustomerInputView.h"
#import "SingChatToolBarView.h"
#import "BaseViewController.h"


@interface ChatConversionVC ()<EaseMessageViewControllerDelegate, EMContactManagerDelegate, EaseMessageViewControllerDataSource, EaseChatBarMoreViewDelegate>

@property (nonatomic, strong) SingChatToolBarView *chatToolNavBar; /**< 头部nav */

@end


@implementation ChatConversionVC

//#pragma mark
//#pragma mark - 自定义cell
- (id<IMessageModel>)messageViewController:(EaseMessageViewController *)viewController
                           modelForMessage:(EMMessage *)message
{
    //用户可以根据自己的用户体系，根据message设置用户昵称和头像
    id<IMessageModel> model = nil;
    model = [[EaseMessageModel alloc] initWithMessage:message];
    model.avatarImage = [UIImage imageNamed:@"组-16"];//默认头像
    
    if (model.isSender) {// 发送者（我）
        if ([UserInfo getUserInfo].imgUrl.length>0) {
//            NSString *urlString = [IMAGE_HOST stringByAppendingString:[UserInfos sharedUser].userimgurl];
            model.avatarURLPath = [UserInfo getUserInfo].imgUrl;//头像网络地址
        }
        model.nickname = [UserInfo getUserInfo].nickName;//用户昵称
        
    }else{//对方
        model.nickname = self.userName;//用户昵称
        if (self.userIcon.length>0) {
            model.avatarURLPath = self.userIcon;//头像网络地址
        }
    }
    return model;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setChatUI];
    [KDefcults setObject:_userName forKey:_userId];
    // 数据代理
    self.dataSource = self;
    // 下拉刷新
    self.showRefreshFooter = YES;
}
- (SingChatToolBarView *)chatToolNavBar {
    if (!_chatToolNavBar) {
        _chatToolNavBar = [[SingChatToolBarView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
        XWeakSelf;
        _chatToolNavBar.backBlock = ^{
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        _chatToolNavBar.title = _userName;
    }
    return _chatToolNavBar;
}
- (void)setChatUI {
    [self.tableView reloadData];
    [self.view addSubview:self.chatToolNavBar];
    
    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"圆角矩形-3-发送"] stretchableImageWithLeftCapWidth:10 topCapHeight:28]];//设置发送气泡
    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"圆角矩形-3-接收"] stretchableImageWithLeftCapWidth:10 topCapHeight:28]];//设置接收气泡
    [[EaseBaseMessageCell appearance] setAvatarSize:44.f];//设置头像大小
    
    [[EaseBaseMessageCell appearance] setSendMessageVoiceAnimationImages:@[[UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_full"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_000"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_001"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_002"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_sender_audio_playing_003"]]];//发送者语音消息播放图片
    
    [[EaseBaseMessageCell appearance] setRecvMessageVoiceAnimationImages:@[[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing_full"],[UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing000"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing001"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing002"], [UIImage imageNamed:@"EaseUIResource.bundle/chat_receiver_audio_playing003"]]];//接收者语音消息播放图片

    self.chatBarMoreView.delegate = self;
    // 修改功能菜单
    // 删除
//    self.chatToolbar;
    self.chatBarMoreView.moreViewBackgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    // 按顺序删掉的
    [self.chatBarMoreView removeItematIndex:1];
    [self.chatBarMoreView removeItematIndex:3];
    [self.chatBarMoreView removeItematIndex:2];
    
    // 更改图片
    [self.chatBarMoreView updateItemWithImage:[UIImage imageNamed:@"矢量智能对象_77"] highlightedImage:[UIImage imageNamed:@"矢量智能对象_77"] title:@"相册" atIndex:0];
    [self.chatBarMoreView updateItemWithImage:[UIImage imageNamed:@"矢量智能对象"] highlightedImage:[UIImage imageNamed:@"矢量智能对象"] title:@"拍照" atIndex:1];
//    self.chatToolbar;
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
