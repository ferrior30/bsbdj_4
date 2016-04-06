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


/** cell的重用标识 */
static NSString * const CWRecommandTagCellID = @"CWRecommandTagCellID";
@interface CWRecommandTagViewController ()
/** 网络请求管理者 */
@property (weak, nonatomic) AFHTTPSessionManager *manager;
@end

@implementation CWRecommandTagViewController

- (AFHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"推荐标签";
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = CWCommonBgColor;
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"CWRecommandTagCell" bundle:nil] forCellReuseIdentifier:CWRecommandTagCellID];
    // 加载标签数据
    [self loadRecommendTag];
}

/** 加载标签数据 */
- (void)loadRecommendTag {
    // 弱引用
    __weak typeof(self) weakSelf = self;
    
    // 弹框
    [SVProgressHUD show];
    
    // 请求参数
    NSDictionary *params = @{@"a": @"tag_recommend",
                             @"action": @"sub",
                             @"c": @"topic"};
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        // 发送请求
        [self.manager GET:CWRequestURL parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) { // 请求成功
            // 字典数组转模型数组
            weakSelf.recommandTags = [CWRecommandTag mj_objectArrayWithKeyValuesArray:responseObject];
            
            // 隐藏弹框
            [SVProgressHUD dismiss];
            
            // 刷新表格
            [weakSelf.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { // 请求失败
            if (error.code == NSURLErrorCancelled) return ;
            
            // 显示【错误信息】弹框
            [SVProgressHUD showErrorWithStatus:@"获取标签数据失败" ];
        }];
//    });
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 隐藏弹框
    [SVProgressHUD dismiss];
    
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