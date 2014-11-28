//
//  Plot.h
//  Plot
//
//  Copyright (c) 2014 Floating Market B.V. All rights reserved.
//

/*! \mainpage IOS Plugin Documentation
 * This part of the documentation contains our public methods and properties.
 *
 * In the Classes tab above you can find information about the classes and their contents. In the Files tab you can view the Plot.h file which you import in your own app project.
 *
 */

#import <Foundation/Foundation.h>

@class UIViewController;

/**
 * \memberof Plot
 * Key for userInfo properties in UILocalNotifications created by Plot.
 */
extern NSString* const PlotNotificationIdentifier;

/**
 * \memberof Plot
 * Key for userInfo properties in UILocalNotifications created by Plot.
 */
extern NSString* const PlotNotificationMessage;

/**
 * \memberof Plot
 * Key for userInfo properties in UILocalNotifications created by Plot.
 */
extern NSString* const PlotNotificationActionKey;

/**
 * \memberof Plot
 * The field of the userinfo in the local notification that contains the data for the action to be performed.
 */
extern NSString* const PlotNotificationDataKey; //synonym for PlotNotificationActionKey

/**
 * \memberof Plot
 * The field of the userinfo in the local notification that contains whether the app was in the foreground when the notification was sent.
 */
extern NSString* const PlotNotificationIsAppInForegroundKey;

/**
 * \memberof Plot
 * The field of the userinfo in the local notification that contains whether the notification is triggered because of a geofence. The value is @"yes" when it is, else it contains @"no".
 */
extern NSString* const PlotNotificationIsBeacon;

/**
 * \memberof Plot
 * Notification trigger identifier, used in user info.
 */
extern NSString* const PlotNotificationTrigger;

/**
 * \memberof Plot
 * Geofence latitude identifier, used in user info.
 */
extern NSString* const PlotNotificationGeofenceLatitude;

/**
 * \memberof Plot
 * Geofence longitude identifier, used in user info.
 */
extern NSString* const PlotNotificationGeofenceLongitude;

/**
 * \memberof Plot
 * Dwelling time identifier, used in user info.
 */
extern NSString* const PlotNotificationDwellingMinutes;

/**
 * \memberof Plot
 * Constant for PlotNotificationTrigger, used on enter trigger event.
 */
extern NSString* const PlotNotificationTriggerEnter;

/**
 * \memberof Plot
 * Constant for PlotNotificationTrigger, used on exit trigger event.
 */
extern NSString* const PlotNotificationTriggerExit;

@protocol PlotDelegate;

@class UILocalNotification;

/**
 * Represents a notification just before or after sending. You can modify the notification just before it is sent using the Notification Filter.
 */
@interface PlotFilterNotifications : NSObject

/** All notifications that are within the radius of the geofence. The type of the objects in the array is UILocalNotification*.
 */
@property (strong, nonatomic, readonly) NSArray* uiNotifications;

/** Shows the UILocalNotification* in the array in the notification center of the device. When a cooldown period is specified, only the first notification is shown when the cooldown is not in effect.
 * @param uiNotifications The array of local notifications.
 */
-(void)showNotifications:(NSArray*)uiNotifications;

/**
 * Utility method that helps you test your notification filter. Returns the notifications your filter returns
 * @param notifications notifications to pass to your delegate. The elements must be of type UILocalNotification.
 * @param delegate the delegate to test.
 */
+(NSArray*)testFilterNotifications:(NSArray*)notifications delegate:(id<PlotDelegate>)delegate;

@end

/** The plot delegate which is used in this plot app.
 */
@protocol PlotDelegate <NSObject>

@optional
/** Implement this method if you don’t want a browser to be opened when a notification is received, but instead you want to provide a custom handler.
 * @param notification The received local notification.
 * @param data The custom handler.
 */
-(void)plotHandleNotification:(UILocalNotification*)notification data:(NSString*)data;

/** Implement this method if you want to prevent notifications from being shown or modify notifications before they are shown. Select which notifications have to be shown and call [filterNotifications showNotifications:notifications]. Please note that notifications that have been filtered this way can be triggered again later.
 * @param filterNotifications
 */
@optional
-(void)plotFilterNotifications:(PlotFilterNotifications*)filterNotifications;

@end

/** All configurations for the plot app.
 */
@interface PlotConfiguration : NSObject

/** Specify -1 to use the value of previous session. Set to 0 to allow notifications to be sent directly after another notification has been sent. Default is -1.
 */
