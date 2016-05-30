//
//  CWTopic.h
//  CWBSBDJ
//
//  Created by ChenWei on 16/4/11.
//  Copyright © 2016年 CW. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CWComment;

/** 枚举：帖子类型 */
//typedef enum CWTopicType {
//    CWTopicTypeAllTopic,
//    CWTopicTypeVideo,
//    CWTopicTypeVoice,
//    CWTopicTypePicture,
//    CWTopicTypeWord
//};
typedef NS_ENUM(NSInteger, CWTopicType){
    /** 全部 */
    CWTopicTypeAllTopic = 1,
   
    /** 视频 */
    CWTopicTypeVideo = 41,
    
    /** 声音 */
    CWTopicTypeVoice = 31,
    
    /** 图片 */
    CWTopicTypePicture = 10,
    
    /** 段子 */
    CWTopicTypeWord = 29
};

@interface CWTopic : NSObject
// 用户 -- 发帖者
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子id */
@property (copy, nonatomic) NSString *id;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *created_at;
/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/** 最热评论 */
@property (copy, nonatomic) NSArray<CWComment *> *top_cmt;
/** 帖子类型 */
//@property (assign, nonatomic) enum CWTopicType topicType;
@property (assign, nonatomic) CWTopicType type;

/** 图片的宽度 */
@property (nonatomic, assign) CGFloat width;
/** 图片的高度 */
@property (nonatomic, assign) CGFloat height;
/** 小图 */
@property (nonatomic, copy) NSString *small_image;
/** 中图 */
@property (nonatomic, copy) NSString *middle_image;
/** 大图 */
@property (nonatomic, copy) NSString *large_image;
/** 是否为动态图 */
@property (nonatomic, assign) BOOL is_gif;

/** 播放数量 */
@property (nonatomic, assign) NSInteger playcount;
/** 声音文件的长度 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频文件的长度 */
@property (nonatomic, assign) NSInteger videotime;
/** 视频文件的url */
@property (copy, nonatomic) NSString *videouri;

/* 辅助属性 */
/** 中间控件的frame */
@property (assign, nonatomic) CGRect centerViweFrame;
/** cell的高度 */
@property (assign, nonatomic) CGFloat cellHeight;
/** 是否是大图 */
@property (assign, nonatomic) BOOL isBigPicture;

@end
