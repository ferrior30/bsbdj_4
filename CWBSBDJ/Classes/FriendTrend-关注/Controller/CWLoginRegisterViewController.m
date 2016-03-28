//
//  CWLoginRegisterViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/27.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWLoginRegisterViewController.h"

@interface CWLoginRegisterViewController ()
/** 根据是否有帐号切换界面的button */

/** 登陆整体左边的间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation CWLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 监听

/** 退出当前界面 */
- (IBAction)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 切换登陆和注册界面 */
- (IBAction)switchLoginRegister:(UIButton *)button {
    // 1.反转按钮的选中状态
    button.selected = !button.isSelected;
    
    // 2.修改约束
    self.leftMargin.constant = self.leftMargin.constant == 0 ? -self.view.bounds.size.width : 0;

    // 3.执行动画
    [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
    }];
}

@end
