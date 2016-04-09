//
//  CWClearCacheCell.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/9.
//  Copyright © 2016年 cw. All rights reserved.
//

#import "CWClearCacheCell.h"
#import "NSString+FileSize.h"
/** 缓存路径 */
#define CWCacheFilePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"default"]

@implementation CWClearCacheCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 1.设置文字
        self.textLabel.text = @"清理缓存";
        
        // 2.设置右边的【loadingView】
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
         self.accessoryView = indicatorView;
        [indicatorView startAnimating];

        // 3.在子线程中计算缓存
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [queue addOperationWithBlock:^{
            
            // 4.计算缓存后获取更新后的文字
            NSString *cacheString = [self calculateCacheSize];
       
            // 5. 回到主线程更新文字和右边控件
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                // 切换右边的视图
                self.accessoryView = nil;
                self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                // 6. 更新文字
                self.textLabel.text = cacheString;
            }];
        }];
        
        // 4. 添加点击手势-> 触发清理缓存操作
        UITapGestureRecognizer *tabGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clearCache)];
        [self addGestureRecognizer:tabGesture];
    }
    return self;
}

- (void)clearCache {
//    if (self.accessoryView == nil) return;
    CWLog(@"%@", self.accessoryView);
    
    
        
}

/**
 * 计算文件的大小并转化成NSString格式返回
 */
- (NSString *)calculateCacheSize {
    unsigned long long fileSize = CWCacheFilePath.fileSize;
    
    double unit = 1000.0;
    
    if (fileSize >= pow(unit, 3)) { // GB
        return  [NSString stringWithFormat:@"清理缓存(%.2fGB)", fileSize / pow(unit, 3)];
    }else if (fileSize >= pow(unit, 2)) { // MB
        return  [NSString stringWithFormat:@"清理缓存(%.2fMB)", fileSize / pow(unit, 2)];
    }else if (fileSize >= unit) { // KB
        return  [NSString stringWithFormat:@"清理缓存(%.2fKB)", fileSize / unit];
    }else {
        return [NSString stringWithFormat:@"清理缓存(%zdB)",fileSize];
    }
}
@end
