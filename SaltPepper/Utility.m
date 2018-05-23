//
//  Utility.m
//  Dopple
//
//  Created by Bacancy Technology Pvt. Ltd. on 28/08/17.
//  Copyright © 2017 Bacancy Technology Pvt. Ltd. All rights reserved.
//

#import "Utility.h"
#import "AFHTTPSessionManager.h"
#import "Reachability.h"
#import "saltPepper.pch"

@implementation Utility

+ (Utility*) instance {
    static dispatch_once_t _singletonPredicate;
    static Utility *_singleton = nil;
    dispatch_once(&_singletonPredicate, ^{
        _singleton = [[super allocWithZone:nil] init];
    });
    return _singleton;
}

+ (id) initobj {
    return [self instance];
}

+(void)postRequest :(id)dict url:(NSString *)url success:(void (^)(id result))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:url parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"JSON: %@", responseObject);
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error.localizedDescription);
        NSLog(@"%@",task.response);
        failure(error);
    }];
    
   
   // OLD CODE
    
//    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
//
//    NSLog(@"APIURL: %@",url);
//
//    [manager.requestSerializer setValue:@"application/json; text/html; text/plain" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json; text/html; application/javascript; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [manager.requestSerializer setTimeoutInterval:120.0];
//
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:  NSJSONReadingAllowFragments];
//    [manager POST:[NSString stringWithFormat:@"%@",url] parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//        success(responseObject);
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"%@",error.localizedDescription);
//        NSLog(@"%@",task.response);
//        failure(error);
//    }];
}

+(void)postWithImage:(NSDictionary *)dict :(NSData *)img1 :(NSString *)imgName :(NSString *)paramName :(NSString *)url success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSLog(@"APIURL: %@",url);
    
    [manager.requestSerializer setValue:@"application/json; text/html" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:[NSString stringWithFormat:@"%@",url] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         [formData appendPartWithFileData:img1 name:paramName fileName:[NSString stringWithFormat:@"%@.jpeg",imgName] mimeType:@"image/jpeg"];
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         // NSLog(@"JSON: %@", responseObject);
         success(responseObject);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         // NSLog(@"%@",error.localizedDescription);
         // NSLog(@"%@",task.response);
         failure(error);
     }];
}

+ (void)postWithImage :(NSDictionary *)dict :(NSData *)img1 :(NSData*)img2 :(NSString *)url success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSLog(@"APIURL: %@",url);
    
    [manager.requestSerializer setValue:@"application/json; text/html" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; text/html; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer=[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager POST:[NSString stringWithFormat:@"%@",url] parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData)
     {
         [formData appendPartWithFileData:img1 name:@"profile_pic" fileName:@"Profile.jpeg" mimeType:@"image/jpeg"];
         [formData appendPartWithFileData:img2 name:@"cover_pic" fileName:@"Cover.jpeg" mimeType:@"image/jpeg"];
     } progress:^(NSProgress * _Nonnull uploadProgress) {
         
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         // NSLog(@"JSON: %@", responseObject);
         success(responseObject);
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         // NSLog(@"%@",error.localizedDescription);
         // NSLog(@"%@",task.response);
         failure(error);
     }];
}

