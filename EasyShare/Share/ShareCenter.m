//
//  ShareCenter.m
//  EasyShare
//
//  Created by ileo on 16/2/2.
//  Copyright © 2016年 ileo. All rights reserved.
//

#import "ShareCenter.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface ShareCenter()

@property (nonatomic, copy) NSArray *handles;

@end

@implementation ShareCenter

+(instancetype)sharedInstance{
    static id sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (id)copyWithZone:(NSZone*)zone{
    return self;
}

-(void)configHandles:(NSArray *)handles{
    self.handles = handles;
}

-(BOOL)handleOpenURL:(NSURL *)url{
    __block BOOL isHandle = NO;
    [self.handles enumerateObjectsUsingBlock:^(id<ShareHandle>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj handleOpenURL:url]) {
            isHandle = YES;
            *stop = YES;
        }
    }];
    return isHandle;
}

-(void)shareURL:(ShareURLModel *)model withPlatform:(Share_Platform)platform{
    [self.handles enumerateObjectsUsingBlock:^(id<ShareHandle>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[obj handlePlatforms] containsObject:@(platform)]) {
            [obj shareURL:model withPlatform:platform];
            *stop = YES;
        }
    }];
}

@end

#pragma mark - 分享内容模型
@implementation ShareURLModel
@end

#pragma mark - 
@implementation WXHandle
+(instancetype)handleWithAppID:(NSString *)appID{
    [WXApi registerApp:appID];
    return [[WXHandle alloc] init];
}
-(BOOL)handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
-(NSArray *)handlePlatforms{
    return @[@(Share_WX_Session),@(Share_WX_Timeline)];
}
-(void)shareURL:(ShareURLModel *)model withPlatform:(Share_Platform)platform{
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    WXMediaMessage *mes = [WXMediaMessage message];
    WXWebpageObject *web = [WXWebpageObject object];
    web.webpageUrl = model.shareURL;
    mes.mediaObject = web;
    mes.title = model.title;
    mes.description = model.detail;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.imageURL]];
    [mes setThumbImage:[UIImage imageWithData:data]];
    req.message = mes;
    req.bText = NO;
    req.scene = (platform == Share_WX_Timeline ? WXSceneTimeline : WXSceneSession);
    [WXApi sendReq:req];
}
-(void)onReq:(BaseReq *)req{
    if (self.OnReq) {
        self.OnReq(req);
    }
}
-(void)onResp:(BaseResp *)resp{
    if (self.OnResp) {
        self.OnResp(resp);
    }
}
@end

@interface QQHandle()<TencentSessionDelegate>
@property (nonatomic, strong) TencentOAuth *oauth;
@end
@implementation QQHandle
+(instancetype)handleWithAppID:(NSString *)appID{
    QQHandle *handle = [[QQHandle alloc] init];
    handle.oauth = [[TencentOAuth alloc] initWithAppId:appID andDelegate:handle];
    return handle;
}
-(NSArray *)handlePlatforms{
    return @[@(Share_QQ),@(Share_QZone)];
}
-(BOOL)handleOpenURL:(NSURL *)url{
    return [QQApiInterface handleOpenURL:url delegate:self];
}
-(void)shareURL:(ShareURLModel *)model withPlatform:(Share_Platform)platform{
    QQApiURLObject *obj = [[QQApiURLObject alloc] initWithURL:[NSURL URLWithString:model.shareURL] title:model.title description:model.detail previewImageURL:[NSURL URLWithString:model.imageURL] targetContentType:QQApiURLTargetTypeNews];
    switch (platform) {
        case Share_QQ:
            [QQApiInterface sendReq:[SendMessageToQQReq reqWithContent:obj]];
            break;
        case Share_QZone:
            [obj setCflag:kQQAPICtrlFlagQZoneShareOnStart];
            [QQApiInterface SendReqToQZone:[SendMessageToQQReq reqWithContent:obj]];
            break;
        default:
            break;
    }
}
-(void)onReq:(QQBaseReq *)req{
    if (self.OnReq) {
        self.OnReq(req);
    }
}
-(void)onResp:(QQBaseResp *)resp{
    if (self.OnResp) {
        self.OnResp(resp);
    }
}
-(void)isOnlineResponse:(NSDictionary *)response{
    if (self.IsOnlineResponse) {
        self.IsOnlineResponse(response);
    }
}
- (void)tencentDidLogin{}
- (void)tencentDidNotLogin:(BOOL)cancelled{}
- (void)tencentDidNotNetWork{}
@end
