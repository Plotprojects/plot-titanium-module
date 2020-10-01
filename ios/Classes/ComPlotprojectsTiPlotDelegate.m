//
//  ComPlotprojectsTiPlotDelegate.m
//  plot-ios-module
//
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import <PlotProjects/Plot.h>
#import "ComPlotprojectsTiPlotDelegate.h"
#import "ComPlotprojectsTiNotificationFilter.h"
#import "ComPlotprojectsTiGeotriggerHandler.h"
#import "ComPlotprojectsTiConversions.h"

@implementation ComPlotprojectsTiPlotDelegate
@synthesize handleNotificationDelegate;
@synthesize enableGeotriggerHandler;
@synthesize enableNotificationFilter;

-(instancetype)init {
    if ((self = [super init])) {
        filterIndex = 1;
        handlerIndex = 1;

        notificationsToFilter = [[NSMutableArray alloc] init];
        geotriggersToHandle = [[NSMutableArray alloc] init];

        notificationsBeingFiltered = [[NSMutableDictionary alloc] init];
        geotriggersBeingHandled = [[NSMutableDictionary alloc] init];

        notificationsToHandleQueued = [[NSMutableArray alloc] init];
        notificationsToFilterQueued = [[NSMutableArray alloc] init];
        geotriggersToHandleQueued = [[NSMutableArray alloc] init];

        NSLog(@"PlotProjects - Init ComPlotprojectsTiPlotDelegate");
    }
    return self;
}

-(void)initCalled {
    plotInitCalled = YES;

    NSLog(@"PlotProjects - number of notifications to filter: %ld", notificationsToFilterQueued.count);
    for (PlotFilterNotifications* n in notificationsToFilterQueued) {
        [self plotFilterNotificationsAfterInit:n];
    }
    [notificationsToFilterQueued removeAllObjects];

    NSLog(@"PlotProjects - number of notifications to handle %ld", notificationsToHandleQueued.count);
    for (UNNotificationRequest* n in notificationsToHandleQueued) {
        [handleNotificationDelegate handleNotification:n];
    }
    [notificationsToHandleQueued removeAllObjects];

    NSLog(@"PlotProjects - number of geotriggers to handle %ld", geotriggersToHandleQueued.count);
    for (PlotHandleGeotriggers* g in geotriggersToHandleQueued) {
        [self plotHandleGeotriggersAfterInit:g];
    }
    [geotriggersToHandleQueued removeAllObjects];
}

-(void)plotHandleNotification:(UNNotificationRequest*)notification data:(NSString*)data {
    //NSLog(@"PlotProjects - plotHandleNotification");
    if (plotInitCalled) {
        //NSLog(@"PlotProjects - Handling notification... %@", notification.content.userInfo);
        [handleNotificationDelegate handleNotification:notification];
    } else {
        [notificationsToHandleQueued addObject:notification];
    }
}

-(void)showNotificationsOnMainThread:(NSString *)filterId notifications:(NSArray *)notificationsPassed {
    //NSLog(@"PlotProjects - showNotificationsOnMainThread");
    PlotFilterNotifications* filterNotifications = [notificationsBeingFiltered objectForKey:filterId];
    if (filterNotifications == nil) {
        //NSLog(@"PlotProjects - Unknown filter with id: %@", filterId);
        return;
    }

    [notificationsBeingFiltered removeObjectForKey:filterId];

    NSDictionary<NSString*, UNNotificationRequest*>* index = [self indexLocalNotifications:filterNotifications.uiNotifications];

    NSMutableArray<UNNotificationRequest*>* result = [NSMutableArray array];

    for (NSDictionary* notificationData in notificationsPassed) {
        UNNotificationRequest* localNotification = [ComPlotprojectsTiConversions transformNotification:notificationData index:index];
        if (localNotification != nil) {
            [result addObject:localNotification];
        }
    }

    [filterNotifications showNotifications:result];
}

-(void)handleGeotriggersOnMainThread:(NSString*)handlerId geotriggers:(NSArray*)geotriggersPassed {
    NSLog(@"PlotProjects - handleGeotriggersOnMainThread");
    PlotHandleGeotriggers* geotriggerHandler = [geotriggersBeingHandled objectForKey:handlerId];
    if (geotriggerHandler == nil) {
        //NSLog(@"PlotProjects - Unknown handler with id: %@", handlerId);
        return;
    }

    [geotriggersBeingHandled removeObjectForKey:handlerId];

    NSDictionary* index = [self indexGeotriggers:geotriggerHandler.geotriggers];

    NSMutableArray<PlotGeotrigger*>* result = [NSMutableArray array];

    for (NSDictionary* geotriggerData in geotriggersPassed) {
        PlotGeotrigger* geotrigger = [ComPlotprojectsTiConversions transformGeotrigger:geotriggerData index:index];
        if (geotrigger != nil) {
            [result addObject:geotrigger];
        }
    }

    [geotriggerHandler markGeotriggersHandled:result];
}

