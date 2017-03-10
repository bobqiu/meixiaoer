//
//  WebViewViewController.m
//  MeiXiaoer
//
//  Created by lihaiwei on 2016/10/11.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "WebViewViewController.h"
#import "UMSocialUIManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import <UMSocialCore/UMSocialCore.h>
#import <AFNetworking/AFNetworking.h>
#import "Order.h"
#import "DataSigner.h"
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Map/BMKMapView.h>
#import "AppDelegate.h"
#import "MyKeychain.h"
#import "GenralCheck.h"
#import <WebKit/WebKit.h>

#import "BuyTabBarController.h"
#import "ChatConversionVC.h"
#import "MessageViewController.h"

//应用尺寸
#define APP_WIDTH [[UIScreen mainScreen]applicationFrame].size.width
//获取相对屏幕的宽度。
#define GET_LENGTH_OF_SCREEN_WIDTH(i) APP_WIDTH*(1.0*(i)/750.0f)
#define R5(i) APP_WIDTH*(1.0*(i)/320.0f)
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
@interface WebViewViewController ()<WKNavigationDelegate,WKUIDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate,UIWebViewDelegate>
{
    BOOL isRegiste;
}
@property (nonatomic, assign) BOOL isText;
@property (nonatomic, assign) BOOL isTitle;
@property (nonatomic, assign) BOOL isUrl;
@property (nonatomic, assign) int mediastyle;
@property(nonatomic,strong)NSMutableDictionary *postDic;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *receiveJSMethod;
@property(strong,nonatomic)UIWebView *ceWebView;
@property(strong,nonatomic)BMKLocationService *locService;
@property(strong,nonatomic)BMKMapView *mapView;
@property(strong,nonatomic)NSString *totol;
@property(strong,nonatomic)NSString *subject;
@property(strong,nonatomic)NSString *orderId;
@property(assign,nonatomic)CGFloat latitude;
@property(assign,nonatomic)CGFloat longitude;
@property(strong,nonatomic)NSString *content;
@property(strong,nonatomic)NSString *imgUrl;
@property(strong,nonatomic)NSString *shareTitle;
@property(strong,nonatomic)NSString *url;
@property(strong,nonatomic)UIWebView *cWebView;
@property(strong,nonatomic)NSString *authOS;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, assign) NSUInteger loadCount;
@property(nonatomic,strong)NSString *shareType;
@property(strong,nonatomic)WKWebView *webView;

