//
//  CWTopicViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/27.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWTopicViewController.h"
#import "CWTopic.h"
#import "CWHTTPSessionManager.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "CWTopicCell.h"
#import "SVProgressHUD.H"
#import "CWNewViewController.h"
#import "CWCommentViewController.h"

static NSString * const CWTopicCellReuseID = @"CWTopicCellReuseID";

@interface CWTopicViewController ()

/** 存放【所有帖子】的模型数组 */
@property (strong, nonatomic) NSMutableArray<CWTopic *> *allTopics;
/** 网络请求管理者 */
@property (weak, nonatomic) CWHTTPSessionManager *manager;
/** 用来加载下一页数据的参数 */
@property (copy, nonatomic) NSString *maxtime;
@end

@implementation CWTopicViewController
/** 帖子类型 */
- (CWTopicType)topicType {
    return 0;
}

/** 请求参数a */
- (NSString *)parameterA {
    if ([self.parentViewController isKindOfClass: [CWNewViewController class]]) { // 新帖请求参数a
        return @"list";
    }else { // 精华请求参数a
        return @"list";
    }
}
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.manager invalidateSessionCancelingTasks:YES];
}

/** 设置tableView */
- (void)setupTableView {
    self.view.backgroundColor = CWCommonBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CWTopicCell" bundle:nil] forCellReuseIdentifier:CWTopicCellReuseID];
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
    NSDictionary *dict = @{@"a": self.parameterA,
                           @"c": @"data",
                           @"type": @(self.topicType)
                           };
    
    __weak typeof(self) weakSelf = self;
    [self.manager GET:CWRequestURL parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 记录maxtime
        weakSelf.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 将JSON字典数组转成Topic模型数组
        weakSelf.allTopics = [CWTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 重载tableView数据
        [weakSelf.tableView reloadData];
        
        // 结束上拉刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载数据出错"];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

/** 下拉请求数据 */
- (void)loadMoreTopic {
    //   // 用来记录请求后的maxtime
    //   __block  NSString *maxtime;
    
    // 请求参数
    NSDictionary *dict = @{@"a": self.parameterA,
                           @"c": @"data",
                           @"type": @(self.topicType),
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
    
    CWTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CWTopicCellReuseID];
    
    // 传递模型
    cell.topic = self.allTopics[indexPath.row];
    
    return cell;
}

/** cell的高度 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.allTopics[indexPath.row].cellHeight;
    
}


#pragma  mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 弹出评论控制器
    CWCommentViewController *commentVC = [[CWCommentViewController alloc]
                                          init];
    
    // 传递帖子id（用来请求评论数据）
    commentVC.data_id = self.allTopics[indexPath.row].id;
    
    // 传递cell,设置tableHeaderView
    CWTopic *topic = self.allTopics[indexPath.row];
    commentVC.topic = topic;
    
    [self.navigationController pushViewController:commentVC animated:YES];
    
}





@end