//
//  Utility.h
//  Dopple
//
//  Created by Bacancy Technology Pvt. Ltd. on 28/08/17.
//  Copyright © 2017 Bacancy Technology Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Utility : NSObject

+ (Utility*) instance;
+ (id) initobj;
+ (void)postRequest :(NSDictionary *)dict url:(NSString *)url success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
+ (void)postWithImage :(NSDictionary *)dict :(NSData *)img1 :(NSString *)imgName :(NSString *)paramName :(NSString *)url success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
+ (void)postWithImage :(NSDictionary *)dict :(NSData *)img1 :(NSData *)img2 :(NSString *)url success:(void (^)(id result))success failure:(void (^)(NSError *error))failure;
+ (BOOL)connected;

+ (void)uploadVideoURLBIO:(NSData *)videoData
                andUrl:(NSString*)strUrl
            parameters:(NSDictionary *)parameters
               success:(void (^)(id result))success
               failure:(void (^)(NSInteger code,NSError *error))failure;

+ (void)uploadVideoAnswerURL:(NSData *)videoData
                        andUrl:(NSString*)strUrl
                   VideoStatus:(NSString*)VideoSt
                     VideoPath:(NSURL*)VideoPath
                    VideoImage:(UIImage*)imgVideo
                     ThumbPath:(NSString*)ThumbPath
                     VideoTime:(NSString*)VideoTime
                      Videoimg:(NSData*)VideoIMGData
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id result))success
                       failure:(void (^)(NSInteger code,NSError *error))failure;

+ (void)RetryuploadVideoAnswerURL:(NSData *)videoData
                           andUrl:(NSString*)strUrl
                      VideoStatus:(NSString*)VideoSt
                        VideoPath:(NSURL*)VideoPath
                       VideoImage:(UIImage*)imgVideo
                        ThumbPath:(NSString*)ThumbPath
                        VideoTime:(NSString*)VideoTime
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(id result))success
                          failure:(void (^)(NSInteger code,NSError *error))failure;

+ (void)uploadVideoAnswerURLWithThumb:(NSData *)videoData
                               andUrl:(NSString*)strUrl
                          VideoStatus:(NSString*)VideoSt
                            VideoPath:(NSURL*)VideoPath
                           VideoImage:(UIImage*)imgVideo   
                            ThumbPath:(NSString*)ThumbPath
                            VideoTime:(NSString*)VideoTime
                             Videoimg:(NSData*)VideoIMGData
                           parameters:(NSDictionary *)parameters
                              success:(void (^)(id result))success
                              failure:(void (^)(NSInteger code,NSError *error))failure;
@end