@end
@implementation WebViewViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isRegiste = NO;
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"first"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first"];
        NSLog(@"首次启动");
        self.urlString = @"http://mxe-pc.fh25.com/app/index.html";

    }else {
        if ([[KDefcults objectForKey:MeixiaoerType] isEqualToString:Buy]) {
            self.urlString = @"http://mxe-pc.fh25.com/app/buy.html";
        }else{
            self.urlString = @"http://mxe-pc.fh25.com/app/sell.html";
        }
    }
    if (self.webView == nil) {
        WKWebViewConfiguration *config = [WKWebViewConfiguration new];
        config.websiteDataStore = [WKWebsiteDataStore defaultDataStore];
        WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, R5(15), R5(320), R5(555))configuration:config];
        [webView setAllowsBackForwardNavigationGestures:YES];
        [self.view addSubview:webView];
        webView.navigationDelegate = self;
        webView.UIDelegate = self;
        self.webView = webView;
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUrl:) name:@"URLSTRING" object:nil];
}
- (void)loadUrl:(NSNotification *)notification{
    NSLog(@"url--%@", notification.userInfo[@"url"]);
    self.urlString = notification.userInfo[@"url"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];

}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
}
//拦截URL
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    
    NSString *urlstr = navigationAction.request.URL.absoluteString;
    NSLog(@"urlstr-------%@",urlstr);
    
    if ([urlstr isEqualToString:@"http://mxe-pc.fh25.com/app/message.html"] || [urlstr isEqualToString:@"http://mxe-pc.fh25.com/app/messegeqiye.html"]) {
        // 切换根视图控制器
        self.view.window.rootViewController = [[BuyTabBarController alloc] init];

        [self showTabBar];
        [self.tabBarController setSelectedIndex:2];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    // 去卖煤，通知切换卖煤/买煤模式
    if ([urlstr isEqualToString:@"http://mxe-pc.fh25.com/app/sell.html"]) {
//        NSLog(@"去卖煤");
        [KDefcults setObject:Sell forKey:MeixiaoerType];
        [KDefcults synchronize];
        
        BuyTabBarController *buyTabbar = (BuyTabBarController *)self.tabBarController;
        [buyTabbar changeTabbar];
    }
    if ([urlstr isEqualToString:@"http://mxe-pc.fh25.com/app/buy.html"]){
//        NSLog(@"去买煤");
        [KDefcults setObject:Buy forKey:MeixiaoerType];
        [KDefcults synchronize];
        BuyTabBarController *buyTabbar = (BuyTabBarController *)self.tabBarController;
        [buyTabbar changeTabbar];
    }
    
    
    if ([urlstr isEqualToString:@"http://mxe-pc.fh25.com/app/buy.html"]||[urlstr isEqualToString:@"http://mxe-pc.fh25.com/app/index.html"]) {
        UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, R5(320), R5(16))];
        blankView.backgroundColor = RGBA(255, 198, 0, 1);
        [self.view addSubview:blankView];
    }
    
    NSString *tmp = [urlstr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self encodeToPercentEscapeString:tmp];
    
    NSRange nativeRange = [tmp rangeOfString:@"app://"];
    if (nativeRange.length != 0) {
        NSString *JSRequest = [tmp substringFromIndex:(nativeRange.location+nativeRange.length)];
        
        [self doForJSRequest:JSRequest];
    }
    NSRange telRange = [tmp rangeOfString:@"tel://"];
    if (telRange.length !=0) {
        NSString *JSrequest = [tmp substringFromIndex:(telRange.location + telRange.length)];
        [self callTel:JSrequest];
    }
    
    // 拦截登录
    NSRange loginRange = [tmp rangeOfString:@"logins://"];
    if (loginRange.length != 0) {
        
        NSString *JSRequest = [tmp substringFromIndex:14];
        NSData *jsonData = [JSRequest dataUsingEncoding:NSUTF8StringEncoding];//转化为data
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];//转化为字典
        NSLog(@"%@", data);
        [self getUSerInfoWithData:data];
    }
    // 拦截聊天
    NSRange talkRange = [tmp rangeOfString:@"talk://"];
    if (talkRange.length != 0) {
        
        NSInteger lengtn = [tmp length];
        NSRange telRange = [tmp rangeOfString:@"tel:"];
        NSRange rangew = [tmp rangeOfString:@","];
        NSString *ID = [tmp substringWithRange:NSMakeRange(telRange.location + 4, rangew.location - (telRange.location + 4))];
        NSRange nameRange = [tmp rangeOfString:@"name:"];
        NSString *name = [tmp substringWithRange:NSMakeRange(nameRange.location + 5, lengtn - (nameRange.location + 5)-1)];
        
        CATransition *animation = [CATransition animation];
        animation.duration = 0.3;
        animation.timingFunction = UIViewAnimationTransitionNone;
        //animation.type = @"push";
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromRight;
        
        [self.view.window.layer addAnimation:animation forKey:nil];
        ChatConversionVC *singleVC = [[ChatConversionVC alloc] initWithConversationChatter:ID conversationType:(EMConversationTypeChat)];
        singleVC.hidesBottomBarWhenPushed = YES;
        singleVC.userId = ID;
        singleVC.userName = name;
        [self presentViewController:singleVC animated:YES completion:nil];

        decisionHandler(WKNavigationActionPolicyCancel);

    }

    if (navigationAction.navigationType == WKNavigationTypeBackForward) {
        /*
         问题原因: jquery的ready事件,在返回上一页面时,上一页面不会触发.
         解决方案:
         1.不要使用匿名函数,给$() 赋值,应约定一个公共的名字,如myReadyFunc,赋给 $(myReadyFunc),然后ios拦截
         事件,延迟调用一次 myReadyFunc 方法即可.
         2.将需要返回上一界面时,需要刷新上一页面由后一个界面的的url和刷新方法,列出来,延迟手动调用.
         
         推荐方法一,方法二,可临时用来解决问题.
         */
        /* 方案一:客户端只需要要调用一次 myReadyFunc 方法即可,不必每次都修改native代码. */
        //        NSString * jsSyncMethod = @"myReadyFunc()";
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [webView evaluateJavaScript:jsSyncMethod completionHandler:^(id _Nullable info, NSError * _Nullable error) {
        //                NSLog(@"myReadyFunc info:%@ error:%@",info, error);
        //            }];
        //        });
        
        /* 方法二:不需要改动前端代码,但是需要为有需要的界面单独设置.页面有需要从后一个页面获取数据的情况,不多的话,可以使用. */
        /* 链接,可以从 ebView.backForwardList.currentItem.initialURL 获取, js取值代码,可以从html文件的底部 $() 方法中获取,只找出其中可能和从缓存中取值的片段即可,双引号最好都变成单引号.*/
        NSDictionary * backSyncDict = @{
                                        @"http://mxe-pc.fh25.com/app/gqfabu.html":@"(function(){notLoginSoRedirect();fbStore.showAll();do{var is_loc_use=locStore.getItem('use');var loc=locStore.getItem('loc');if(is_loc_use===null){break}if(is_loc_use==1){break}$('#address').val(loc)}while(false);locStore.setNull();SupplyAdd.setFormName('#fbForm');SupplyAdd.setValidate();$('#backBTn').click(function(){fbStore.clearAll();window.history.go(-1)})})()",// 卖煤页.
                                        @"http://mxe-pc.fh25.com/app/myinfo.html": @"UpdateInfo.setFormName('#basicForm');MyInfo.show();",// 个人信息页.
                                        
                                        };
        NSString * urlStr = webView.backForwardList.currentItem.initialURL.absoluteString;
        NSString * jsSyncMethod = [backSyncDict objectForKey:urlStr];
        if (jsSyncMethod) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [webView evaluateJavaScript:jsSyncMethod completionHandler:^(id _Nullable info, NSError * _Nullable error) {
                    NSLog(@"myReadyFunc info:%@ error:%@",info, error);
                }];
            });
        }
    }
    //这句是必须加上的，不然会异常
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)getUSerInfoWithData:(NSDictionary *)data {
    UserInfo *userinfo = [UserInfo getUserInfo];
    userinfo.token = [data objectForKey:@"token"];
    userinfo.name = [[data objectForKey:@"data"] objectForKey:@"name"];
    userinfo.ID = [[[data objectForKey:@"data"] objectForKey:@"id"] stringValue];
    userinfo.imgUrl = [[data objectForKey:@"data"] objectForKey:@"imgUrl"];
    
    userinfo.nickName = [[data objectForKey:@"data"] objectForKey:@"nickName"];
    userinfo.category = [[data objectForKey:@"data"] objectForKey:@"category"];
    userinfo.tel = [[data objectForKey:@"data"] objectForKey:@"tel"];
    userinfo.passWord = [[data objectForKey:@"data"] objectForKey:@"passWord"];
    if ([[KDefcults objectForKey:MeixiaoerType] isEqualToString:Buy]) {
        self.urlString = @"http://mxe-pc.fh25.com/app/buy.html";
    }else{
        self.urlString = @"http://mxe-pc.fh25.com/app/sell.html";
    }
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    [self loginHuanxinWithId:userinfo.ID];
}
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];  
    
    if(err) {  
        
        NSLog(@"json解析失败：%@",err);  
        
        return nil;  
        
    }
    return dic;
}
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    WKFrameInfo *frameInfo = navigationAction.targetFrame;
    if (![frameInfo isMainFrame]) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}