@property (assign, nonatomic) int cooldownPeriod;

/** Use to set your publicKey.
 */
@property (strong, nonatomic) NSString* publicKey;

/** Delegate used for Plot, use this property for setting.
 */
@property (strong, nonatomic) id<PlotDelegate> delegate;

/** Enable or disable the use of the plugin on the first run. Default is YES.
 */
@property (assign, nonatomic) BOOL enableOnFirstRun;

/**
 * \deprecated
 * No longer used. Default is YES.
 */
@property (assign, nonatomic) BOOL enableBackgroundModeWarning __attribute__((deprecated));

/** Initializes this object with your publicToken and the PlotDelegate.
 * @param publicKey Your public key from plot projects.
 * @param delegate The plot delegate you use.
 */
-(instancetype)initWithPublicKey:(NSString*)publicKey delegate:(id<PlotDelegate>)delegate;

@end

/**
 * The main methods to control the beheavior of Plot.
 */
@interface PlotBase : NSObject

/**
 * \deprecated
 * Old version of initialization code. When using this method, handling notifications yourself is not supported.
 * @param key Public key from plot projects used to identify your app.
 * @param launchOptions Specific options used on launch, can be used to pass options as user.
 */
+(void)initializeWithPublicKey:(NSString*)key launchOptions:(NSDictionary *)launchOptions __attribute__((deprecated));

/**
 * \deprecated
 * Before you can make use of the other functionality within Plot, you have to call an initialization method (initializeWithConfiguration:launchOptions: is preferred).
 * Normally you want to call this method inside -(BOOL)application:didFinishLaunchingWithOptions:. If the Plot library was enabled last time, it will be enabled again.
 * When the app is launched because the user tapped on a notification, then that notification will be opened.
 * @param key Public key from plot projects used to identify your app.
 * @param launchOptions Specific options used on launch, can be used to pass options as user.
 * @param delegate Plot delegate used.
 */
+(void)initializeWithPublicKey:(NSString*)key launchOptions:(NSDictionary *)launchOptions delegate:(id<PlotDelegate>)delegate __attribute__((deprecated));

/** Before you can make use of the other functionality within Plot, you have to call an initialization method (this one is preferred). The parameters for Plot are passed through a configuration object. Normally you want to call this method inside -(BOOL)application:didFinishLaunchingWithOptions:. If the Plot library was enabled last time, it will be enabled again. When the app is launched because the user tapped on a notification, then that notification will be opened.
 * @param configuration Configuration of the app.
 * @param launchOptions Specific options used on launch, can be used to pass options as user.
 */
+(void)initializeWithConfiguration:(PlotConfiguration*)configuration launchOptions:(NSDictionary *)launchOptions;

/** Enables the functionality of the Plot library. When the user hasn’t consented to the use of location services, he will be asked at this point.
 */
+(void)enable;

/** Disables the functionality of the Plot library. The library will no longer send notifications to the user.
 */
+(void)disable;

/** Changes the minimum time interval (in seconds) between two notifications to be sent. This value is remembered between sessions. Set to 0 to allow notifications to be sent directly after another notification has been sent. Default is 0.
 * @param secondsCooldown The minimum number of seconds between two notifications.
 */
+(void)setCooldownPeriod:(int)secondsCooldown;

/**
 * \deprecated
 * No longer used. Doesn’t do anything.
 * @param enabled Enabled background warning mode.
 */
+(void)setEnableBackgroundModeWarning:(BOOL)enabled __attribute__((deprecated));

/** Returns whether the library is enabled. Could return NO when the initialization of the library hasn’t completed yet.
 */
+(BOOL)isEnabled;

/** The notification will be opened. You must place this method call in the application:didReceiveLocalNotification: method in your application delegate. It opens Safari with the URL enclosed in the notification, unless your delegate has the plotHandleNotification: method implemented.
 * @param localNotification The notification that is processed.
 */
+(void)handleNotification:(UILocalNotification*)localNotification;

/**
 * \deprecated
 * Deprecated way of setting the Plot delegate.
 * @param delegate The plot delegate which is used.
 */
+(void)setDelegate:(id<PlotDelegate>)delegate __attribute__((deprecated));

/** Returns the current version of the Plot plugin.
 */
+(NSString*)version;

/**
 * Sends the developer log. Only use this when compiling for DEBUG. When the log is unavailable, then an alert is shown.
 * @param viewController viewController to place the mail view on top of
 */
+(void)mailDebugLog:(UIViewController*)viewController;

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