+ (void)uploadVideoURLBIO:(NSData *)videoData
                andUrl:(NSString*)strUrl
            parameters:(NSDictionary *)parameters
               success:(void (^)(id result))success
               failure:(void (^)(NSInteger code,NSError *error))failure
{
    NSLog(@"APIURL: %@",strUrl);
    UIApplication *application = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier task = 0;
    task = [application beginBackgroundTaskWithExpirationHandler:^{
        //NSLog(@"WARNING: Failed to upload video in time.");
        [application endBackgroundTask:task];
    }];
    
    void (^block)(id<AFMultipartFormData>) = ^void(id<AFMultipartFormData> formData) {
        // Add the audio data to the request.
        [formData appendPartWithFileData:videoData
                                    name:@"video"
                                fileName:@"QueVideo.mp4"
                                mimeType:@"video/mp4"];
    };
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                              URLString:strUrl
                                                                                             parameters:parameters
                                                                              constructingBodyWithBlock:block
                                                                                                  error:nil];
    
    
    NSURLSessionUploadTask *upload = [KmyappDelegate.manager uploadTaskWithStreamedRequest:request
                                                                   progress:^(NSProgress * _Nonnull uploadProgress) {
                                                                       // This is not called back on the main queue.
                                                                       // You are responsible for dispatching to the main queue for UI updates
                                                                       dispatch_async(dispatch_get_main_queue(), ^{
                                                                           //Update the progress view
                                                                           // NSLog(@"Progress: %f", uploadProgress.fractionCompleted);
                                                                       });
                                                                   }
                                                          completionHandler:^(NSURLResponse *response, id data, NSError *error) {
                                                              if (error) {
                                                                  //NSLog(@"WARNING: Failed to upload video (%@)", error.localizedDescription);
                                                                  NSInteger statusCode = -1;
                                                                  if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                                                                      statusCode = ((NSHTTPURLResponse *)response).statusCode;
                                                                  }
                                                                  failure(statusCode, error);
                                                              } else {
                                                                  //NSLog(@"Completed upload of video");
                                                                  success(data);
                                                              }
                                                              [application endBackgroundTask:task];
                                                          }];
    
    [upload resume];
}

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
                     failure:(void (^)(NSInteger code,NSError *error))failure
{
    
    NSLog(@"APIURL: %@",strUrl);
   
        UIApplication *application = [UIApplication sharedApplication];
        UIBackgroundTaskIdentifier task = 0;
        task = [application beginBackgroundTaskWithExpirationHandler:^{
            //NSLog(@"WARNING: Failed to upload video in time.");
            [application endBackgroundTask:task];
        }];
        
        void (^block)(id<AFMultipartFormData>) = ^void(id<AFMultipartFormData> formData)
        {
            // Add the audio data to the request.
            [formData appendPartWithFileData:videoData
                                        name:@"avatar"
                                    fileName:@"QueVideo.mp4"
                                    mimeType:@"video/mp4"];
            
            [formData appendPartWithFileData:VideoIMGData
                                        name:@"thumbnail"
                                    fileName:@"QueVideo.jpg"
                                    mimeType:@"image/jpeg"];
        };
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                                  URLString:strUrl
                                                                                                 parameters:parameters
                                                                                  constructingBodyWithBlock:block
                                                                                                      error:nil];
        
        NSURLSessionUploadTask *upload = [KmyappDelegate.manager uploadTaskWithStreamedRequest:request
                                                                       progress:^(NSProgress * _Nonnull uploadProgress){
         
          NSProgress* progress = (NSProgress*)uploadProgress;
          NSUInteger completed = (NSUInteger)progress.completedUnitCount;
          NSUInteger total = (NSUInteger)progress.totalUnitCount;
          double fraction = ((double)completed / (double)total);
          
          int ProgressPer=fraction*100;
          
          dispatch_async(dispatch_get_main_queue(),
                         ^{
                             
                         });
      }
        completionHandler:^(NSURLResponse *response, id data, NSError *error)
      {
          //NSLog(@"Progress status==%@, Status==%@",parameters,VideoSt);
          if (error)
          {
              if ([error code] != NSURLErrorCancelled)
              {
                  
              }
              
              //NSLog(@"WARNING: Failed to upload video (%@)", error.localizedDescription);
              NSInteger statusCode = -1;
              if ([response isKindOfClass:[NSHTTPURLResponse class]])
              {
                  statusCode = ((NSHTTPURLResponse *)response).statusCode;
              }
              failure(statusCode, error);
          }
          else
          {
              success(data);
          }
          [application endBackgroundTask:task];
      }];
       
    [upload resume];
}