-(void)callTel:(NSString *)telnumber
{
    NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"tel:%@",telnumber];
    [[UIApplication  sharedApplication]openURL:[NSURL URLWithString:str]];
}
- (void)doForJSRequest:(NSString *)JSRequest {
    NSInteger qLocation = [JSRequest rangeOfString:@"?"].location;
    NSString *flag = [JSRequest substringToIndex:qLocation];
    NSString *paramString = [JSRequest substringFromIndex: qLocation + 1];
    NSArray *parameterPairs =[paramString componentsSeparatedByString:@"&"];
    NSMutableDictionary *paramsDic = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
    for (NSString *currentPair in parameterPairs) {
        NSRange range = [currentPair rangeOfString:@"="];
        if(range.location == NSNotFound)
            continue;
        NSString *key = [currentPair substringToIndex:range.location];
        NSString *value =[currentPair substringFromIndex:range.location + 1];
        [paramsDic setObject:value forKey:key];
    }
    if ( ! [flag isEqualToString:@"native"]) {
        return;
    }
    if ([paramsDic objectForKey:@"method"] == nil) {
        return;
    }
    
    NSString *jsonString = [paramsDic objectForKey:@"param"];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *paramDict = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err] : nil;
    NSLog(@"传入的参数是: %@",paramDict);
    NSString *tokenString =  [paramDict objectForKey:@"token"];
    NSString *JSMethod = [paramDict objectForKey:@"jsMethod"];
    self.receiveJSMethod = JSMethod;
    self.token = tokenString;
    self.totol = [paramDict objectForKey:@"total_fee"];
    self.subject = [paramDict objectForKey:@"subject"];
    self.orderId = [paramDict objectForKey:@"orderId"];
    self.shareTitle = [paramDict objectForKey:@"title"];
    self.content = [paramDict objectForKey:@"content"];
    self.url = [paramDict objectForKey:@"url"];
    self.imgUrl = [paramDict objectForKey:@"imgUrl"];
    self.shareType = [paramDict objectForKey:@"shareType"];
    
    
    if ([[paramsDic objectForKey:@"method"] isEqualToString: @"goToShare"]) {
        [self shareBtnClick:nil];
    }
    if ([[paramsDic objectForKey:@"method"] isEqualToString: @"goToWeiXinLogin"]) {
        [self isWXAppInstalled];
        [self login:@"wechat"];
    }
    
    if ([[paramsDic objectForKey:@"method"] isEqualToString: @"goToQQLogin"]) {
        [self login:@"qq"];
    }
    
    if ([[paramsDic objectForKey:@"method"] isEqualToString: @"goToWeiXinPay"]) {
        [self WXPayClick:nil];
    }
    
    if ([[paramsDic objectForKey:@"method"] isEqualToString: @"goToZhiFuBaoPay"]) {
        [self isWXAppInstalled];
        
        [self zhiPayClick:nil];
    }
    if ([[paramsDic objectForKey:@"method"] isEqualToString: @"openPhotoAlbum"]) {
        [self openPhotoAlbum:nil];
    } if ([[paramsDic objectForKey:@"method"] isEqualToString: @"takePhoto"]) {
        [self takePhoto:nil];
    }if ([[paramsDic objectForKey:@"method"] isEqualToString: @"gotoLocation"]) {
        
        [self gotoLocationClick:nil];
    }
    
    
}

