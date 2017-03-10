//
//  GuideViewController.m
//  MeiXiaoer
//
//  Created by lihaiwei on 2016/12/2.
//  Copyright © 2016年 wei. All rights reserved.
//

#import "GuideViewController.h"
#import "WebViewViewController.h"

#import "BuyTabBarController.h"


#define WIDTH (NSInteger)self.view.bounds.size.width
#define HEIGHT (NSInteger)self.view.bounds.size.height
#define Width [UIScreen mainScreen].bounds.size.width/320.0
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define Height [UIScreen mainScreen].bounds.size.height/568.0

@interface GuideViewController ()<UIScrollViewDelegate>
{
    // 创建页码控制器
    UIPageControl *pageControl;
  
}


@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIScrollView *myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    for (int i=0; i<4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"guide_%d.png",i+1]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * i, 0, WIDTH, HEIGHT)];
        // 在最后一页创建按钮
        if (i == 3) {
            // 必须设置用户交互 否则按键无法操作
            imageView.userInteractionEnabled = YES;
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(90*Width, 480*Height,140*Width, HEIGHT / 16);
            [button setTitle:@"立即体验" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:18];
            button.backgroundColor = RGBA(42, 42, 55, 0.5);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.cornerRadius = 5;
            button.clipsToBounds = YES;
            [button addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:button];
        }
        imageView.image = image;
        [myScrollView addSubview:imageView];
    }
    myScrollView.bounces = NO;
    myScrollView.pagingEnabled = YES;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.contentSize = CGSizeMake(WIDTH * 4, HEIGHT);
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    
   // pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(WIDTH / 3, HEIGHT * 15 / 16, WIDTH / 3, HEIGHT / 16)];
    // 设置页数
   // pageControl.numberOfPages = 3;
    // 设置页码的点的颜色
    //pageControl.pageIndicatorTintColor = [UIColor yellowColor];
    // 设置当前页码的点颜色
    //pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    
   // [self.view addSubview:pageControl];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 计算当前在第几页
    pageControl.currentPage = (NSInteger)(scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width);
}

// 点击按钮保存数据并切换根视图控制器
- (void) go:(UIButton *)sender{
    NSUserDefaults *useDef = [NSUserDefaults standardUserDefaults];
    // 保存用户数据
    [useDef setBool:YES forKey:@"GuideViewController"];
    [useDef synchronize];
    // 切换根视图控制器
    self.view.window.rootViewController = [[WebViewViewController alloc] init];
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


