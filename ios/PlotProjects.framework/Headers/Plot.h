//
//  Plot.h
//  Plot
//
//  Copyright (c) 2015 Floating Market B.V. All rights reserved.
//

/*! \mainpage IOS Plugin Documentation
 * This part of the documentation contains our public methods and properties.
 *
 * In the Classes tab above you can find information about the classes and their contents. In the Files tab you can view the Plot.h file which you import in your own app project.
 *
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UserNotifications.h>

/** 
 * \memberof Plot
 * Key for userInfo properties in UNNotificationRequests created by Plot.
 */
extern NSString* const PlotNotificationIdentifier;

/**
 * \memberof Plot
 * Key for userInfo properties in UNNotificationRequests created by Plot. Contains an unique identifier for this match (instance of this notification).
 */
extern NSString* const PlotNotificationMatchIdentifier;

/**
 * \memberof Plot
 * Key for userInfo properties in UNNotificationRequests created by Plot.
 */
extern NSString* const PlotNotificationMessage;

/**
 * \memberof Plot
 * Key for userInfo properties in UNNotificationRequests created by Plot. Synonym for PlotNotificationDataKey.
 */
extern NSString* const PlotNotificationActionKey;

/**
 * \memberof Plot
 * The field of the userinfo in the local notification that contains the data for the action to be performed. This data is set using the API or through the dashboard. When no notification handler is defined, the data is treated as URI where an empty string will just open the app. You can change this behaviour with the Notification Handler. If the notification is set to have a landing page in-app, it will bypass the handler and/or notification filter.
 */
extern NSString* const PlotNotificationDataKey; //synonym for PlotNotificationActionKey

/**
 * \memberof Plot
 * The field of the userinfo in the local notification that contains whether the app was in the foreground when the notification was sent.
 */
extern NSString* const PlotNotificationIsAppInForegroundKey;

/**
 * \memberof Plot
 * The field of the userinfo in the local notification that contains whether the notification is triggered because of a beacon. The value is @"yes" when it is, else it contains @"no".
 */
extern NSString* const PlotNotificationIsBeacon;

/**
 * \memberof Plot
 * Notification trigger identifier, used in user info.
 */
extern NSString* const PlotNotificationTrigger;

/**
 * \memberof Plot
 * Type of the region. Either geofence or beacon.
 */
extern NSString* const PlotNotificationRegionType;

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
 * Geofence match range identifier, used in user info.
 */
extern NSString* const PlotNotificationMatchRange;

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

/**
 * \memberof Plot
 * Constant for PlotNotificationRegionType, used on geofence regions.
 */
extern NSString* const PlotNotificationRegionTypeGeofence;

/**
 * \memberof Plot
 * Constant for PlotNotificationRegionType, used on beacon regions.
 */
extern NSString* const PlotNotificationRegionTypeBeacon;

/**
 * \memberof Plot
 * The field of the userinfo in the local notification that describes how the type of action that should be performed when tapping on the notification.
 * Possible values are regular, landingPage and applink.
 */
extern NSString* const PlotNotificationHandlerType;

/**
 * \memberof Plot
 * Constant for PlotNotificationHandlerType, used when the custom or default notification handler is called.
 */
extern NSString* const PlotNotificationHandlerTypeRegular;

/**
 * \memberof Plot
 * Constant for PlotNotificationHandlerType, used when an in-app WebView is shown when tapping on the notification.
 */
extern NSString* const PlotNotificationHandlerTypeLandingPage;

/**
 * \memberof Plot
 * Constant for PlotNotificationHandlerType, used when an app should be started when tapping on the notification. 
 * This contains a deep link to a page in that app and provides a fallback for when the app is not installed.
 */
extern NSString* const PlotNotificationHandlerTypeApplink;

/**
 * \memberof Plot
 * Key for userInfo properties for geotriggers in UNNotificationRequests created by Plot.
 */
extern NSString* const PlotGeotriggerIdentifier; //synonym for PlotNotificationIdentifier

/**
 * \memberof Plot
 * Key for userInfo properties for geotriggers in UNNotificationRequests created by Plot.
 */
extern NSString* const PlotGeotriggerMatchIdentifier; // synonym for PlotNotificationMatchIdentifier

/**
 * \memberof Plot
 * Key for userInfo properties for geotriggers in UNNotificationRequests created by Plot.
 */
extern NSString* const PlotGeotriggerName; //synonym for PlotNotificationMessage