-(void)shareBtnClick:(id)sender
{

    if ([self.shareType isEqualToString:@"0"]) {
        [self shareDataWithPlatform:UMSocialPlatformType_WechatSession];

    }else if ([self.shareType isEqualToString:@"1"])
    {
        [self shareDataWithPlatform:UMSocialPlatformType_WechatTimeLine];
    }else if ([self.shareType isEqualToString:@"2"])
    {
        [self shareDataWithPlatform: UMSocialPlatformType_QQ];

    }else if ([self.shareType isEqualToString:@"3"])
    {
        [self shareDataWithPlatform:UMSocialPlatformType_Qzone];
    }
}

//创建分享内容对象
- (UMSocialMessageObject *)creatMessageObject
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    NSString *title = self.shareTitle?:@"";
    NSString *url = self.url?:@"";
    NSString *text = self.content?:@"";
    UIImage *image = [UIImage imageNamed:self.imgUrl?:@""];
    if (self.isText) {
        //纯文本分享
        messageObject.text = text;
    }
    // !!!: 临时测试.
    self.mediastyle = 0;
    self.isUrl = YES;
    switch (self.mediastyle) {
        case 0:
            if (self.isUrl) {//创建网页分享内容对象
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:text thumImage:self.imgUrl];
                [shareObject setWebpageUrl:url];
                messageObject.shareObject = shareObject;
            }
            break;
        case 1:
        {
            //创建图片对象
            UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:title descr:text thumImage:image];
            [shareObject setShareImage:self.imgUrl];
            messageObject.shareObject = shareObject;

        }
            break;
    
        default:
            break;
    }
    return messageObject;
}

