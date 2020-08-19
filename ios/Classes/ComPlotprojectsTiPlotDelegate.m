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

        NSLog(@"Init ComPlotprojectsTiPlotDelegate");
    }
    return self;
}

-(void)initCalled {
    plotInitCalled = YES;

    NSLog(@"number of notifications to filter: %ld", notificationsToFilterQueued.count);
    for (PlotFilterNotifications* n in notificationsToFilterQueued) {
        [self plotFilterNotificationsAfterInit:n];
    }
    [notificationsToFilterQueued removeAllObjects];

    NSLog(@"number of notifications to handle %ld", notificationsToHandleQueued.count);
    for (UNNotificationRequest* n in notificationsToHandleQueued) {
        [handleNotificationDelegate handleNotification:n];
    }
    [notificationsToHandleQueued removeAllObjects];

    NSLog(@"number of geotriggers to handle %ld", geotriggersToHandleQueued.count);
    for (PlotHandleGeotriggers* g in geotriggersToHandleQueued) {
        [self plotHandleGeotriggersAfterInit:g];
    }
    [geotriggersToHandleQueued removeAllObjects];
}

-(void)plotHandleNotification:(UNNotificationRequest*)notification data:(NSString*)data {
    //NSLog(@"plotHandleNotification");
    if (plotInitCalled) {
        //NSLog(@"Handling notification... %@", notification.content.userInfo);
        [handleNotificationDelegate handleNotification:notification];
    } else {
        [notificationsToHandleQueued addObject:notification];
    }
}

-(void)showNotificationsOnMainThread:(NSString *)filterId notifications:(NSArray *)notificationsPassed {
    //NSLog(@"showNotificationsOnMainThread");
    PlotFilterNotifications* filterNotifications = [notificationsBeingFiltered objectForKey:filterId];
    if (filterNotifications == nil) {
        //NSLog(@"Unknown filter with id: %@", filterId);
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
    //NSLog(@"handleGeotriggersOnMainThread");
    PlotHandleGeotriggers* geotriggerHandler = [geotriggersBeingHandled objectForKey:handlerId];
    if (geotriggerHandler == nil) {
        //NSLog(@"Unknown handler with id: %@", handlerId);
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
            //NSLog(@"Wrong type, expected UNNotificationRequest, got %@", NSStringFromClass([notification class]));
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
        //NSLog(@"Delegate defined, filtering notification...");
        [self plotFilterNotificationsAfterInit:notification];
    } else {
        //NSLog(@"Delegate undefined, not filtering");
        [notificationsToFilterQueued addObject:notification];
    }
}

-(void)plotFilterNotificationsAfterInit:(PlotFilterNotifications *)filterNotifications {
    if (enableNotificationFilter) {
        //NSLog(@"Size of list to filter id %ld", notificationsToFilter.count);

        [notificationsToFilter addObject:filterNotifications];

        ComPlotprojectsTiNotificationFilter* filter = [[ComPlotprojectsTiNotificationFilter alloc] init];
        [filter startFilter];
        [self performSelector:@selector(shutdownFilter:) withObject:filter afterDelay:10];
    } else {
        //NSLog(@"showNotifications");
        [filterNotifications showNotifications:filterNotifications.uiNotifications];
    }
}

-(void)plotHandleGeotriggers:(PlotHandleGeotriggers*)geotrigger {
    //NSLog(@"plotHandleGeotriggers");
    if (plotInitCalled) {
        [self plotHandleGeotriggersAfterInit:geotrigger];
    } else {
        [geotriggersToHandleQueued addObject:geotrigger];
    }
}

-(void)plotHandleGeotriggersAfterInit:(PlotHandleGeotriggers *)geotriggers {
    if (enableGeotriggerHandler) {
        //NSLog(@"plotHandleGeotriggersAfterInit filter");
        [geotriggersToHandle addObject:geotriggers];
        ComPlotprojectsTiGeotriggerHandler* handler = [[ComPlotprojectsTiGeotriggerHandler alloc] init];
        [handler startHandler];
        [self performSelector:@selector(shutdownHandler:) withObject:handler afterDelay:10];
    } else {
        //NSLog(@"markGeotriggersHandled:");
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
        //NSLog(@"pop1 number of notifications to filter %ld", notificationsToFilter.count);
        notifications = @[];
    } else {
        PlotFilterNotifications* n = [notificationsToFilter objectAtIndex:0];
        [notificationsToFilter removeObjectAtIndex:0];

        notifications = n.uiNotifications;
        //NSLog(@"pop2 number of notifications to filter %ld", notificationsToFilter.count);

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