/**
 * \memberof Plot
 * The field of the userinfo in the geotrigger that contains the data for the action to be performed. This data is set using the API or through the dashboard. You can use this data from the geotrigger in the geotrigger handler.
 */
extern NSString* const PlotGeotriggerDataKey; //synonym for PlotNotificationActionKey

/**
 * \memberof Plot
 * The field of the userinfo in the geotrigger that contains whether the geotrigger is triggered because of a beacon. The value is @"yes" when it is, else it contains @"no".
 */
extern NSString* const PlotGeotriggerIsBeacon; //synonym for PlotNotificationIsBeacon

/**
 * \memberof Plot
 * Geotrigger trigger identifier, used in user info. Same as NotificationTrigger but without the possibility of being dwelling.
 */
extern NSString* const PlotGeotriggerTrigger; //synonym for PlotNotificationTrigger

/**
 * \memberof Plot
 * Type of the region. Either geofence or beacon.
 */
extern NSString* const PlotGeotriggerRegionType;

/**
 * \memberof Plot
 * Geotrigger latitude identifier, used in user info.
 */
extern NSString* const PlotGeotriggerGeofenceLatitude; //synonym for PlotNotificationGeofenceLatitude

/**
 * \memberof Plot
 * Geotrigger longitude identifier, used in user info.
 */
extern NSString* const PlotGeotriggerGeofenceLongitude; //synonym for PlotNotificationGeofenceLongitude

/**
 * \memberof Plot
 * Geotrigger match range identifier, used in user info.
 */
extern NSString* const PlotGeotriggerMatchRange;

/**
 * \memberof Plot
 * Constant for PlotGeotriggerTrigger, used on enter trigger event.
 */
extern NSString* const PlotGeotriggerTriggerEnter; //synonym for PlotNotificationTriggerEnter

/**
 * \memberof Plot
 * Constant for PlotGeotriggerTrigger, used on exit trigger event.
 */
extern NSString* const PlotGeotriggerTriggerExit; //synonym for PlotNotificationTriggerExit

/**
 * \memberof Plot
 * Constant for PlotGeotriggerRegionType, used on geofence regions.
 */
extern NSString* const PlotGeotriggerRegionTypeGeofence;

/**
 * \memberof Plot
 * Constant for PlotGeotriggerRegionType, used on beacon regions.
 */
extern NSString* const PlotGeotriggerRegionTypeBeacon;


@protocol PlotDelegate;

/**
 * Represents a notification just before or after sending. You can modify the notification just before it is sent using the Notification Filter.
 */
@interface PlotFilterNotifications : NSObject

/** All notifications that are within the radius of the geofence. The type of the objects in the array is UNNotificationRequests*.
 */
@property (strong, nonatomic, readonly) NSArray<UNNotificationRequest*>* uiNotifications;

/** Shows the UNNotificationRequest* in the array in the notification center of the device. When a cooldown period is specified, only the first notification is shown when the cooldown is not in effect. Make sure to always call this method at the end of the filtering, even when the array of notifications to show is empty. This way our plugin knows filtering has finished.
 * @param uiNotifications The array of local notifications.
 */
-(void)showNotifications:(NSArray<UNNotificationRequest*>*)uiNotifications;

/**
 * Utility method that helps you test your notification filter. Returns the notifications your filter returns
 * @param notifications notifications to pass to your delegate. The elements must be of type UNNotificationRequest.
 * @param delegate the delegate to test.
 */
+(NSArray*)testFilterNotifications:(NSArray<UNNotificationRequest*>*)notifications delegate:(id<PlotDelegate>)delegate;

@end

/**
 * Represents a geotrigger, which is a notification used for smoketesting geofencing without showing a notification message. Has to be used inside the geotrigger handler.
 */
@interface PlotGeotrigger : NSObject

/** Equivalent of the userInfo for a UNNotificationRequest, use geotrigger keys to retrieve values of the geotrigger.
 */
@property (nonatomic, copy) NSDictionary *userInfo;

+(instancetype)initializeWithUserInfo:(NSDictionary*)userInfo;

@end

/**
 * Represents a geotrigger handler, which handles geotriggers just before or after handling. You can handle the geotrigger by using the Geotrigger Handler (plotHandleGeotriggers).
 */
@interface PlotHandleGeotriggers : NSObject

/** All geotriggers that are within the radius of the geofence. The type of the objects in the array is PlotGeotrigger*.
 */