//直接分享
- (void)shareDataWithPlatform:(UMSocialPlatformType)platformType
{
    UMSocialMessageObject *messageObject = [self creatMessageObject];
    
    // !!!: 临时测试.
    //    messageObject.text = @"text";
    //    messageObject.shareObject = nil;
    //
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        NSString *message = nil;
        if (!error) {
            message = [NSString stringWithFormat:@"分享成功"];
        }
        else{
            if (error) {
                message = [NSString stringWithFormat:@"失败原因Code: %d\n",(int)error.code];
            }
            else{
                message = [NSString stringWithFormat:@"分享失败"];
            }
        }

    }];
    
    
}

#pragma mark - 支付

-(void)zhiPayClick:(id)sender
{
    NSString *result;
    [self aliPay:result];
    
}
-(void)WXPayClick:(id)sender
{
    [self isWXAppInstalled];
    [self pay];
}


- (BOOL)isWXAppInstalled
{
    // 1.判断是否安装微信
    if (![WXApi isWXAppInstalled]) {
        
        UIAlertView *mAlert = [[UIAlertView alloc] initWithTitle:@"安装微信" message:@"目前您的微信版本过低或未安装微信"delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [mAlert show];
        return NO;
    }
    return YES;
    
    
}
-(void)pay
{
    NSString *URLString =[NSString stringWithFormat:@"http://mxe.fh25.com/api/paywechat/wechatpay?id=%@",self.orderId];
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            // 注册App支付 回调的block.
            AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.wechatcompletionBlock = ^(NSString * strMsg){
                NSString *code;
                NSLog(@"reslut = %@",strMsg);
                
                if ([strMsg isEqualToString:@"支付结果:成功"]) {
                    code = @"1";
                    //进入列表页面
                    NSLog(@"支付成功");
                    
                }else
                {
                    code = @"2";
                    NSLog(@"支付失败");
                }
                NSString *type = @"1";
                
                NSDictionary * paramsDict = @{
                                              @"type":type?:@"",
                                              @"code":code?:@"",
                                              };
                NSString * paramsJSONStr = [[self class]  dictionaryToJson: paramsDict];
                
                NSString * js = [NSString stringWithFormat:@"%@(JSON.stringify(%@))",@"payResult",paramsJSONStr];
                [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable info, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"js login error:%@", error);
                    }else
                    {
                        NSLog(@"js login info: %@", info);
                    }
                }];
            };
            if (responseObject != nil) {
                NSDictionary *result = [responseObject objectForKey:@"sign_array"];
                PayReq *req = [[PayReq alloc]init];
                req.partnerId =[result objectForKey:@"partnerid"];
                req.prepayId = [result objectForKey:@"prepayid"];
                req.package  = [result objectForKey:@"package"];
                req.nonceStr = [result objectForKey:@"noncestr"];
                req.timeStamp = [[result objectForKey:@"timestamp"]   intValue];
                req.sign = [responseObject objectForKey:@"sign_two"];
                [WXApi sendReq:req];
            }
            
        }
    }];
    [dataTask resume];
}


