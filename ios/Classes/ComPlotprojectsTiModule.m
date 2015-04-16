/**
 * Copyright 2015 Floating Market B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "ComPlotprojectsTiModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiApp.h"
#import "TiUtils.h"
#import "Plot.h"
#import "ComPlotprojectsTiNotificationFilter.h"
#import "ComPlotprojectsTiGeotriggerHandler.h"

extern NSString * const TI_APPLICATION_DEPLOYTYPE;

static BOOL plotInitialized = NO; //use static variable to prevent initializing Plot again
static int filterIndex = 1;
static BOOL enableNotificationFilter = NO;
static int handlerIndex = 1;
static BOOL enableGeotriggerHandler = NO;

static NSMutableArray* notificationsToBeReceived = nil;
static NSMutableArray* notificationsToFilter = nil;
static NSMutableDictionary* notificationsBeingFiltered = nil;
static NSMutableArray* geotriggersToHandle = nil;
static NSMutableDictionary* geotriggersBeingHandled = nil;

@implementation ComPlotprojectsTiModule

+(void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLocalNotification:)
                                                 name:kTiLocalNotification
                                               object:nil];
}

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"7460f8c0-9f23-486b-be1a-b8beb01e45f6";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"com.plotprojects.ti";
}



#pragma mark Lifecycle


-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

#pragma mark Plot

+(id)objectFromDictionary:(NSDictionary*)dict forKey:(NSString*)key {
    id result = [dict objectForKey:key];
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return result;
}

-(id)nilToNSNull:(id)obj {
    if (obj == nil) {
        return [NSNull null];
    }
    return obj;
}

+(void)didReceiveLocalNotification:(NSNotification*)notification {
    //Transform a notification back to an UILocalNotification
    NSDictionary* dictionary = [notification object];
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [self objectFromDictionary:dictionary forKey:@"date"];
    NSString* timezone = [self objectFromDictionary:dictionary forKey:@"timezone"];
    if (timezone) {
        localNotification.timeZone = [NSTimeZone timeZoneWithName:timezone];
    }
    localNotification.alertBody = [self objectFromDictionary:dictionary forKey:@"alertBody"];
    localNotification.alertAction = [self objectFromDictionary:dictionary forKey:@"alertAction"];
    localNotification.alertLaunchImage = [self objectFromDictionary:dictionary forKey:@"alertLaunchImage"];
    localNotification.soundName = [self objectFromDictionary:dictionary forKey:@"sound"];
    localNotification.applicationIconBadgeNumber = [self objectFromDictionary:dictionary forKey:@"badge"];
    localNotification.userInfo = [self objectFromDictionary:dictionary forKey:@"userInfo"];
    
    if (plotInitialized) {
        [Plot handleNotification:localNotification];
    } else {
        if (notificationsToBeReceived == nil) {
            notificationsToBeReceived = [[NSMutableArray array] retain];
        }
        [notificationsToBeReceived addObject:localNotification];
    }
    [localNotification autorelease];
}

-(void)initPlot:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSNumber* notificationFilterEnabled = [args objectForKey:@"notificationFilterEnabled"];
    if (notificationFilterEnabled != nil) {
        enableNotificationFilter = [notificationFilterEnabled boolValue];
    }

    NSNumber* geotriggerHandlerEnabled = [args objectForKey:@"geotriggerHandlerEnabled"];
    if (geotriggerHandlerEnabled != nil) {
        enableGeotriggerHandler = [geotriggerHandlerEnabled boolValue];
    }
    
    if  (!plotInitialized) {
        NSString* publicToken = [args objectForKey:@"publicToken"];
        
        PlotConfiguration* config = [[PlotConfiguration alloc] initWithPublicKey:publicToken delegate:self];
        
        NSNumber* cooldownPeriod = [args objectForKey:@"cooldownPeriod"];
        
        if (cooldownPeriod != nil) {
            [config setCooldownPeriod:[cooldownPeriod intValue]];
        }
        
        NSNumber* enableOnFirstRun = [args objectForKey:@"enableOnFirstRun"];
        if (enableOnFirstRun != nil) {
            [config setEnableOnFirstRun:[enableOnFirstRun boolValue]];
        }
        
        plotInitialized = YES;
        
        NSDictionary* launchOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"plot-use-file-config"];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        if ([@"test" isEqualToString:TI_APPLICATION_DEPLOYTYPE] || [@"development" isEqualToString:TI_APPLICATION_DEPLOYTYPE]) {
            [PlotDebug initializeWithConfiguration:config launchOptions:launchOptions];
        } else {
            [PlotRelease initializeWithConfiguration:config launchOptions:launchOptions];
        }
#pragma clang diagnostic pop
        
        for (UILocalNotification* n in notificationsToBeReceived) {
            [Plot handleNotification:n];
        }
        notificationsToBeReceived = nil;
    }
}

-(void)enable:(id)args {
    ENSURE_UI_THREAD_0_ARGS
    [Plot enable];
}

-(void)disable:(id)args {
    ENSURE_UI_THREAD_0_ARGS
    [Plot disable];
}

-(BOOL)enabled {
    return [Plot isEnabled];
}

-(void)mailDebugLog:(id)args {
    ENSURE_UI_THREAD_0_ARGS
    
    [Plot mailDebugLog:TiApp.controller];
}

-(NSDictionary*)popFilterableNotifications:(id)args {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [self performSelectorOnMainThread:@selector(popFilterableNotificationsOnMainThread:) withObject:result waitUntilDone:YES];
    return result;
}

-(void)popFilterableNotificationsOnMainThread:(NSMutableDictionary*)result {
    NSArray* notifications;
    NSString* filterId = @"";
    if (notificationsToFilter.count == 0u) {
        notifications = @[];
    } else {
        PlotFilterNotifications* n = [[notificationsToFilter objectAtIndex:0] retain];
        [notificationsToFilter removeObjectAtIndex:0];
        
        notifications = n.uiNotifications;
        filterId = [NSString stringWithFormat:@"%d", filterIndex++];
        if (notificationsBeingFiltered == nil) {
            notificationsBeingFiltered = [[NSMutableDictionary dictionary] retain];
        }
        [notificationsBeingFiltered setObject:n forKey:filterId];
        [n release];
    }
    
    NSMutableArray* jsonNotifications = [NSMutableArray array];
    for (UILocalNotification* localNotification in notifications) {
        [jsonNotifications addObject:[self localNotificationToDictionary:localNotification]];
    }
    
    [result setObject:filterId forKey:@"filterId"];
    [result setObject:jsonNotifications forKey:@"notifications"];
}

-(NSDictionary*)indexLocalNotifications:(NSArray*)notifications {
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:notifications.count];
    
    for (UILocalNotification* notification in notifications) {
        NSString* identifier = [notification.userInfo objectForKey:@"identifier"];
        if (identifier != nil) {
            [result setObject:notification forKey:identifier];
        }
    }
    
    return result;
}

-(UILocalNotification*)transformNotification:(NSDictionary*)data index:(NSDictionary*)index {
    NSString* identifier = [data objectForKey:@"identifier"];
    if (identifier == nil) {
        return nil;
    }
    UILocalNotification* localNotification = [index objectForKey:identifier];
    
    localNotification.alertBody = [data objectForKey:@"message"];
    
    NSMutableDictionary* newUserInfo = [NSMutableDictionary dictionaryWithDictionary:localNotification.userInfo];
    
    [newUserInfo setObject:[data objectForKey:@"message"] forKey:@"message"];
    [newUserInfo setObject:[data objectForKey:@"data"] forKey:@"action"];
    
    localNotification.userInfo = newUserInfo;
    return localNotification;
}

-(void)sendNotifications:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSString* filterId = [args objectForKey:@"filterId"];
    NSArray* notificationsPassed = [args objectForKey:@"notifications"];
    if ([@"" isEqualToString:filterId]) {
        return;
    }
    
    PlotFilterNotifications* filterNotifications = [[notificationsBeingFiltered objectForKey:filterId] retain];
    [notificationsBeingFiltered removeObjectForKey:filterId];
    
    NSDictionary* index = [self indexLocalNotifications:filterNotifications.uiNotifications];
    
    NSMutableArray* result = [NSMutableArray array];
    
    for (NSDictionary* notificationData in notificationsPassed) {
        UILocalNotification* localNotification = [self transformNotification:notificationData index:index];
        if (localNotification != nil) {
            [result addObject:localNotification];
        }
    }
    
    [filterNotifications showNotifications:result];
    [filterNotifications release];
}

// Geotriggers
-(NSDictionary*)popGeotriggers:(id)args {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [self performSelectorOnMainThread:@selector(popGeotriggersOnMainThread:) withObject:result waitUntilDone:YES];
    return result;
}

-(void)popGeotriggersOnMainThread:(NSMutableDictionary*)result {
    NSArray* geotriggers;
    NSString* handlerId = @"";
    if (geotriggersToHandle.count == 0u) {
        geotriggers = @[];
    } else {
        PlotHandleGeotriggers* n = [[geotriggersToHandle objectAtIndex:0] retain];
        [geotriggersToHandle removeObjectAtIndex:0];
        
        geotriggers = n.geotriggers;
        handlerId = [NSString stringWithFormat:@"%d", handlerIndex++];
        if (geotriggersBeingHandled == nil) {
            geotriggersBeingHandled = [[NSMutableDictionary dictionary] retain];
        }
        [geotriggersBeingHandled setObject:n forKey:handlerId];
        [n release];
    }
    
    NSMutableArray* jsonGeotriggers = [NSMutableArray array];
    for (PlotGeotrigger* geotrigger in geotriggers) {
        [jsonGeotriggers addObject:[self geotriggerToDictionary:geotrigger]];
    }
    
    [result setObject:handlerId forKey:@"handlerId"];
    [result setObject:jsonGeotriggers forKey:@"geotriggers"];
}

-(NSDictionary*)indexGeotriggers:(NSArray*)geotriggers {
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:geotriggers.count];
    
    for (PlotGeotrigger* geotrigger in geotriggers) {
        NSString* identifier = [geotrigger.userInfo objectForKey:@"identifier"];
        if (identifier != nil) {
            [result setObject:geotrigger forKey:identifier];
        }
    }
    
    return result;
}

-(PlotGeotrigger*)transformGeotrigger:(NSDictionary*)data index:(NSDictionary*)index {
    NSString* identifier = [data objectForKey:@"identifier"];
    if (identifier == nil) {
        return nil;
    }
    PlotGeotrigger* geotrigger = [index objectForKey:identifier];     
    NSMutableDictionary* newUserInfo = [NSMutableDictionary dictionaryWithDictionary:geotrigger.userInfo];        
    geotrigger.userInfo = newUserInfo;

    return geotrigger;
}

-(void)markGeotriggersHandled:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    NSString* handlerId = [args objectForKey:@"handlerId"];
    NSArray* geotriggersPassed = [args objectForKey:@"geotriggers"];
    if ([@"" isEqualToString:handlerId]) {
        return;
    }
    
    PlotHandleGeotriggers* geotriggerHandler = [[geotriggersBeingHandled objectForKey:handlerId] retain];
    [geotriggersBeingHandled removeObjectForKey:handlerId];
    
    NSDictionary* index = [self indexGeotriggers:geotriggerHandler.geotriggers];
    
    NSMutableArray* result = [NSMutableArray array];
    
    for (NSDictionary* geotriggerData in geotriggersPassed) {
        PlotGeotrigger* geotrigger = [self transformGeotrigger:geotriggerData index:index];
        if (geotrigger != nil) {
            [result addObject:geotrigger];
        }
    }
    
    [geotriggerHandler markGeotriggersHandled:result];
    [geotriggerHandler release];
}

-(void)setCooldownPeriod:(int)period {
    [Plot setCooldownPeriod:period];
}

-(NSString*)version {
    return [Plot version];
}

-(void)plotHandleNotification:(UILocalNotification *)notification data:(NSString *)action {
    [self handleNotification:notification];
}

-(NSDictionary*)localNotificationToDictionary:(UILocalNotification*)notification {
    NSDictionary* eventNotification = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [self nilToNSNull:[notification.userInfo objectForKey:PlotNotificationDataKey]], @"data",
                                       [self nilToNSNull:[notification.userInfo objectForKey:PlotNotificationGeofenceLatitude]], @"geofenceLatitude",
                                       [self nilToNSNull:[notification.userInfo objectForKey:PlotNotificationGeofenceLongitude]], @"geofenceLongitude",
                                       [self nilToNSNull:[notification.userInfo objectForKey:PlotNotificationTrigger]], @"trigger",
                                       [self nilToNSNull:[notification.userInfo objectForKey:PlotNotificationIsBeacon]], @"isBeacon",
                                       [self nilToNSNull:notification.alertBody], @"message",
                                       [self nilToNSNull:[notification.userInfo objectForKey:PlotNotificationIdentifier]], @"identifier",
                                       nil];
    
    
    return eventNotification;
}

-(NSDictionary*)geotriggerToDictionary:(PlotGeotrigger*)geotrigger {
    NSDictionary* eventGeotrigger = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerDataKey]], @"data",
                                       [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerGeofenceLatitude]], @"geofenceLatitude",
                                       [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerGeofenceLongitude]], @"geofenceLongitude",
                                       [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerTrigger]], @"trigger",
                                       [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerIsBeacon]], @"isBeacon",
                                       [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerName]], @"name",
                                       [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotNotificationIdentifier]], @"identifier",
                                       nil];
    
    
    return eventGeotrigger;
}

-(void)handleNotification:(UILocalNotification*)notification {
    if ([self _hasListeners:@"plotNotificationReceived"]) {
        NSDictionary* eventNotification = [self localNotificationToDictionary:notification];
        [self fireEvent:@"plotNotificationReceived" withObject:eventNotification];
    } else {
        NSString* data = [notification.userInfo objectForKey:@"action"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data]];
    }
}

-(void)plotFilterNotifications:(PlotFilterNotifications *)filterNotifications {
    if (enableNotificationFilter) {
        if (notificationsToFilter == nil) {
            notificationsToFilter = [[NSMutableArray array] retain];
        }
        [notificationsToFilter addObject:filterNotifications];
        ComPlotprojectsTiNotificationFilter* filter = [[ComPlotprojectsTiNotificationFilter alloc] init];
        [filter startFilter];
        [self performSelector:@selector(shutdownFilter:) withObject:filter afterDelay:10];
    } else {
        [filterNotifications showNotifications:filterNotifications.uiNotifications];
    }
}

-(void)plotHandleGeotriggers:(PlotHandleGeotriggers *)geotriggers {
    if (enableGeotriggerHandler) {
        if (geotriggersToHandle == nil) {
            geotriggersToHandle = [[NSMutableArray array] retain];
        }
        [geotriggersToHandle addObject:geotriggers];
        ComPlotprojectsTiGeotriggerHandler* handler = [[ComPlotprojectsTiGeotriggerHandler alloc] init];
        [handler startHandler];
        [self performSelector:@selector(shutdownHandler:) withObject:handler afterDelay:10];
    } else {
        [geotriggers markGeotriggersHandled:geotriggers.geotriggers];
    }
}

-(void)shutdownFilter:(ComPlotprojectsTiNotificationFilter*)filter {
    [filter shutdown];
    [filter autorelease];
}

-(void)shutdownHandler:(ComPlotprojectsTiGeotriggerHandler*)handler {
    [handler shutdown];
    [handler autorelease];
}

@end
