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

#import "UIView+CWFrame.h"
#import "SqliteManager.h"

#import "CWPlayBackViewController.h"
#import "CWPresentationController.h"


#import <AVFoundation/AVFoundation.h>

static NSString * const CWTopicCellReuseID = @"CWTopicCellReuseID";

/** tabBar及titleView重复点击通知 */
UIKIT_EXTERN NSString * const CWTarBarButtonDidRepeatClicked;
UIKIT_EXTERN NSString * const CWTitleButtonDidRepeatClicked;
/** 播放按钮点击通知 */
UIKIT_EXTERN NSString * const CWVideoButtonDidClicked;

@interface CWTopicViewController () <NSURLSessionDataDelegate>

/** 存放【所有帖子】的模型数组 */
@property (strong, nonatomic) NSMutableArray<CWTopic *> *allTopics;
/** 网络请求管理者 */
@property (weak, nonatomic) CWHTTPSessionManager *manager;
/** 用来加载下一页数据的参数 */
@property (copy, nonatomic) NSString *maxtime;

/** AVPlayer */
@property (strong, nonatomic) AVPlayer *player;
@end

@implementation CWTopicViewController
/** 帖子类型 */
- (CWTopicType)topicType {
    return 0;
}

/** 请求参数a */
- (NSString *)parameterA {
    if ([self.parentViewController isKindOfClass: [CWNewViewController class]]) { // 新帖请求参数a
        return @"newlist";
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

- (NSMutableArray<CWTopic *> *)allTopics {
    if (_allTopics == nil) {
        _allTopics = [NSMutableArray array];
    }
    return  _allTopics;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置tableView
    [self setupTableView];
    
    // 添加刷新控件
    [self setupRefreshControl];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClicked) name:CWTarBarButtonDidRepeatClicked object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClicked) name:CWTitleButtonDidRepeatClicked object:nil];
    
    // 播放通知观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoButtonDidClickedNotification:) name:CWVideoButtonDidClicked object:nil];
    
    self.allTopics = [self getTopicsFromCacheWithMaxtime:self.maxtime type:self.topicType parameterA:self.parameterA];
    if (self.allTopics.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
//    [self.tableView reloadData];

}

#pragma mark - 通知
/** 播放通知 */
- (void)videoButtonDidClickedNotification:(NSNotification *)note {
    CWTopic *topic = note.userInfo[@"topic"];
    if (topic.videouri == nil) return;
    
//    NSURL *url = [NSURL URLWithString:topic.videouri];

    CWPlayBackViewController *vc = [[CWPlayBackViewController alloc] init];
    vc.playerLayer.frame = topic.centerViweFrame;
//    vc.preferredContentSize = topic.centerViweFrame.size;
//    vc.URL = url;
    
    // 转场控制器
//    vc.modalTransitionStyle = UIModalPresentationCurrentContext;
//    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self presentViewController:vc animated:YES completion:nil];
//    vc.URL = url;
    vc.view.frame = topic.centerViweFrame;
//    CWPresentationController *presentationVC = [[CWPresentationController alloc] initWithPresentedViewController:vc presentingViewController:self];
//    
//    vc.transitioningDelegate = presentationVC;
//    vc.modalPresentationStyle = UIModalPresentationCustom;
//    presentedVC.presentationController.overrideTraitCollection = [UITraitCollection traitCollectionWithDisplayScale: 1.5];
    vc.presentationController.overrideTraitCollection = [UITraitCollection traitCollectionWithDisplayScale: 0.5];
//    [self presentViewController:vc animated:NO completion:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController addChildViewController:vc];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:vc.view];
//     vc.URL = url;
    
    
}



- (void)tabBarButtonDidRepeatClicked {
    // 1.控制器的view不在窗口上直接返回
    if (self.view.window == nil) return;
    
    // 2.// 控制器的view在窗口上
    CGRect rect = [self.view convertRect:self.view.bounds toView:self.view.window];
    if (CGRectContainsRect(rect, self.view.window.bounds)) { // 2.1 view在window显示范围内
        [self.tableView.mj_header beginRefreshing];
    }else return; // 2.2 view在window显示范围内
}

- (void)titleButtonDidRepeatClicked {
    [self tabBarButtonDidRepeatClicked];
}