- (void)aliPay:(NSString *)orderString {
    
    
    NSString *URLString =[NSString stringWithFormat:@"http://mxe.fh25.com/api/pay/pay?id=%@",self.orderId];
    
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET" URLString:URLString parameters:nil error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            __block NSString *orderString;
            orderString = [responseObject objectForKey:@"jsonalipay"];
            NSString *appScheme = @"zhifubaoPay";
            
            // NOTE: 调用支付结果开始支付
            // 注册App支付 回调的block.
            AppDelegate * appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            appDelegate.alipaycompletionBlock = ^(NSDictionary * resultDic){
                NSString *code;
                NSLog(@"reslut = %@",resultDic);
                if ([resultDic[@"resultStatus"] intValue]==9000) {
                    code = @"1";
                    //进入列表页面
                    NSLog(@"支付成功");
                    
                }
                else{
                    code = @"2";
                    NSString *resultMes = resultDic[@"memo"];
                    resultMes = (resultMes.length<=0?@"支付失败":resultMes);
                    NSLog(@"%@",resultMes);
                }
                
                NSString *type = @"1";
                
                NSDictionary * paramsDict = @{
                                              @"type":type?:@"",
                                              @"code":code?:@"",
                                              };
                NSString * paramsJSONStr = [[self class]  dictionaryToJson: paramsDict];
                
                NSString * js = [NSString stringWithFormat:@"%@(JSON.stringify(%@))",@"payResult",paramsJSONStr];
                
                [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable info, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"js login error:%@", error);
                    }else
                    {
                        NSLog(@"js login info: %@", info);
                    }
                }];
            };
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
                
                NSString *code;
                NSLog(@"reslut = %@",resultDic);
                if ([resultDic[@"resultStatus"] intValue]==9000) {
                    code = @"1";
                    //进入列表页面
                    NSLog(@"支付成功");
                }
                else{
                    code = @"2";
                    NSString *resultMes = resultDic[@"memo"];
                    resultMes = (resultMes.length<=0?@"支付失败":resultMes);
                    NSLog(@"%@",resultMes);
                }
                
                NSString *type = @"1";
                
                NSDictionary * paramsDict = @{
                                              @"type": type?: @"",
                                              @"code":code?:@"",
                                              };
                NSString * paramsJSONStr = [[self class]  dictionaryToJson: paramsDict];
                
                NSString * js = [NSString stringWithFormat:@"%@(JSON.stringify(%@))",@"payResult",paramsJSONStr];
                NSLog(@"js:%@",js);
                
                
                [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable info, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"js login error:%@", error);
                        
                    }else
                    {
                        NSLog(@"js login info: %@", info);
                        
                    }
                }];
                
                
                
            }];
            
        }
    }];
    [dataTask resume];
}



- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma mark - 第三方登录
//需要传入参数 accessToken,openid
- (void)login:(NSString *)platform
{
    NSDictionary * platformDict = @{@"qq":@(UMSocialPlatformType_QQ),
                                    @"wechat":@(UMSocialPlatformType_WechatSession),
                                    };
    UMSocialPlatformType platformType = [[platformDict objectForKey:platform] integerValue];
    //在授权登录里面可以获取openid
    
    [[UMSocialManager defaultManager]  authWithPlatform:platformType currentViewController:nil completion:^(id result, NSError *error)
     {
         UMSocialAuthResponse *authresponse = result;
         NSString *status = @"1";
         NSString *category;
         if ([platform isEqualToString:@"wechat"] ) {
             category = @"2";
         }else
         {
             category = @"1";
         }
         NSString *accessToken = authresponse.accessToken;
         NSString *openid = authresponse.openid;
         
         NSLog(@"openid = %@",openid);
         NSDictionary * paramsDict = @{
                                       @"openId": openid?:@"",
                                       @"accessToken":accessToken?:@"",
                                       @"category": category?:@"",
                                       @"os":self.authOS?:@"1",
                                       @"status": status?:@"",
                                       };
         NSString * paramsJSONStr = [[self class]  dictionaryToJson: paramsDict];
         
         NSString * js = [NSString stringWithFormat:@"%@(JSON.stringify(%@))",self.receiveJSMethod?:@"",paramsJSONStr];
         NSLog(@"js:%@",js);
         [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable info, NSError * _Nullable error) {
             if (error) {
                 NSLog(@"js login error:%@", error);
             }else
             {
                 NSLog(@"js login info: %@", info);
             }
         }];
     }];
}

