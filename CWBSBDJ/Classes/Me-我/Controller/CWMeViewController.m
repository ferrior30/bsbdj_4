//
//  CWMeViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/26.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWMeViewController.h"
#import "CWSettingViewController.h"
#import "CWMeCell.h"
#import "UIView+CWFrame.h"
#import "CWMeFootView.h"
#import "AFNetworking.h"

/** 【我的】cell征用标识 */
static NSString * const CWMeCellID= @"CWMeCellID";

@interface CWMeViewController ()

@end

@implementation CWMeViewController
#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 2.设置tableView
    [self setupTableView];
    
    // 1.设置导航栏
    [self setupNav];
}
/**
 *  设置tableView
 */
- (void)setupTableView {
    
    [self.tableView registerClass:[CWMeCell class] forCellReuseIdentifier:CWMeCellID];
    
    self.tableView.backgroundColor = CWCommonBgColor;
    
    self.tableView.sectionFooterHeight = CWMargin;
    
    // 设置footView
    CWMeFootView *footView = [[CWMeFootView alloc] init];
    footView.frame = CGRectMake(footView.frame.origin.x, footView.frame.origin.y, footView.frame.size.width, 1700);
    self.tableView.tableFooterView = footView;
    
}

/**
 *  设置导航栏
 */
- (void)setupNav {
    // 1.设置中间title
    self.navigationItem.title = @"我的";
    
    // 2.设置右边图标
    UIButton *btn = [[UIButton alloc] init];
    [btn sizeToFit];
    [btn setImage:[UIImage imageNamed:@"mine-setting-icon"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"mine-setting-icon-click"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(mineSettingIconClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 sizeToFit];
    [btn2 setImage:[UIImage imageNamed:@"mine-moon-icon"] forState:UIControlStateNormal];
    [btn2 setImage:[UIImage imageNamed:@"mine-moon-icon-click"] forState:UIControlStateHighlighted];
    [btn2 addTarget:self action:@selector(mineMoonIconClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    [self.navigationItem setRightBarButtonItems:@[btnItem, btnItem2]];
}

#pragma mark - 监听
/** 监听【设置】按钮 */
- (void)mineSettingIconClick {
    CWSettingViewController *settingVC = [[CWSettingViewController alloc] init];
    settingVC.view.backgroundColor = CWRandomColor;
    
    [self.navigationController pushViewController:settingVC animated:YES];
    
    CWLogFunc;
}

/** 监听【月亮】按钮 */
- (void)mineMoonIconClick {
    CWLogFunc;
}

#pragma mark - tableView数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CWMeCell *cell = [tableView dequeueReusableCellWithIdentifier:CWMeCellID];
    
    if (cell == nil) {
        cell = [[CWMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CWMeCellID];
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"登录/注册";
        cell.imageView.image = [UIImage imageNamed:@"publish-audio"];
    } else {
        cell.textLabel.text = @"离线下载";
        cell.imageView.image = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CWLog(@"%f", tableView.sectionHeaderHeight);
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] init];
    v.backgroundColor = [UIColor blueColor];
//    return  [[UIView alloc] init];
    return  v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CWMargin;
    }else return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


@end
