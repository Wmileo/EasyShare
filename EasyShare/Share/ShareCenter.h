//
//  ShareCenter.h
//  EasyShare
//
//  Created by ileo on 16/2/2.
//  Copyright © 2016年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>


typedef NS_ENUM(NSInteger, Share_Platform){
    Share_WX_Session = 1,
    Share_WX_Timeline = 2,
    Share_QQ = 3,
    Share_QZone = 4,
};

@class ShareURLModel;

@interface ShareCenter : NSObject

//单例
+(instancetype)sharedInstance;
-(void)configHandles:(NSArray *)handles;
-(BOOL)handleOpenURL:(NSURL *)url;
-(void)shareURL:(ShareURLModel *)model withPlatform:(Share_Platform)platform;

@end

#pragma mark - 分享模型

@interface ShareURLModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *shareURL;

@end

#pragma mark - 分享平台
@protocol ShareHandle <NSObject>
-(BOOL)handleOpenURL:(NSURL *)url;
-(NSArray *)handlePlatforms;
-(NSString *)handleURLPrefix;
-(void)shareURL:(ShareURLModel *)model withPlatform:(Share_Platform)platform;
@end

@interface WXHandle : NSObject <WXApiDelegate,ShareHandle>
+(instancetype)handleWithAppID:(NSString *)appID;
@property (nonatomic, copy) void (^OnReq)(BaseReq *req);
@property (nonatomic, copy) void (^OnResp)(BaseResp *resp);
@end

@interface QQHandle : NSObject <QQApiInterfaceDelegate,ShareHandle>
+(instancetype)handleWithAppID:(NSString *)appID;
@property (nonatomic, copy) void (^OnReq)(QQBaseReq *req);
@property (nonatomic, copy) void (^OnResp)(QQBaseResp *resp);
@property (nonatomic, copy) void (^IsOnlineResponse)(NSDictionary *response);
@end