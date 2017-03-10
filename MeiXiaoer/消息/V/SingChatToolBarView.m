//
//  SingChatToolBarView.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/3/4.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "SingChatToolBarView.h"

@interface SingChatToolBarView ()

@property (nonatomic, strong) UIImageView *backImgView; /**< 背景 */

@property (nonatomic, strong) UIButton *backbtn; /**< 返回按钮 */

@property (nonatomic, strong) UILabel *titleLabel; /**< 标题 */

@end
@implementation SingChatToolBarView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self addSubview:_backImgView];
        [self addSubview:self.backbtn];
        [self addSubview:self.titleLabel];
        self.backgroundColor = [UIColor colorWithHexString:@"#FCC52E"];
    }
    return self;
}
- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((WIDTH - 150) / 2, 20, WIDTH - 150, 30)];
        _titleLabel.text = @"掌柜的";
        _titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}
- (UIImageView *)backImgView {
    if (!_backImgView) {
        _backImgView = [[UIImageView alloc] initWithFrame:self.frame];
        _backImgView.image = [UIImage imageNamed:@"bg"];
        _backImgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImgView;
}
- (UIButton *)backbtn {
    if (!_backbtn) {
        
        _backbtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        _backbtn.frame = CGRectMake(10, 20, 30, 30);
        [_backbtn setImage:[UIImage imageNamed:@"返回"] forState:(UIControlStateNormal)];
        [_backbtn setContentMode:(UIViewContentModeCenter)];
        [_backbtn addTarget:self action:@selector(clickBackBtnAction) forControlEvents:(UIControlEventTouchDown)];
    }
    return _backbtn;
}
- (void)clickBackBtnAction {
    if (_backBlock) {
        _backBlock();
    }
}
@end
