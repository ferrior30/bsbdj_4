//
//  CWCommentViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/30.
//  Copyright © 2016年 CW. All rights reserved.
//
// 评论控制器

#import "CWCommentViewController.h"
#import "CWHTTPSessionManager.h"
#import "SVProgressHUD.H"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "CWComment.h"
#import "CWTopic.h"

#import "UIView+CWFrame.h"

#import "CWTopicViewController.h"
#import "CWTopicVideoView.h"
#import "CWTopicVoiceView.h"
#import "CWTopicPictureView.h"
#import "CWTopicCell.h"
#import "CWCommentCell.h"
#import "CWCommentHeaderCell.h"

@interface CWCommentViewController ()<UITableViewDataSource, UITableViewDelegate>

/** 网络请求管理者 */
@property (weak, nonatomic) CWHTTPSessionManager *manager;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 最热评论 */
@property (copy, nonatomic) NSArray<CWComment *> *hotComments;
/** 最新评论 */
@property (strong, nonatomic) NSMutableArray<CWComment *> *latestComments;
/** 保存topic模型top_cmt数据 */
@property (copy, nonatomic) NSArray<CWComment *> *top_cmt;

@end

@implementation CWCommentViewController
#pragma mark - 懒加载
- (CWHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [CWHTTPSessionManager manager];
    }
    return _manager;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView
    [self setupTableView];
}

- (void)dealloc {
    // 隐藏指示器
    [SVProgressHUD dismiss];
    
    // 如果有最热评论，将最热评论数据还原
    if (self.top_cmt.count) {
        self.topic.top_cmt = self.top_cmt;
        
        // 重新讲得cell高度
        self.topic.cellHeight = 0;
    }
}

#pragma mark - 设置tableViw
- (void)setupTableView {
    // 设置title
    self.navigationItem.title = @"评论";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    
    // 设置头部视图
    [self setupTableHeadView];
    
    // 注册评论cell
    [self.tableView registerNib:[UINib nibWithNibName:@"CWCommentCell" bundle:nil] forCellReuseIdentifier:CWCommentCellID];
    
    // 上拉刷新控件
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    [header beginRefreshing];
    self.tableView.mj_header = header;
    
    // 下拉刷新控件
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

/** 设置tableHeaderView */
static NSString * const CWCommentCellID = @"CWCommentCellID";
- (void)setupTableHeadView {
    // 处理模型数据
    if (self.topic.top_cmt.count) {
        self.top_cmt = self.topic.top_cmt;
    
        // 去掉最热评论label
        self.topic.top_cmt = nil;
        
        // cell 重新计算高度
        self.topic.cellHeight = 0;
    }
    
    // 创建头部cell
//    CWTopicCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CWTopicCell class]) owner:nil options:nil].firstObject;
    CWTopicCell *cell = [CWTopicCell topicCell];
    cell.topic = self.topic;
    
    cell.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, cell.topic.cellHeight);
    
    UIView *headView = [[UIView alloc] init];
    headView.backgroundColor = CWCommonBgColor;
    [headView addSubview:cell];
    headView.height = cell.height + 2 * CWMargin;
    
    self.tableView.tableHeaderView = headView;
    

}

#pragma  mark - 网络请求
/**
 *  上拉刷新
 */
- (void)loadNewData {
    // 请求参数
    NSDictionary *parameters = @{@"a": @"dataList",
                                 @"c": @"comment",
                                 @"data_id": self.data_id,
                                 @"hot": @1};
    
    __block typeof(self) weakSelf = self;
    
    [self.manager GET:CWRequestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CWWriteToPlist(responseObject, @"commendList");
       
        // 没有评论数据
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            return ;
        }
      
        // 如果没有更多数据（全部评论数据都返回完毕）
        NSInteger total = [responseObject[@"total"] integerValue];
        if (weakSelf.latestComments.count == total) {
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            // 显示提示
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"没有更新的数据了" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [weakSelf.navigationController presentViewController:alertVc animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVc dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            
            return;
        }

        // 最新评论
        weakSelf.latestComments = [CWComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        // 最热评论
        weakSelf.hotComments = [CWComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        [weakSelf.tableView reloadData];
        
        // 隐藏上拉刷新控件
        [weakSelf.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载评论数据错误"];
        
        // 隐藏上拉刷新控件
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

/**
 *  下拉刷新
 */
- (void)loadMoreData {
    // 请求参数
    NSDictionary *parameters = @{@"a": @"dataList",
                                 @"c": @"comment",
                                 @"data_id": self.data_id,
                                 @"hot": @1,
                                 @"lastcid": self.latestComments.lastObject.id};
    
    __block typeof(self) weakSelf = self;
    
    [self.manager GET:CWRequestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        CWWriteToPlist(responseObject, @"commendListNextPage");

        // 没有更多数据
        NSInteger total = [responseObject[@"total"] integerValue];
        if (weakSelf.latestComments.count == total) {
            // 结束刷新
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            // 显示提示
            UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"没有更新的数据了" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [weakSelf.navigationController presentViewController:alertVc animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [alertVc dismissViewControllerAnimated:YES completion:nil];
                });
            }];
            
            return;
        }
        
        // 有更多评论数据
        NSArray *nextComment= [CWComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        
        //  拼接评论数据
        [weakSelf.latestComments addObjectsFromArray:nextComment];
        
        // 刷新表格
        [weakSelf.tableView reloadData];
    
        // 隐藏下拉刷新控件
        [weakSelf.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载评论数据错误"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.top_cmt.count) { // 有最热评论
        return 2;
    }else return 1; // 没有最热评论
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.top_cmt.count) { // 有最热评论
        if (section == 0) {
            return self.top_cmt.count;
        }else return self.latestComments.count;
    }else { // 没有最热评论
        return self.latestComments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CWCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CWCommentCellID];

    if (self.top_cmt.count) { // 有最热评论
        if (indexPath.section == 0) { // 第 0 section
           cell.comment = self.top_cmt[indexPath.row];
        }else { // 第 1 section
            cell.comment = self.latestComments[indexPath.row];
        }
    }else { // 没有最热评论
        cell.comment = self.latestComments[indexPath.row];
    }

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.top_cmt.count) { // 有最热评论
        if (section == 0) {
            return @"最热评论";
        }else {
            return @"最新评论";
        }
    }else { // 没有最热评论
        return @"最新评论";
    }
}

#pragma mark - UITableViewDelegate
@end
