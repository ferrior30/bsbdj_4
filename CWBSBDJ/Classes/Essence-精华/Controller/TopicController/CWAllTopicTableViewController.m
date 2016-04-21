//
//  CWAllTopicTableViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/11.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWAllTopicTableViewController.h"
#import "CWHTTPSessionManager.h"
#import "SVProgressHUD.h"
#import "CWTopic.h"
#import "MJExtension.h"
#import "CWAllTopicCell.h"
#import "MJRefresh.h"

static NSString * const CWAllTopicCellReuseID = @"CWAllTopicCellReuseID";

@interface CWAllTopicTableViewController ()
/** 存放【所有帖子】的模型数组 */
@property (strong, nonatomic) NSMutableArray<CWTopic *> *allTopics;
/** 网络请求管理者 */
@property (weak, nonatomic) CWHTTPSessionManager *manager;
/** 用来加载下一页数据的参数 */
@property (copy, nonatomic) NSString *maxtime;
@end

@implementation CWAllTopicTableViewController
/** 懒加载网络请求管理者 */
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
    
    // 添加刷新控件
    [self setupRefreshControl];
    
}

/** 设置tableView */
- (void)setupTableView {
    self.view.backgroundColor = CWCommonBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CWAllTopicCell" bundle:nil] forCellReuseIdentifier:CWAllTopicCellReuseID];
}

/** 添加刷新控件 */
- (void)setupRefreshControl {
    // 下拉刷新
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewTopic];
    }];
    self.tableView.mj_header = header;
    header.automaticallyChangeAlpha = YES;
    [header beginRefreshing];
    
    // 上拉刷新
    MJRefreshAutoNormalFooter *foot = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopic)];
    self.tableView.mj_footer = foot;
}

/** 上拉请求数据 */
- (void)loadNewTopic {
    // 请求参数
    NSDictionary *dict = @{@"a": @"list",
                           @"c": @"data",
                           @"type": @"1"
                          };
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:CWRequestURL parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 将JSON字典数组转成Topic模型数组
        weakSelf.allTopics = [CWTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 重载tableView数据
        [weakSelf.tableView reloadData];
        
        // 结束上拉刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
        // 记录maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载数据出错"];
        [weakSelf.tableView.mj_header endRefreshing];
        CWLog(@"CWAllTopicTableViewController Error = %@",error);
    }];
}

/** 下拉请求数据 */
- (void)loadMoreTopic {
//   // 用来记录请求后的maxtime
//   __block  NSString *maxtime;
    
    // 请求参数
    NSDictionary *dict = @{@"a": @"list",
                           @"c": @"data",
                           @"type": @"1",
                           @"maxtime": self.maxtime
                           };
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:CWRequestURL parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 将JSON字典数组转成Topic模型数组
        NSArray *moreTopics = [CWTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
       
        //
        CWWriteToPlist(responseObject, @"hot");
        
        // 更新maxtime
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
       
        // 拼接topic
        [weakSelf.allTopics addObjectsFromArray:moreTopics];
        
        // 结束下拉刷新
        [weakSelf.tableView.mj_footer endRefreshing];
        
        // 重载tableView数据
        [weakSelf.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        [SVProgressHUD showErrorWithStatus:@"加载数据出错"];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.allTopics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CWAllTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CWAllTopicCellReuseID];
    
    // 传递模型
    cell.topic = self.allTopics[indexPath.row];
    
    return cell;
}

/** cell的高度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.allTopics[indexPath.row].cellHeight;

}

@end