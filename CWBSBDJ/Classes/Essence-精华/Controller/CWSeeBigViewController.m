//
//  CWSeeBigViewController.m
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/26.
//  Copyright © 2016年 CW. All rights reserved.
//

#import "CWSeeBigViewController.h"
#import "UIView+CWFrame.h"
#import "CWTopic.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import <Photos/Photos.h>
#import "SVProgressHUD.h"

@interface CWSeeBigViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) UIImageView *imageView;
@end

@implementation CWSeeBigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加UIScrollview
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [self.view insertSubview:scrollView atIndex:0];
    scrollView.delegate = self;
//    scrollView.frame = self.view.bounds;
    scrollView.frame = [UIScreen mainScreen].bounds;
    
    // imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.width = scrollView.width;
    imageView.height = self.topic.height * imageView.width  / self.topic.width;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image]];
    
    imageView.x = 0;
    if (imageView.height >= scrollView.height ) { // 图片高度超过整个屏幕，图片y = 0;
        imageView.y = 0;
    }else { //否则居中显示
        imageView.centerY = scrollView.centerY;
    }
    
    // 将imageV添加到scrollView中
    [scrollView addSubview:imageView];
    self.imageView = imageView;
    
    // 滚动范围
    scrollView.contentSize = CGSizeMake(0, imageView.height);
    
    // 如果比原图小则设置放大比例
    CGFloat maxScale = self.topic.height / imageView.height;
    if (maxScale > 1) {
        scrollView.maximumZoomScale = maxScale;
    }
}

/** 退出大图控制器 */
- (IBAction)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/** 保存图片 */
- (IBAction)save {
   
    // 相机访问状态
    PHAuthorizationStatus state = [PHPhotoLibrary authorizationStatus];
    
     // 判断状态
    if (state == PHAuthorizationStatusDenied) { // 拒绝访问相机
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"“百思不得姐”被拒绝相册访问" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"设置相册访问权限" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CWLog(@"设置允许访问相机");
          [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
              if (state == PHAuthorizationStatusAuthorized) {
                  CWLog(@"允许访问");
              }else {
                 CWLog(@"拒绝访问");
              }
          }];
            
            NSURL *url = [NSURL URLWithString:@"prefs:root=chenwei.CWBSBDJ"];
            if ([[UIApplication sharedApplication] canOpenURL:url])
                {
                [[UIApplication sharedApplication] openURL:url];
                }
        }];
        [alert addAction:action];
        
        UIAlertAction *cancelAction= [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else if (state == PHAuthorizationStatusNotDetermined) { // 用户没有做出选择
        CWLog(@"用户没有作出选择");
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (state == PHAuthorizationStatusAuthorized) {
                CWLog(@"允许访问相册");
            }else {
                CWLog(@"拒绝访问相册");
            }
        }];
    }else if (state == PHAuthorizationStatusRestricted) { // 家长控制模式--不允许访问
        CWLog(@"家长控制模式--不允许访问")
    }else if (state == PHAuthorizationStatusAuthorized) { // 允许访问
        [self saveImage];
    }
}


/**
 *
 *  @return 返回相册（没有则创建并返回）
 */
/** 相册名字 */
static NSString * const CWCollectionTitle = @"百思不得姐";
- (PHAssetCollection *)collection {
    // 1.若相册之前已经创建
    PHFetchResult<PHAssetCollection *> *fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *collection in fetchResult) {
        if ([collection.localizedTitle isEqualToString:CWCollectionTitle]) {
            CWLog(@"百思不得姐=%@", collection.localIdentifier);
            
            return collection;
        }
    }
    
    // 2.如果相册没有创建：创建相册
    __block NSString *collectID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        collectID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:CWCollectionTitle].placeholderForCreatedAssetCollection.localIdentifier;
        
        CWLog(@"collectID=%@", collectID);
        
    } error:nil];
    
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[collectID] options:nil].firstObject;
    
}

/** 保存图片 */
- (void)saveImage {
    // 保存图片到相机胶卷
//    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

    __block NSString *assetID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        // // 新建一个PHAssetCreationRequest对象, 保存图片到"相机胶卷"
      assetID = [PHAssetCreationRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        if (error) {
            CWLog(@"保存到相机胶卷失败");
        }
        
         CWLog(@"保存到相机胶卷成功");
        
        // 获得相册对象
        PHAssetCollection *collection = [self collection];
        
        //　保存【相机胶卷】中的图片到【相册】中
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetCollectionChangeRequest *changeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:collection];
            // 取得图片
            PHAsset *asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil].firstObject;
            
            // 添加图片到相册中
            [changeRequest addAssets:@[asset]];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (error) {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [SVProgressHUD showSuccessWithStatus:@"保存失败"];
                }];
            }else {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                }];
            }
        }];
        
    }];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}

@end
