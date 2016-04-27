//
//  CWVideoTableViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/11.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWVideoTableViewController.h"
#import "CWHTTPSessionManager.h"
@interface CWVideoTableViewController ()
/** 网络请求管理者 */
@property (weak, nonatomic) CWHTTPSessionManager *manager;
@end

@implementation CWVideoTableViewController
/** 懒加载网络请求管理者 */
- (CWHTTPSessionManager *)manager {
    if (_manager == nil) {
        _manager = [CWHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 背景颜色
    self.view.backgroundColor = CWCommonBgColor;
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    CWLog(@"%s",__func__);
    
    CWLog(@"video%@", self.manager);
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
    
    cell.textLabel.text = [NSString stringWithFormat:@"2--%zd", indexPath.row];
    
    return cell;
}

@end