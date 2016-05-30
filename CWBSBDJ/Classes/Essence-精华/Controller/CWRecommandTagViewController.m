//
//  CWRecommandTagViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/29.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWRecommandTagViewController.h"
#import "CWRecommandTagCell.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "CWRecommandTag.h"
#import "SVProgressHUD.h"
#import "CWHTTPSessionManager.h"
#import "MJRefresh.h"


/** cell的重用标识 */
static NSString * const CWRecommandTagCellID = @"CWRecommandTagCellID";
@interface CWRecommandTagViewController ()
/** 网络请求管理者 */
@property (weak, nonatomic) CWHTTPSessionManager *manager;
@end

@implementation CWRecommandTagViewController

- (CWHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [CWHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView
    [self setupTableView];
    
    // 设置刷新控件
    [self setupRefreshControl];
    
    
}

/** 设置刷新控件 */
- (void)setupRefreshControl {
    // 下拉刷新
    MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 加载新tag
        [self loadNewRecommendTag];
    }];
    [normalHeader beginRefreshing];
    normalHeader.automaticallyChangeAlpha = YES;
    self.tableView.mj_header = normalHeader;
    
//    // 上拉刷新
//    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreRecommendTag)];
    
//    self.tableView.mj_footer = footer;
}

/** 设置tableView */
- (void)setupTableView {
    self.title = @"推荐标签";
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = CWCommonBgColor;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"CWRecommandTagCell" bundle:nil] forCellReuseIdentifier:CWRecommandTagCellID];
}

/** 上拉加载最新标签数据 */
- (void)loadNewRecommendTag {
    // 弱引用
    __weak typeof(self) weakSelf = self;
    
    // 弹框
//    [SVProgressHUD show];
    
    // 请求参数
    NSDictionary *params = @{@"a": @"tag_recommend",
                             @"action": @"sub",
                             @"c": @"topic"};
    // 发送请求
    [self.manager GET:CWRequestURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) { // 请求成功
        
        CWWriteToPlist(responseObject, @"recommendTag");
        
        // 字典数组转模型数组
        weakSelf.recommandTags = [CWRecommandTag mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 隐藏弹框
//        [SVProgressHUD dismiss];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { // 请求失败
        if (error.code == NSURLErrorCancelled) return ;
        
        // 显示【错误信息】弹框
        [SVProgressHUD showErrorWithStatus:@"获取标签数据失败" ];
        
        [self.tableView.mj_header endRefreshing];
    }];
}

/** 下拉加载更多标签数据 */
 - (void)loadMoreRecommendTag {
    // 弱引用
    __weak typeof(self) weakSelf = self;
    
    // 弹框
    [SVProgressHUD show];
    
    // 请求参数
    NSDictionary *params = @{@"a": @"tag_recommend",
                             @"action": @"sub",
                             @"c": @"topic"};
    // 发送请求
    [self.manager GET:CWRequestURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) { // 请求成功
        
        // 字典数组转模型数组
        weakSelf.recommandTags = [CWRecommandTag mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 隐藏弹框
        [SVProgressHUD dismiss];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { // 请求失败
        if (error.code == NSURLErrorCancelled) return ;
        
        // 显示【错误信息】弹框
        [SVProgressHUD showErrorWithStatus:@"获取标签数据失败" ];
        
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
    // 取消网络请求
    [self.manager invalidateSessionCancelingTasks:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.recommandTags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CWRecommandTagCell *cell = [tableView dequeueReusableCellWithIdentifier:CWRecommandTagCellID];
    
    // 传递模型
    cell.recommandTag = self.recommandTags[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end