@property (strong, nonatomic, readonly) NSArray<PlotGeotrigger*> *geotriggers;

/** Call this method after handling the geotriggers in your custom geotriggers handler, even when there are no geotriggers to handle, so our plugin detects that handling has finished.
 */
-(void)markGeotriggersHandled:(NSArray<PlotGeotrigger*>*)geotriggers;

/**
 * Utility method that helps you test your geotrigger handler. Returns the geotriggers your handler would return (handled geotriggers).
 * @param geotriggers geotriggers to pass to your delegate. The elements must be of type PlotGeotrigger.
 * @param delegate the delegate to test.
 */
+(NSArray*)testHandleGeotriggers:(NSArray<PlotGeotrigger*>*)geotriggers delegate:(id<PlotDelegate>)delegate;

@end

/**
 * Represents a sent notification. When fetching sent notifications, these are returned inside an array.
 */
@interface PlotSentNotification : NSObject

/** Equivalent of the userInfo for a UNNotificationRequest, use UNNotificationRequests keys to retrieve values of the sent notification.
 */
@property (nonatomic, copy, readonly) NSDictionary *userInfo;

/** Date when the notification was sent to the user.
 */
@property (nonatomic, copy, readonly) NSDate* dateSent;

/** Optional date when the notification was opened by the user.
 */
@property (nonatomic, copy, readonly) NSDate* dateOpened;

-(instancetype)initializeWithUserInfo:(NSDictionary*)userInfo dateSent:(NSDate*)dateSent dateOpened:(NSDate*)dateOpened;

@end

/**
 * Represents a sent geotrigger. When fetching sent geotriggers, these are returned inside an array.
 */
@interface PlotSentGeotrigger : NSObject

/** Equivalent of the userInfo for a UNNotificationRequest, use geotrigger keys to retrieve values of the geotrigger.
 */
@property (nonatomic, copy, readonly) NSDictionary *userInfo;

/** Date when the geotrigger was triggered by the user, and sent to the geotrigger handler.
 */
@property (nonatomic, copy, readonly) NSDate* dateSent;

/** Optional date when the geotrigger was handled by the geotrigger handler.
 */
@property (nonatomic, copy, readonly) NSDate* dateHandled;

-(instancetype)initializeWithUserInfo:(NSDictionary*)userInfo dateSent:(NSDate*)dateSent dateHandled:(NSDate*)dateHandled;

@end

/** The plot delegate which is used in this plot app.
 */
@protocol PlotDelegate <NSObject>

@optional
/** Implement this method if you don’t want to treat the data field as an URI and open that URI when a notification is received, but instead you want to provide a custom handler. Keep in mind that notifications set to be an in-app landing page will bypass this handler.
 * @param notification The received local notification.
 * @param data The custom handler.
 */
-(void)plotHandleNotification:(UNNotificationRequest*)notification data:(NSString*)data;

/** Implement this method if you want to prevent notifications from being shown or modify notifications before they are shown. Select which notifications have to be shown and call [filterNotifications showNotifications:notifications]. Make sure to always call this method, even when the array of notifications is empty. Please note that notifications that have been filtered this way can be triggered again later and that in-app landing pages bypass this filter.
 * @param filterNotifications
 */
@optional
-(void)plotFilterNotifications:(PlotFilterNotifications*)filterNotifications;

/** Implement this method if you want to handle geotriggers. If you want geotriggers to use cooldowns etc, call [geotriggerHandler markGeoTriggersHandled:geotriggers]. Make sure to always call this method, even when the array of geotriggers is empty. Please note that geotriggers that have not been passed on this way can be triggered again later even though they are not resendable.
 * @param geotriggerHandler
 */
@optional
-(void)plotHandleGeotriggers:(PlotHandleGeotriggers*)geotriggerHandler;

/**
 * Implement this method if you want to listen to the notification sent event. This is called whenever a notification is displayed to the user on the device. Use the plotNotificationOpenedEvent method if you want to use the notification opened event.
 */
@optional
-(void)plotNotificationSentEvent:(PlotSentNotification*)notification;

/**
 * Implement this method if you want to listen to the notification opened event. This is called whenever a notification is tapped (opened) by the user. Use the plotNotificationSentEvent method if you want to use the notification sent event.
 */
@optional
-(void)plotNotificationOpenedEvent:(PlotSentNotification*)notification;

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

/** Maximum number of geofence that will be monitored at once, Plot will rotate these monitored regions depending on your location. Default and maximum value are 20.
 */