-(NSDictionary<NSString*, PlotGeotrigger*>*)indexGeotriggers:(NSArray<PlotGeotrigger*>*)geotriggers {
    NSMutableDictionary<NSString*, PlotGeotrigger*>* result = [NSMutableDictionary dictionaryWithCapacity:geotriggers.count];

    for (PlotGeotrigger* geotrigger in geotriggers) {
        NSString* identifier = [geotrigger.userInfo objectForKey:@"identifier"];
        if (identifier != nil) {
            [result setObject:geotrigger forKey:identifier];
        }
    }

    return result;
}

-(NSDictionary<NSString*, UNNotificationRequest*>*)indexLocalNotifications:(NSArray<UNNotificationRequest*>*)notifications {
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:notifications.count];

    for (UNNotificationRequest* notification in notifications) {
        if (![notification isKindOfClass:[UNNotificationRequest class]]) {
            //NSLog(@"PlotProjects - Wrong type, expected UNNotificationRequest, got %@", NSStringFromClass([notification class]));
            continue;
        }

        NSString* identifier = [notification.content.userInfo objectForKey:@"identifier"];
        if (identifier != nil) {
            [result setObject:notification forKey:identifier];
        }
    }

    return result;
}

-(void)plotFilterNotifications:(PlotFilterNotifications*)notification {
    if (plotInitCalled) {
        //NSLog(@"PlotProjects - Delegate defined, filtering notification...");
        [self plotFilterNotificationsAfterInit:notification];
    } else {
        //NSLog(@"PlotProjects - Delegate undefined, not filtering");
        [notificationsToFilterQueued addObject:notification];
    }
}

-(void)plotFilterNotificationsAfterInit:(PlotFilterNotifications *)filterNotifications {
    if (enableNotificationFilter) {
        //NSLog(@"PlotProjects - Size of list to filter id %ld", notificationsToFilter.count);

        [notificationsToFilter addObject:filterNotifications];

        ComPlotprojectsTiNotificationFilter* filter = [[ComPlotprojectsTiNotificationFilter alloc] init];
        [filter startFilter];
        [self performSelector:@selector(shutdownFilter:) withObject:filter afterDelay:10];
    } else {
        //NSLog(@"PlotProjects - showNotifications");
        [filterNotifications showNotifications:filterNotifications.uiNotifications];
    }
}

-(void)plotHandleGeotriggers:(PlotHandleGeotriggers*)geotriggers {
    NSLog(@"PlotProjects - plotHandleGeotriggers %lu", geotriggers.geotriggers.count);

    NSString* trigger_direction = @"Unknown";

    for (PlotGeotrigger* geotrigger in geotriggers.geotriggers) {
        NSLog(@"PlotProjects - for geotrigger in geotriggers loop %@", geotrigger);
        NSString* trigger = [geotrigger.userInfo objectForKey:PlotGeotriggerTrigger];

        if (trigger != nil) {
             //[result setObject:geotrigger forKey:identifier];
             NSLog(@"PlotProjects - trigger %@", trigger);

            if([trigger isEqualToString:PlotGeotriggerTriggerEnter]){
                NSLog(@"PlotProjects - ENTERED geotrigger");
                trigger_direction = @"enter";
            }
            if([trigger isEqualToString:PlotGeotriggerTriggerExit]){
                NSLog(@"PlotProjects - EXIT geotrigger");
                trigger_direction = @"exit";
            }

            NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
            NSString *notTitle;
            NSString *notText;
            NSTimeInterval notTimeDelay = (2.0 * 60.0);

            if (standardUserDefaults) {
                // read value
                NSString* customNotTitlePersistent = [standardUserDefaults stringForKey:@"plot.notificationTitle"];

                if(customNotTitlePersistent != nil && ![@"" isEqualToString:customNotTitlePersistent]){
                    notTitle = [NSString stringWithFormat:@"%@ on %@", customNotTitlePersistent, trigger_direction];
                    notText = [standardUserDefaults stringForKey:@"plot.notificationText"];

                    //notification code to notify location change
                    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
                    content.title = [NSString localizedUserNotificationStringForKey:notTitle arguments:nil];
                    content.body = [NSString localizedUserNotificationStringForKey:notText arguments:nil];

                    // Configure the trigger after n*60 seconds
                    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                 triggerWithTimeInterval:notTimeDelay repeats: NO];

                    // Create the request object.
                    UNNotificationRequest* request = [UNNotificationRequest
                        requestWithIdentifier:@"plotproject.ema.notify" content:content trigger:trigger];

                    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
                    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                        if (error != nil) {
                           NSLog(@"PlotProjects - %@", error.localizedDescription);
                        }

                        NSLog(@"PlotProjects - notification scheduled");
                    }];

                    //[standardUserDefaults setDouble:receivedLocation.latitude forKey:@"current_latitude"];
                    //[standardUserDefaults setDouble:receivedLocation.longitude forKey:@"current_longitude"];
                    [standardUserDefaults setObject:[NSString stringWithFormat:@"%lu", (long)NSDate.date.timeIntervalSince1970] forKey:@"plot.surveyTriggered"];
                    [standardUserDefaults synchronize];

                    NSLog(@"PlotProjects - .fired event ComPlotprojectsTiModule");
                }
            }

            break;
        }
    }


    //PlotGeotriggerTriggerEnter
    //PlotGeotriggerTriggerExit

    //NSLog(@"PlotProjects - plotHandleGeotriggers %@ enter %@ exit %@", geotriggers, triggerEnter, triggerExit);

    if (plotInitCalled) {
        [self plotHandleGeotriggersAfterInit:geotriggers];
    } else {
        [geotriggersToHandleQueued addObject:geotriggers];
    }
}

