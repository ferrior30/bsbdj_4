//
//  CWLoginRegisterViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/27.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWLoginRegisterViewController.h"
#import "CWFastLoginRegisterButton.h"

@interface CWLoginRegisterViewController ()
/** 根据是否有帐号切换界面的button */

/** 登陆整体左边的间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMargin;

@end

@implementation CWLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/** 设置状态栏样式 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - 监听
/** 退出当前界面 */
- (IBAction)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 切换登陆和注册界面 */
- (IBAction)switchLoginRegister:(UIButton *)button {
    // 1.设置按钮的选中状态
    button.selected = !button.isSelected;
    
    // 2.修改约束
    self.leftMargin.constant = self.leftMargin.constant == 0 ? -self.view.bounds.size.width : 0;

    // 3.执行动画
    [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
    }];
    
    [self.view endEditing:YES];
}

- (IBAction)qqLogin:(CWFastLoginRegisterButton *)sender {
    CWLogFunc;
}

/** 退下键盘 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
