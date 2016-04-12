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

static NSString * const CWAllTopicCellReuseID = @"CWAllTopicCellReuseID";

@interface CWAllTopicTableViewController ()
/** 存放【所有帖子】的模型数组 */
@property (strong, nonatomic) NSArray<CWTopic *> *allTopics;
@end

@implementation CWAllTopicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景颜色
    self.view.backgroundColor = CWCommonBgColor;
    
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CWAllTopicCell" bundle:nil] forCellReuseIdentifier:CWAllTopicCellReuseID];
    
    // cell 高度
    self.tableView.rowHeight = 150;
    
    // 请求数据
    [self loadTopic];
}

/** 请求数据 */
- (void)loadTopic {
    // 显示弹框
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    
    // 请求参数
    NSDictionary *dict = @{@"a": @"list",
                           @"c": @"data"
                          };
    
    __weak typeof(self) weakSelf = self;
    [[CWHTTPSessionManager manager] GET:CWRequestURL parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 将JSON字典数组转成Topic模型数组
        weakSelf.allTopics = [CWTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 隐藏弹框
        [SVProgressHUD dismiss];
        
        // 重载tableView数据
        [weakSelf.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载数据出错"];
        
        CWLog(@"CWAllTopicTableViewController Error = %@",error);
    }];
}


#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allTopics.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CWAllTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:CWAllTopicCellReuseID forIndexPath:indexPath];
    
    // 传递模型
    cell.topic = self.allTopics[indexPath.row];
    
    return cell;
}

@end