//
//  CWRecommendFollowCategoryCell.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/28.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWRecommendFollowCategoryCell.h"
#import "CWRecommendCategory.h"

@interface CWRecommendFollowCategoryCell ()
/** 分类名字Label */
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
/** 选中指示器View */
@property (weak, nonatomic) IBOutlet UIView *selectedIndicateView;
@property (weak, nonatomic) UIView *indicateView;

@end

@implementation CWRecommendFollowCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // 为什么下面这句打开就不显示指示器。
//    [super setSelected:selected animated:animated];

    if (selected) {
        self.selectedIndicateView.hidden = NO;
        self.categoryLabel.textColor = [UIColor redColor];
    }else {
        self.selectedIndicateView.hidden = YES;
        self.categoryLabel.textColor = [UIColor lightGrayColor];
    }
}


- (void)setCategory:(CWRecommendCategory *)category {
    _category = category;
    
    self.categoryLabel.text = category.name;
}

@end