@property (assign, nonatomic) int maxRegionsMonitored;

/**
 * \deprecated
 * No longer used. Default is YES.
 */
@property (assign, nonatomic) BOOL enableBackgroundModeWarning __attribute__((deprecated));

/** Automatically ask the user for permission to use the location of the device.
 *  When set to false, you're responsible yourself for asking permission to make use of location.
 */
@property (assign, nonatomic) BOOL automaticallyAskLocationPermission;

/** Automatically ask the user for permission to send notifications to the device.
 *  When set to false, you're responsible yourself for asking permission to send notifications.
 */
@property (assign, nonatomic) BOOL automaticallyAskNotificationPermission;

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


//@cond
//use initializeWithLaunchOptions: instead
+(void)initialize NS_UNAVAILABLE;
//@endcond

/**
 * \deprecated
 * Old version of initialization code. When using this method, handling notifications yourself is not supported.
 * @param key Public key from plot projects used to identify your app.
 * @param launchOptions Specific options used on launch, can be used to pass options as user.
 */
+(void)initializeWithPublicKey:(NSString*)key launchOptions:(NSDictionary *)launchOptions __attribute__((deprecated));

/**
 * \deprecated
 * Before you can make use of the other functionality within Plot, you have to call an initialization method (initializeWithLaunchOptions:delegate: is preferred).
 * Normally you want to call this method inside -(BOOL)application:didFinishLaunchingWithOptions:.
 * When the app is launched because the user tapped on a notification, then that notification will be opened.
 * @param key Public key from plot projects used to identify your app.
 * @param launchOptions Specific options used on launch, can be used to pass options as user.
 * @param delegate Plot delegate used.
 */
+(void)initializeWithPublicKey:(NSString*)key launchOptions:(NSDictionary *)launchOptions delegate:(id<PlotDelegate>)delegate __attribute__((deprecated));

/**
 * \deprecated
 * Before you can make use of the other functionality within Plot, you have to call an initialization method. The parameters for Plot are passed through a configuration object. Normally you want to call this method inside -(BOOL)application:didFinishLaunchingWithOptions:.
 * When the app is launched because the user tapped on a notification, then that notification will be opened.
 * @param configuration Configuration of the app.
 * @param launchOptions Specific options used on launch, can be used to pass options as user.
 */
+(void)initializeWithConfiguration:(PlotConfiguration*)configuration launchOptions:(NSDictionary *)launchOptions __attribute__((deprecated));


/** 
 * Before you can make use of the other functionality within Plot, you have to call an initialization method (this one is preferred). It will read the configuration from the config file (plotconfig.json), please make sure this file is defined. Normally you want to call this method inside -(BOOL)application:didFinishLaunchingWithOptions:.
 * When the app is launched because the user tapped on a notification, then that notification will be opened.
 * @param launchOptions Specific options used on launch, can be used to pass options as user.
 * @param delegate Plot delegate used.
 */
+(void)initializeWithLaunchOptions:(NSDictionary *)launchOptions delegate:(id<PlotDelegate>)delegate;

/** Enables the functionality of the Plot library until disable() is called. When the user hasn’t consented to the use of location services, he will be asked at this point. Even when the device or your app is restarted the Plot library continues to work. The intended use case is to provide users with an opt-in.<br>
 *  <br>
 *  Please note that the default configuration enables Plot automatically on the first run. <b>With the default configuration you do not have to call this method yourself.</b>
 */
+(void)enable;

/** Disables the functionality of the Plot library. The library will no longer send notifications to the user until enable() is called. The intended use case is to provide users with an opt-out.
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

/**
 * Sets a property of the user for segmentation. Set value to nil to clear the property.
 * A property can only have a single value. When setting a value for an existing property the previous value gets overwritten.
 * All currently loaded notifications on the device will be removed when calling this method. The next data update will contain all appropriately segmented notifications.
 * @param value segmentation value
 * @param propertyKey segmentation key
 */
+(void)setStringSegmentationProperty:(NSString*)value forKey:(NSString*)propertyKey;

/**
 * Sets a property of the user for segmentation. Set value to nil to clear the property.
 * A property can only have a single value. When setting a value for an existing property the previous value gets overwritten.
 * All currently loaded notifications on the device will be removed when calling this method. The next data update will contain all appropriately segmented notifications.
 * @param value segmentation value
 * @param propertyKey segmentation key
 */