#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"系统提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
}
- (void)openPhotoAlbum:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)takePhoto:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *selectImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *imageData = UIImageJPEGRepresentation(selectImage, 0.5);
    if ( ! imageData){
        imageData =  UIImagePNGRepresentation(selectImage);
    }
    
    
    NSString *encodedImageStr = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *URLString = [NSString stringWithFormat:@"http://mxe.fh25.com/api/user/uploadimgbase?token=%@",self.token];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    NSURLRequest *request = [serializer requestWithMethod:@"POST" URLString:URLString parameters:@{@"base":encodedImageStr} error:nil];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            
            
            NSString *urlshow =[responseObject objectForKey:@"urlshow"];
            NSString * js = [NSString stringWithFormat:@"%@('%@')",self.receiveJSMethod?:@"",urlshow?:@""];
            [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable info, NSError * _Nullable error) {
                if (error) {
                    NSLog(@"js login error:%@", error);
                    
                }else
                {
                    NSLog(@"js login info: %@", info);
                    
                }
            }];
            
            
        }
    }];
    [dataTask resume];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



-(void)gotoLocationClick:(BMKUserLocation *)userLocation
{
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.distanceFilter = 10.0f;//大于10米
    
    //启动LocationService
    [_locService startUserLocationService];
    //普通态
    //以下_mapView为BMKMapView对象
    self.mapView.showsUserLocation = YES;//显示定位图层
    self.mapView.delegate = self;
    NSDictionary * paramsDict = @{
                                  @"latitude": @(self.latitude ?: 40.038620),
                                  @"longitude":@(self.longitude ?: 116.350417),
                                  };
    NSString * paramsJSONStr = [[self class]  dictionaryToJson: paramsDict];
    
    NSString * js = [NSString stringWithFormat:@"%@(JSON.stringify(%@))",self.receiveJSMethod?:@"",paramsJSONStr];
    NSLog(@"js000:%@",js);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable info, NSError * _Nullable error) {
            if (error) {
                NSLog(@"js login error:%@", error);
                
            }else
            {
                NSLog(@"js login info: %@", info);
                
            }
        }];
    });
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    
    NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
    [_mapView updateLocationData:userLocation];
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
        
        
    }
    
    
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    return dic;
    
}
//webView加载的URL中不可以有中文符号，解决办法就是将中文符号转码
- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    NSString *outputStr = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                       NULL,
                                                                                       (__bridge CFStringRef)input,
                                                                                       NULL,
                                                                                       (CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8);
    return outputStr;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    NSLog(@" %s,change = %@",__FUNCTION__,change);
    if ([keyPath isEqual: @"estimatedProgress"] && object == _webView) {
        isRegiste = YES;
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:_webView.estimatedProgress animated:YES];
        if(_webView.estimatedProgress >= 1.0f)
        {
            [UIView animateWithDuration:0.1 delay:0.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}
//移除观察者
- (void)dealloc {
    if (isRegiste) {
        [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"URLSTRING" object:nil];
    // if you have set either WKWebView delegate also set these to nil here
    [_webView setNavigationDelegate:nil];
    [_webView setUIDelegate:nil];
}
@end
