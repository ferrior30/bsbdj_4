//
//  CWRecommendFollowViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/28.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWRecommendFollowViewController.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "CWHTTPSessionManager.h"
#import "CWRecommendFollowCategoryCell.h"
#import "CWRecommendCategory.h"
#import "CWRecommendUser.h"
#import "CWRecommendFollowUserCell.h"

/** Cell的重用标识*/
static NSString * const CWRecommendFollowCategoryCellID = @"CWRecommendFollowCategoryCellID";
/** cell重用 */
static NSString * const CWRecommendFollowUserCellID = @"CWRecommendFollowUserCellID";

@interface CWRecommendFollowViewController ()<UITableViewDelegate, UITableViewDataSource>
/** 分类 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 关注用户 */
@property (weak, nonatomic) IBOutlet UITableView *usersTableView;
/** 网络管理者 */
@property (strong, nonatomic) CWHTTPSessionManager *manager;
/** 【分类】数组 */
@property (strong, nonatomic) NSArray<CWRecommendCategory *> *categoryArr;
/** 【关注用户】数组 */
@property (strong, nonatomic) NSArray<CWRecommendUser *> *userArr;


@end


@implementation CWRecommendFollowViewController

#pragma mark - 懒加载
- (CWHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [CWHTTPSessionManager manager];
    }
    return _manager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = CWCommonBgColor;
    self.categoryTableView.backgroundColor = CWCommonBgColor;
    self.usersTableView.backgroundColor = CWCommonBgColor;
    
    self.navigationItem.title = @"推荐关注";
    
    // 设置代理和数据源对象
    self.categoryTableView.dataSource = self;
    self.categoryTableView.delegate = self;
    
    self.usersTableView.dataSource = self;
    self.usersTableView.delegate = self;
    self.usersTableView.rowHeight = 60;
    
    // contenInset
    self.usersTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    // 注册Cell
    [self.categoryTableView registerNib:[UINib nibWithNibName:@"CWRecommendFollowCategoryCell" bundle:nil] forCellReuseIdentifier:@"CWRecommendFollowCategoryCellID"];
    
    [self.usersTableView registerNib:[UINib nibWithNibName:@"CWRecommendFollowUserCell" bundle:nil] forCellReuseIdentifier:CWRecommendFollowUserCellID];
    
    // 加载数据
    [self loadCategory];
}

- (void)loadCategory {
    NSDictionary *parameters = @{@"a": @"category", @"c": @"subscribe"};
    
    __block  typeof(self) weakSelf = self;
    [self.manager GET:CWRequestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // -> 分类模型数组
        CWWriteToPlist(responseObject, @"focusUsers");
        weakSelf.categoryArr = [CWRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 重载数据
        [weakSelf.categoryTableView reloadData];
        
        // 默认选中第一行,
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.categoryTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        // 请求第一行的右侧数据
        [self tableView:self.categoryTableView didSelectRowAtIndexPath:indexPath];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"失败"];
    }];
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.categoryTableView) {
        return self.categoryArr.count;
    }else {
        return self.userArr.count;
//        return 20;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.categoryTableView) { // 创建【左边分类cell】
        CWRecommendFollowCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CWRecommendFollowCategoryCellID];

        cell.category = self.categoryArr[indexPath.row];
        
        return cell;
    }else { // 创建具体用户cell
        CWRecommendFollowUserCell *cell = [tableView dequeueReusableCellWithIdentifier:CWRecommendFollowUserCellID];
        
        cell.recommendUser = self.userArr[indexPath.row];
        
        return cell;
    }
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 请求前一次的请求
    [self.manager.tasks.firstObject cancel];

    //
//    if (self.manager.tasks.count) {
//    
//        [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
//    }
    
//    // 不能这样设置会出问题）因为此方法task为空会出问题
//    [self.manager invalidateSessionCancelingTasks:YES];
    
    if (tableView == self.categoryTableView) { // 选中左边分类cell，请求数据
        CWRecommendCategory *category = self.categoryArr[indexPath.row];
       
         // 显示“正在加载”指示器
         [SVProgressHUD showWithStatus:@"正在请求数据"];
        
        __weak typeof(self) weakSelf = self;
        
         // 请求参数
        NSDictionary *parameters = @{@"a": @"list", @"c": @"subscribe", @"category_id": @(category.id.intValue)};
        
        [self.manager GET:CWRequestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            CWWriteToPlist(responseObject, @"recommendFocusUsers");
            
            // 字典转模型
            weakSelf.userArr = [CWRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
            
            // 隐藏指示器
            [SVProgressHUD dismiss];
           
            // 刷新右侧用户数据
            [weakSelf.usersTableView reloadData];
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           // 显示错误信息
            [SVProgressHUD showErrorWithStatus:@"user=请求数据错误"];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
    
    [self.manager invalidateSessionCancelingTasks:YES];
}

@end
