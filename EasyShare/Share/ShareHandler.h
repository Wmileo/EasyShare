//
//  ShareHandler.h
//  EasyShare
//
//  Created by ileo on 16/2/4.
//  Copyright © 2016年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "ShareModel.h"

typedef NS_ENUM(NSInteger, Share_Platform){
    Share_WX_Session = 1,
    Share_WX_Timeline = 2,
    Share_QQ = 3,
    Share_QZone = 4,
};

@protocol ShareHandle <NSObject>
-(BOOL)handleOpenURL:(NSURL *)url;
-(NSArray *)handlePlatforms;
-(NSString *)handleURLPrefix;
-(void)shareURL:(ShareURLModel *)model withPlatform:(Share_Platform)platform callback:(void (^)(BOOL isSuccess))callback;
@end

@interface WXHandler : NSObject <WXApiDelegate,ShareHandle>
+(instancetype)handleWithAppID:(NSString *)appID;
@property (nonatomic, copy) void (^OnReq)(BaseReq *req);
@property (nonatomic, copy) void (^OnResp)(BaseResp *resp);
@end

@interface QQHandler : NSObject <QQApiInterfaceDelegate,ShareHandle>
+(instancetype)handleWithAppID:(NSString *)appID;
@property (nonatomic, copy) void (^OnReq)(QQBaseReq *req);
@property (nonatomic, copy) void (^OnResp)(QQBaseResp *resp);
@property (nonatomic, copy) void (^IsOnlineResponse)(NSDictionary *response);
@end
