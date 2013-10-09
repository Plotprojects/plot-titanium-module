//
//  Plot.h
//  Plot
//
//  Copyright (c) 2013 Floating Market B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString* PlotNotificationActionKey;
extern const NSString* PlotNotificationIsAppInForegroundKey;

@class UILocalNotification;

@interface PlotFilterNotifications : NSObject

@property (strong, nonatomic, readonly) NSArray* uiNotifications;

-(void)showNotifications:(NSArray*)uiNotifications;

@end

@protocol PlotDelegate <NSObject>

@optional
-(void)plotHandleNotification:(UILocalNotification*)notification data:(NSString*)action;

-(void)plotFilterNotifications:(PlotFilterNotifications*)filterNotifications;

@end

@interface PlotConfiguration : NSObject

@property (assign, nonatomic) int cooldownPeriod;
@property (strong, nonatomic) NSString* publicKey;
@property (strong, nonatomic) id<PlotDelegate> delegate;
@property (assign, nonatomic) BOOL enableOnFirstRun;
@property (assign, nonatomic) BOOL enableBackgroundModeWarning;

-(id)initWithPublicKey:(NSString*)publicKey delegate:(id<PlotDelegate>)delegate;

@end

@interface PlotBase : NSObject

+(void)initializeWithPublicKey:(NSString*)key launchOptions:(NSDictionary *)launchOptions __attribute__((deprecated));
+(void)initializeWithPublicKey:(NSString*)key launchOptions:(NSDictionary *)launchOptions delegate:(id<PlotDelegate>)delegate;
+(void)initializeWithConfiguration:(PlotConfiguration*)configuration launchOptions:(NSDictionary *)launchOptions;

+(void)enable;

+(void)disable;

+(void)setCooldownPeriod:(int)secondsCooldown;

+(void)setEnableBackgroundModeWarning:(BOOL)enabled;

+(BOOL)isEnabled;

+(void)handleNotification:(UILocalNotification*)localNotification;

+(void)setDelegate:(id<PlotDelegate>)delegate;

+(NSString*)version;

@end

@interface PlotDebug: PlotBase

@end

@interface PlotRelease:  PlotBase

@end

#ifdef DEBUG

#define Plot PlotDebug

#else

#define Plot PlotRelease

#endif
