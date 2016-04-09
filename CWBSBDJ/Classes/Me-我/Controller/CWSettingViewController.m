//
//  CWSettingViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/27.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWSettingViewController.h"
#import "CWClearCacheCell.h"
#import "CWSettingCell.h"

/** cell重用标识 */
static NSString * const CWMeClearCacheCellReuseID = @"CWMeClearCacheCellReuseID";
static NSString * const CWMeSettingCellReuseID = @"CWMeSettingCellReuseID";


@interface CWSettingViewController () <UITableViewDataSource>

@end

@implementation CWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景颜色
    self.view.backgroundColor = CWCommonBgColor;
    // 注册cell
    [self.tableView registerClass:[CWClearCacheCell class] forCellReuseIdentifier:CWMeClearCacheCellReuseID];
    [self.tableView registerClass:[CWSettingCell class] forCellReuseIdentifier:CWMeSettingCellReuseID];
    
    // 设置导航栏
    [self setupNav];
    
    // 设置tableView
    [self setupTableView];
    
}

- (void)setupTableView {
//    self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0);
    CWLog(@"%@", NSStringFromCGRect(self.tableView.bounds));
}

- (void)setupNav {
    // 1.设置标题
    self.navigationItem.title = @"设置";
}

#pragma makr - 监听
/** 点击返回按钮返回上一界面 */
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table view data source
/** 返回section中的row数 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return 4;
    }
}

/**
 * 返回tableView的section数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { // 第0组section
        CWClearCacheCell *cell = [tableView dequeueReusableCellWithIdentifier:CWMeClearCacheCellReuseID forIndexPath:indexPath];
        return cell;
    }else { // 第1组section
        CWSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:CWMeSettingCellReuseID forIndexPath:indexPath];
        cell.textLabel.text = [NSString stringWithFormat:@"设置%zd", indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    CWLog(@"%@", NSStringFromCGRect(cell.frame));
    if (indexPath.section == 0) { // 清理
        [self clearCache];
    }
    
}

#pragma mark- 内部方法
- (void)clearCache {
    
}

@end
