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
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // 请求数据
    [self loadTopic];
}

/** 请求数据 */
- (void)loadTopic {
    // 显示弹框
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    
    // 请求参数
    NSDictionary *dict = @{@"a": @"list",
                           @"c": @"data"};
    
    __weak typeof(self) weakSelf = self;
    [[CWHTTPSessionManager manager] GET:CWRequestURL parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // 将JSON字典数组转成Topic模型数组
        weakSelf.allTopics = [CWTopic mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 隐藏弹框
        [SVProgressHUD dismiss];
        
        // 重载tableView数据
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载数据出错"];
        
        CWLog(@"CWAllTopicTableViewController Error = %@",error);
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%zd", indexPath.row];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

@end