-(void)plotHandleGeotriggersAfterInit:(PlotHandleGeotriggers *)geotriggers {
    if (enableGeotriggerHandler) {
        NSLog(@"PlotProjects - plotHandleGeotriggersAfterInit filter");
        [geotriggersToHandle addObject:geotriggers];
        ComPlotprojectsTiGeotriggerHandler* handler = [[ComPlotprojectsTiGeotriggerHandler alloc] init];
        [handler startHandler];
        [self performSelector:@selector(shutdownHandler:) withObject:handler afterDelay:10];
    } else {
        NSLog(@"PlotProjects - markGeotriggersHandled:");
        [geotriggers markGeotriggersHandled:geotriggers.geotriggers];
    }
}

-(void)shutdownFilter:(ComPlotprojectsTiNotificationFilter*)filter {
    [filter shutdown];
}

-(void)shutdownHandler:(ComPlotprojectsTiGeotriggerHandler*)handler {
    [handler shutdown];
}

-(void)popFilterableNotificationsOnMainThread:(NSMutableDictionary*)result {
    NSArray* notifications;
    NSString* filterId = @"";

    if (notificationsToFilter.count == 0u) {
        //NSLog(@"PlotProjects - pop1 number of notifications to filter %ld", notificationsToFilter.count);
        notifications = @[];
    } else {
        PlotFilterNotifications* n = [notificationsToFilter objectAtIndex:0];
        [notificationsToFilter removeObjectAtIndex:0];

        notifications = n.uiNotifications;
        //NSLog(@"PlotProjects - pop2 number of notifications to filter %ld", notificationsToFilter.count);

        filterId = [NSString stringWithFormat:@"%d", filterIndex++];
        [notificationsBeingFiltered setObject:n forKey:filterId];
    }

    NSMutableArray* jsonNotifications = [NSMutableArray array];
    for (UNNotificationRequest* localNotification in notifications) {
        [jsonNotifications addObject:[ComPlotprojectsTiConversions localNotificationToDictionary:localNotification]];
    }

    [result setObject:filterId forKey:@"filterId"];
    [result setObject:jsonNotifications forKey:@"notifications"];
}

-(void)popGeotriggersOnMainThread:(NSMutableDictionary*)result {
    NSLog(@"PlotProjects - popGeotriggersOnMainThread");
    NSArray* geotriggers;
    NSString* handlerId = @"";
    if (geotriggersToHandle.count == 0u) {
        geotriggers = @[];
    } else {
        PlotHandleGeotriggers* n = [geotriggersToHandle objectAtIndex:0];
        [geotriggersToHandle removeObjectAtIndex:0];

        geotriggers = n.geotriggers;
        handlerId = [NSString stringWithFormat:@"%d", handlerIndex++];
        if (geotriggersBeingHandled == nil) {
            geotriggersBeingHandled = [NSMutableDictionary dictionary];
        }
        [geotriggersBeingHandled setObject:n forKey:handlerId];
    }

    NSMutableArray* jsonGeotriggers = [NSMutableArray array];
    for (PlotGeotrigger* geotrigger in geotriggers) {
        [jsonGeotriggers addObject:[ComPlotprojectsTiConversions geotriggerToDictionary:geotrigger]];
    }

    [result setObject:handlerId forKey:@"handlerId"];
    [result setObject:jsonGeotriggers forKey:@"geotriggers"];
}

@end
