//
//  ShareCenter.h
//  EasyShare
//
//  Created by ileo on 16/2/2.
//  Copyright © 2016年 ileo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShareHandler.h"

@interface ShareCenter : NSObject

//单例
+(instancetype)sharedInstance;

//配置需要分享的平台handler
-(void)configHandlers:(NSArray *)handlers;

//appdelegate
-(BOOL)handleOpenURL:(NSURL *)url;

//分享url新闻
-(void)shareURL:(ShareURLModel *)model withPlatform:(Share_Platform)platform callback:(void (^)(BOOL isSuccess))callback;

@end
