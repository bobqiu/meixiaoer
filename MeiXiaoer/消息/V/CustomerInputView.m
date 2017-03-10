//
//  CustomerInputView.m
//  MeiXiaoer
//
//  Created by 李祥起 on 2017/2/26.
//  Copyright © 2017年 wei. All rights reserved.
//

#import "CustomerInputView.h"

@interface CustomerInputView ()
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *line;
@property (weak, nonatomic) IBOutlet UIButton *beginRecodeBtn;

@end

@implementation CustomerInputView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self = (CustomerInputView *)[[[NSBundle mainBundle]loadNibNamed:@"CustomerInputView" owner:self options:nil] firstObject];
    }
    return self;
}
+ (instancetype)customView {
    return [[[NSBundle mainBundle]loadNibNamed:@"CustomerInputView" owner:self options:nil] firstObject];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    
}
- (IBAction)clickRecodeButtonAction:(UIButton *)sender {
    _beginRecodeBtn.hidden = !_beginRecodeBtn.hidden;
    _contentTextView.hidden = !_contentTextView.hidden;
    _line.hidden = !_line.hidden;
}
- (IBAction)clickMenumButtonAction:(UIButton *)sender {
}
- (IBAction)clickEnjoyFaceAction:(UIButton *)sender {
}
- (IBAction)clickBeginRecodeAction:(UIButton *)sender {
}


@end
