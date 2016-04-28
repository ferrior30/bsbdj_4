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

/** categoryCell的重用标识*/
static NSString * const CWRecommendFollowCategoryCellID = @"CWRecommendFollowCategoryCellID";

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
@property (strong, nonatomic) NSArray *userArr;


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
    
    // contenInset
    self.usersTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    // 注册categoryCell
    [self.categoryTableView registerNib:[UINib nibWithNibName:@"CWRecommendFollowCategoryCell" bundle:nil] forCellReuseIdentifier:@"CWRecommendFollowCategoryCellID"];
    
    // 加载数据
    [self loadNewData];
}

- (void)loadNewData {
    NSDictionary *parameters = @{@"a": @"category", @"c": @"subscribe"};
    
    __block  typeof(self) weakSelf = self;
    [self.manager GET:CWRequestURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        // -> 分类模型数组
        CWWriteToPlist(responseObject, @"focusUsers");
        weakSelf.categoryArr = [CWRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 重载数据
        [weakSelf.categoryTableView reloadData];
        
        // 默认选中第一行
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [weakSelf.categoryTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"失败"];
    }];
    
    
    
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.categoryTableView) {
        return self.categoryArr.count;
//        return 4;
    }else {
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString * const CWRecommnedFollowUsersCellID = @"CWRecommnedFollowUsersCellID";
    if (tableView == self.categoryTableView) { // 分类
        CWRecommendFollowCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CWRecommendFollowCategoryCellID];
        
        
        cell.category = self.categoryArr[indexPath.row];
        
        return cell;
    }else { // 具体用户
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CWRecommnedFollowUsersCellID];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CWRecommnedFollowUsersCellID];
        }
        
        cell.textLabel.text = [NSString stringWithFormat:@"User=%zd",indexPath.row];
        
        return cell;
    }
}

@end
