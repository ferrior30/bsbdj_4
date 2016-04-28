//
//  CWEssenceViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/3/26.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWEssenceViewController.h"
#import "CWRecommandTagViewController.h"
#import "CWTitleButton.h"
#import "UIView+CWFrame.h"
#import "CWAllTopicTableViewController.h"
#import "CWVideoTableViewController.h"
#import "CWVoiceTableViewController.h"
#import "CWPictureTableViewController.h"
#import "CWWordTableViewController.h"

@interface CWEssenceViewController () <UIScrollViewDelegate>
/** 记录当前选中的title按钮 */
@property (weak, nonatomic) UIButton *selectTitleBtn;
/** titleView（由title按钮组成） */
@property (weak, nonatomic) UIView *titleView;
/** 指示器 */
@property (weak, nonatomic) UIView *indicateView;
/** 存放所有的子控制器的view */
@property (weak, nonatomic) UIScrollView *scrollView;

@end

@implementation CWEssenceViewController

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置导航栏
    [self setupNav];

    
    // 2.添加子控制器
    [self setupchildViewControllers];
    
    // 3.添加scrollViw（注：要放在标题buttons前面添加）
    [self setupScrollView];
    
    // 4.添加标题titleView
    [self setupTitleView];
}

/** 添加scrollView及选中默认选中的控制器的view */
- (void)setupScrollView {
    // 1. 添加scrollView
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
    
    // 设置代理
    scrollView.delegate = self;
    
    // 背景颜色
    scrollView.backgroundColor = CWCommonBgColor;
   
    // scrollView的frame和contentSize
    scrollView.frame = self.view.bounds;
    scrollView.contentSize = CGSizeMake(self.view.width * self.childViewControllers.count, self.view.height);
    
    // 设置滚动方向
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
   
    // 取消自动调整scrollView的contentSize。
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 2.给scrollView添加子选中控制器的view
    UITableViewController *childVC = self.childViewControllers[0];
    childVC.tableView.contentInset = UIEdgeInsetsMake(104, 0, 49, 0);
    childVC.tableView.scrollIndicatorInsets = childVC.tableView.contentInset;
    childVC.tableView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.scrollView addSubview:childVC.view];
}

/** 添加子控制器 */
- (void)setupchildViewControllers {
    // 全部
    CWAllTopicTableViewController *allTopicViewtroller = [[CWAllTopicTableViewController alloc] init];
    allTopicViewtroller.title = @"全部";
    [self addChildViewController:allTopicViewtroller];
    
    // 视频
    CWVideoTableViewController *videoTopicViewtroller = [[CWVideoTableViewController alloc] init];
    videoTopicViewtroller.title = @"视频";
    [self addChildViewController:videoTopicViewtroller];
    
    // 声音
    CWVoiceTableViewController *voiceTopicViewtroller = [[CWVoiceTableViewController alloc] init];
    voiceTopicViewtroller.title = @"声音";
    [self addChildViewController:voiceTopicViewtroller];
    
    // 图片
    CWPictureTableViewController *pictureTopicViewtroller = [[CWPictureTableViewController alloc] init];
   pictureTopicViewtroller.title = @"图片";
    [self addChildViewController:pictureTopicViewtroller];
    
    // 文字
    CWWordTableViewController *wordTopicViewtroller = [[CWWordTableViewController alloc] init];
    wordTopicViewtroller.title = @"文字";
    [self addChildViewController:wordTopicViewtroller];
    
}

/** 添加标题titleView */
- (void)setupTitleView {
    // 1.btnView：用来添加buttons。
    UIView *titleView = [[UIView alloc] init];
    self.titleView = titleView;
    titleView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    CGFloat viewHeight = 40;
    titleView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, viewHeight);

    [self.view addSubview:titleView];
    
    // 2.添加子控件buttons
    /// 标题文字数组
//    NSArray *titleArray = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    CGFloat btnW = [UIScreen mainScreen].bounds.size.width / 5;
    CGFloat btnH = viewHeight;
    CGFloat x = 0;
    CGFloat y = 0;
    for (NSInteger i = 0; i < 5; ++i) {
        CWTitleButton *btn = [[CWTitleButton alloc] init];
        
        //设置frame
        x = btnW * i;
        btn.frame = CGRectMake(x, y, btnW, btnH);
        
        // 设置按钮文字
        [btn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        // 设置tag
        btn.tag = i;
        
        // 监听点击事件
        [btn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
        
        // 添加到父控件中
        [titleView addSubview:btn];
    }
    
    // 默认选中第一个titleButton,并记录下来
    ((UIButton *)titleView.subviews.firstObject).selected = YES;
    self.selectTitleBtn = titleView.subviews.firstObject;
    
    // 3. 添加indicateView
    UIView *indicateView = [[UIView alloc] init];
    self.indicateView = indicateView;
    indicateView.backgroundColor = [self.selectTitleBtn titleColorForState:UIControlStateSelected];
    
    // 计算titleLabel的宽度
    [self.selectTitleBtn.titleLabel sizeToFit];
    
    indicateView.width = self.selectTitleBtn.titleLabel.bounds.size.width;
    indicateView.height = 1;
    indicateView.center = CGPointMake(self.selectTitleBtn.center.x, titleView.frame.size.height - 1);

    [titleView addSubview:indicateView];
}

/** 设置导航栏 */
- (void)setupNav {
    // 1.设置中间title
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    [self.navigationItem setTitleView:imageV];
    
    // 2.设置左边图标
    UIButton *btn = [[UIButton alloc] init];
    [btn sizeToFit];
    [btn setImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(MainTagSubIconClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.navigationItem setLeftBarButtonItem:btnItem];
}

#pragma mark - 监听事件
/** 监听标题button的点击: 1.滚动indicateView 2.添加scrollView的子控制器的view,并滚动到界面上 */
- (void)buttonDidClick:(UIButton *)button {
    if (self.selectTitleBtn == button) return;
    
    // 切换按钮的选中状态
    button.selected =  YES;
    self.selectTitleBtn.selected = NO;
    
    // 滚动indicateView
    [UIView animateWithDuration:0.25 animations:^{
        self.indicateView.width = button.titleLabel.width;
         self.indicateView.centerX = button.centerX;
    }];
    
    // 添加选中控制器的view
    UITableViewController *selectVC = self.childViewControllers[button.tag];
    if (![selectVC isViewLoaded]) { // 选中控制器的view没有加载过

        selectVC.tableView.frame = CGRectMake(self.view.width * button.tag, 0, self.view.width, self.view.height);
        selectVC.tableView.contentInset = UIEdgeInsetsMake(104, 0, 49, 0);
        selectVC.tableView.scrollIndicatorInsets = selectVC.tableView.contentInset;
        [self.scrollView addSubview:selectVC.view];
    }
    
    // 滚动scrollView
    [self.scrollView setContentOffset:CGPointMake(self.view.width * button.tag , self.scrollView.contentOffset.y) animated:YES];
    
    // 记录当前选中的button
    self.selectTitleBtn = button;
}
/**
 *  监听：导航栏左边按钮的点击
 */
- (void)MainTagSubIconClick {
    
    CWRecommandTagViewController *RecommandTagVC = [[CWRecommandTagViewController alloc] init];
    
    [self.navigationController pushViewController:RecommandTagVC animated:YES];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CWLog(@"%@", NSStringFromCGRect(self.childViewControllers.firstObject.view.frame) );
//}

#pragma mark - UISrollerViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = (NSInteger)scrollView.contentOffset.x / scrollView.width;
    [self buttonDidClick:self.titleView.subviews[index]];
}


@end