+(void)setBooleanSegmentationProperty:(BOOL)value forKey:(NSString*)propertyKey;

/**
 * Sets a property of the user for segmentation. Set value to nil to clear the property.
 * A property can only have a single value. When setting a value for an existing property the previous value gets overwritten.
 * All currently loaded notifications on the device will be removed when calling this method. The next data update will contain all appropriately segmented notifications.
 * @param value segmentation value
 * @param propertyKey segmentation key
 */
+(void)setIntegerSegmentationProperty:(long long)value forKey:(NSString*)propertyKey;

/**
 * Sets a property of the user for segmentation. Set value to nil to clear the property.
 * A property can only have a single value. When setting a value for an existing property the previous value gets overwritten.
 * All currently loaded notifications on the device will be removed when calling this method. The next data update will contain all appropriately segmented notifications.
 * @param value segmentation value
 * @param propertyKey segmentation key
 */
+(void)setDoubleSegmentationProperty:(double)value forKey:(NSString*)propertyKey;

/**
 * Sets a property of the user for segmentation. Set value to nil to clear the property.
 * A property can only have a single value. When setting a value for an existing property the previous value gets overwritten.
 * All currently loaded notifications on the device will be removed when calling this method. The next data update will contain all appropriately segmented notifications.
 * @param value segmentation value
 * @param propertyKey segmentation key
 */
+(void)setDateSegmentationProperty:(NSDate*)value forKey:(NSString*)propertyKey;

/**
 * Sets the advertising identifier for the device. Please consult our documentation for the implications of using this feature.
 * @param advertisingIdentifier identifier to use
 * @param advertisingTrackingEnabled whether or not tracking is enabled
 */
+(void)setAdvertisingIdentifier:(NSUUID*)advertisingIdentifier advertisingTrackingEnabled:(BOOL)advertisingTrackingEnabled;

/**
 * Returns a list of all loaded notifications. These include the notifications that are already sent. Type is an array of UNNotificationRequest. You can retrieve data from the userInfo dictionary.
 * This call uses blocking I/O, therefore shouldn't be run on the main thread.
 */
+(NSArray<UNNotificationRequest*>*)loadedNotifications;

/**
 * Returns a list of all loaded geotriggers. Type is an array of PlotGeotrigger. You can retrieve data from the userInfo dictionary.
 * This call uses blocking I/O, therefore shouldn't be run on the main thread.
 */
+(NSArray<PlotGeotrigger*>*)loadedGeotriggers;

/**
 * Returns a list of all notifications sent by this library. Up to a 100 notifications will be stored. Type is an array of PlotSentNotification.
 * This call uses blocking I/O, therefore shouldn't be run on the main thread.
 */
+(NSArray<PlotSentNotification*>*)sentNotifications;

/**
 * Returns a list of all geotriggers sent by this library. Up to a 100 geotriggers will be stored. Type is an array of PlotSentGeotrigger.
 * This call uses blocking I/O, therefore shouldn't be run on the main thread.
 */
+(NSArray<PlotSentGeotrigger*>*)sentGeotriggers;

/**
 * Clears the stored list of sent notifications.
 */
+(void)clearSentNotifications;

/**
 * Clears the stored list of sent geotriggers.
 */
+(void)clearSentGeotriggers;

/**
 * Logs and sends to custom event (attribution) to the backend
 * @param action represents the name of the action of the attribution event
 * for instance "flyer_read"
 */
+(void)sendAttributionEvent:(NSString*) action;

/**
 * Logs and sends to custom event (attribution) to the backend with custom extra properties
 * @param action The name of the action of the attribution event (ie. flyer_read)
 * @param itemId The identifier of the item related to the attribution event.
 * for instance ("gamma_week_12")
 */
+(void)sendAttributionEvent:(NSString *)action withItemId:(NSString *)itemId;

/**
 * Only needed when method swizzling is disabled in the Firebase library and you want to make use of QuickSync. Forward the method with the
 * same name from the AppDelegate to Plot to ensure correct workings.
 */
+(void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken;

/**
 * Only needed when method swizzling is disabled in the Firebase library and you want to make use of QuickSync. Forward the method with the
 * same name from the AppDelegate to Plot to ensure correct workings.
 */
+(void)didFailToRegisterForRemoteNotificationsWithError:(NSError*)error;

/**
 * Forward this method with the same name from the AppDelegate to Plot when you want to make use of QuickSync.
 */
+(void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))handler;

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