#pragma mark - UI handle
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.manager invalidateSessionCancelingTasks:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
//    [header beginRefreshing];
    
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
        CWWriteToPlist(responseObject, @"a");
        // 0.获取返回的maxtime
        NSString *maxtime = responseObject[@"info"][@"maxtime"];
        
        // 1.没有最新数据
        if ([maxtime isEqualToString:weakSelf.maxtime]) {
            // 结束上拉刷新
            [weakSelf.tableView.mj_header endRefreshing];
            
            // 开始数据返回提示器的动画
            [self startDataRetrieveIndicateLabelAnimalWithMessage:@"没有最新数据"];
      
            return ;
        }
        
        // 2.有最新数据
        // 保存maxtime
        weakSelf.maxtime = maxtime;
        
        // 缓存到数据库中
        [self cacheTopic:responseObject[@"list"] type:self.topicType a:self.parameterA];
        
        // 将JSON字典数组转成Topic模型数组
        weakSelf.allTopics = [CWTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 重载tableView数据
        [weakSelf.tableView reloadData];
        
        // 结束上拉刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
        // 数据返回提示器的显示和隐藏动画
        [self startDataRetrieveIndicateLabelAnimalWithMessage:[NSString stringWithFormat:@"获取到%zd条最新数据", weakSelf.allTopics.count]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf.tableView.mj_header endRefreshing];
//        [SVProgressHUD showErrorWithStatus:@"加载数据出错"];
        // 开始数据返回提示器的动画
        [self startDataRetrieveIndicateLabelAnimalWithMessage:@"没有最新数据或者网络问题"];
    }];
}

/** 下拉请求数据 */
- (void)loadMoreTopic {
    // 从缓存中加载数据
    self.allTopics = [self getTopicsFromCacheWithMaxtime:self.maxtime type:self.topicType parameterA:self.parameterA];
    if (self.allTopics.count > 0) {
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        return;
    }

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
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self cacheTopic:moreTopics type:self.topicType a:self.parameterA];
        });
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

/** 从sqlite中取数据 */
/**
 *  @{@"a": self.parameterA,
 @"c": @"data",
 @"type": @(self.topicType),
 @"maxtime": self.maxtime
 */
- (NSMutableArray *)getTopicsFromCacheWithMaxtime:(NSString *)maxtime type:(CWTopicType)type parameterA:(NSString *)a {

    NSString *sql;
    if (maxtime.integerValue == 0) {
        sql = [NSString stringWithFormat:@"SELECT topic, t FROM T_TOPIC WHERE t > %ld ORDER BY 't' ASC LIMIT 20;",maxtime.integerValue];
    }else {
        sql = [NSString stringWithFormat:@"SELECT topic, t FROM T_TOPIC WHERE t < %ld ORDER BY 't' ASC LIMIT 20;", maxtime.integerValue];
    }
    
    NSMutableArray *topicDictArray = [NSMutableArray array];
    [SqliteManager.manager.queue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
        
            FMResultSet *results = [db executeQuery:sql withArgumentsInArray:nil];
            NSError *error = nil;
            
            while ([results nextWithError:&error]) {
                NSString *topic = [results stringForColumn:@"topic"];
                
                NSData *data = [topic dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                [topicDictArray addObject:dict];
            }
        }
    }];
    
    NSMutableArray *topics = [CWTopic mj_objectArrayWithKeyValuesArray:topicDictArray];
    
    return topics;
}

- (void)cacheTopic:(NSArray *)topics type:(CWTopicType)type a:(NSString *)a {
    for ( NSDictionary *dictTopic in topics) {
        // 将服务器返回的JSON格式的每条topic字典转化为字符串。
        NSData *data = [NSJSONSerialization dataWithJSONObject:dictTopic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *topicText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSInteger t_interger = [dictTopic[@"t"] integerValue];
       NSNumber *t = [NSNumber numberWithInteger:t_interger];
        
        
        NSString *sql = @"INSERT INTO T_TOPIC (id, topic, t, type, a) values (?, ?, ?, ?, ?)";
        // 存入数据库表中
        [SqliteManager.manager.queue inDatabase:^(FMDatabase *db) {
            if (![db open]) {
                return ;
            }
            [db executeUpdate:sql withArgumentsInArray:@[dictTopic[@"id"], topicText, t, [NSNumber numberWithInteger:self.topicType], self.parameterA]];
        }];
       
        
    }
}

- (void)startDataRetrieveIndicateLabelAnimalWithMessage:(NSString *)message {
    /** 动画开始前显示的初始 */
    CGFloat initialY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    
    CWEssenceViewController *parentVc =  (CWEssenceViewController *)self.parentViewController;
    parentVc.dataRetrieveIndicateLabel.hidden = NO;
    parentVc.dataRetrieveIndicateLabel.text = message;
    
    // 数据返回提示器的显示和隐藏动画
    parentVc.dataRetrieveIndicateLabel.y = initialY;
    [UIView animateWithDuration:0.5 animations:^{
        parentVc.dataRetrieveIndicateLabel.y += 40;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.25 animations:^{
                parentVc.dataRetrieveIndicateLabel.y = initialY - parentVc.dataRetrieveIndicateLabel.height;
            } completion:^(BOOL finished) {
                parentVc.dataRetrieveIndicateLabel.hidden = YES;
            }];
        });
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
    return [self.allTopics[indexPath.row] cellHeight];
    
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