+ (void)RetryuploadVideoAnswerURL:(NSData *)videoData
                           andUrl:(NSString*)strUrl
                      VideoStatus:(NSString*)VideoSt
                        VideoPath:(NSURL*)VideoPath
                       VideoImage:(UIImage*)imgVideo
                        ThumbPath:(NSString*)ThumbPath
                        VideoTime:(NSString*)VideoTime
                       parameters:(NSDictionary *)parameters
                          success:(void (^)(id result))success
                          failure:(void (^)(NSInteger code,NSError *error))failure
{
    
    NSLog(@"APIURL: %@",strUrl);

        UIApplication *application = [UIApplication sharedApplication];
        UIBackgroundTaskIdentifier task = 0;
        task = [application beginBackgroundTaskWithExpirationHandler:^{
            //NSLog(@"WARNING: Failed to upload video in time.");
            [application endBackgroundTask:task];
        }];
        
        void (^block)(id<AFMultipartFormData>) = ^void(id<AFMultipartFormData> formData)
        {
            // Add the audio data to the request.
            [formData appendPartWithFileData:videoData
                                        name:@"avatar"
                                    fileName:@"QueVideo.mp4"
                                    mimeType:@"video/mp4"];
        };
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                                  URLString:strUrl
                                                                                                 parameters:parameters  constructingBodyWithBlock:block
                                                                                                      error:nil];
        
        NSURLSessionUploadTask *upload = [KmyappDelegate.manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress){
            
              NSProgress* progress = (NSProgress*)uploadProgress;
              NSUInteger completed = (NSUInteger)progress.completedUnitCount;
              NSUInteger total = (NSUInteger)progress.totalUnitCount;
              double fraction = ((double)completed / (double)total);
            
              int ProgressPer=fraction*100;

              dispatch_async(dispatch_get_main_queue(),
             ^{
                 
             });
          }
        completionHandler:^(NSURLResponse *response, id data, NSError *error)
          {
             // NSLog(@"Progress status==%@, Status==%@",parameters,VideoSt);
              if (error)
              {
                 
                  NSInteger statusCode = -1;
                  if ([response isKindOfClass:[NSHTTPURLResponse class]])
                  {
                      statusCode = ((NSHTTPURLResponse *)response).statusCode;
                  }
                  failure(statusCode, error);
              }
              else
              {
                  
                  success(data);
              }
              [application endBackgroundTask:task];
          }];
        [upload resume];
}

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
                              failure:(void (^)(NSInteger code,NSError *error))failure
{
    NSLog(@"APIURL: %@",strUrl);

        UIApplication *application = [UIApplication sharedApplication];
        UIBackgroundTaskIdentifier task = 0;
        task = [application beginBackgroundTaskWithExpirationHandler:^{
            //NSLog(@"WARNING: Failed to upload video in time.");
            [application endBackgroundTask:task];
        }];
        
        void (^block)(id<AFMultipartFormData>) = ^void(id<AFMultipartFormData> formData)
        {
            // Add the audio data to the request.
            [formData appendPartWithFileData:videoData
                                        name:@"avatar"
                                    fileName:@"QueVideo.mp4"
                                    mimeType:@"video/mp4"];
            
            [formData appendPartWithFileData:VideoIMGData
                                        name:@"thumbnail"
                                    fileName:@"QueVideo.jpg"
                                    mimeType:@"image/jpeg"];
        };
        
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST"
                                                                                                  URLString:strUrl
                                                                                                 parameters:parameters
                                                                                  constructingBodyWithBlock:block
                                                                                                      error:nil];
        
        NSURLSessionUploadTask *upload = [KmyappDelegate.manager uploadTaskWithStreamedRequest:request
                                                                                    progress:^(NSProgress * _Nonnull uploadProgress)
        {
                                                                                        
            NSProgress* progress = (NSProgress*)uploadProgress;
            NSUInteger completed = (NSUInteger)progress.completedUnitCount;
            NSUInteger total = (NSUInteger)progress.totalUnitCount;
            double fraction = ((double)completed / (double)total);
            
            int ProgressPer=fraction*100;
            dispatch_async(dispatch_get_main_queue(),
            ^{
                
            });
        }
    completionHandler:^(NSURLResponse *response, id data, NSError *error)
    {
          if (error)
          {
              
              NSInteger statusCode = -1;
              if ([response isKindOfClass:[NSHTTPURLResponse class]])
              {
                  statusCode = ((NSHTTPURLResponse *)response).statusCode;
              }
              failure(statusCode, error);
          }
          else
          {
              success(data);
          }
          [application endBackgroundTask:task];
      }];
        
        [upload resume];

}
#pragma mark - Reachability

+ (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

@end
