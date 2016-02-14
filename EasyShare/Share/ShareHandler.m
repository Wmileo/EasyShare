//
//  ShareHandler.m
//  EasyShare
//
//  Created by ileo on 16/2/4.
//  Copyright © 2016年 ileo. All rights reserved.
//

#import "ShareHandler.h"
#import <TencentOpenAPI/TencentOAuth.h>

@implementation WXHandler
+(instancetype)handleWithAppID:(NSString *)appID{
    [WXApi registerApp:appID];
    return [[WXHandler alloc] init];
}
-(BOOL)handleOpenURL:(NSURL *)url{
    return [WXApi handleOpenURL:url delegate:self];
}
-(NSArray *)handlePlatforms{
    return @[@(Share_WX_Session),@(Share_WX_Timeline)];
}
-(NSString *)handleURLPrefix{
    return @"wx";
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

@interface QQHandler()<TencentSessionDelegate>
@property (nonatomic, strong) TencentOAuth *oauth;
@end
@implementation QQHandler
+(instancetype)handleWithAppID:(NSString *)appID{
    QQHandler *handle = [[QQHandler alloc] init];
    handle.oauth = [[TencentOAuth alloc] initWithAppId:appID andDelegate:handle];
    return handle;
}
-(NSArray *)handlePlatforms{
    return @[@(Share_QQ),@(Share_QZone)];
}
-(BOOL)handleOpenURL:(NSURL *)url{
    return [QQApiInterface handleOpenURL:url delegate:self];
}
-(NSString *)handleURLPrefix{
    return @"QQ";
}
-(void)shareURL:(ShareURLModel *)model withPlatform:(Share_Platform)platform{
    QQApiURLObject *obj = [QQApiURLObject objectWithURL:[NSURL URLWithString:model.shareURL] title:model.title description:model.detail previewImageURL:[NSURL URLWithString:model.imageURL] targetContentType:QQApiURLTargetTypeNews];
    
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
