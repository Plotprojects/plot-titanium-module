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

#import <UIKit/UIKit.h>
#import "ComPlotprojectsTiModule.h"
#import "ComPlotprojectsTiConversions.h"
#import <UserNotifications/UserNotifications.h>
#import <PlotProjects/Plot.h>

extern NSString * const TI_APPLICATION_DEPLOYTYPE;

static NSDictionary* launchOptions;
static ComPlotprojectsTiPlotDelegate* plotDelegate;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation ComPlotprojectsTiModule

+(void)load {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
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

+(void)didFinishLaunching:(NSNotification*)notification {
    launchOptions = notification.userInfo;
    if (launchOptions == nil) {
        launchOptions = [NSDictionary dictionary];
    }
    
    plotDelegate = [[ComPlotprojectsTiPlotDelegate alloc] init];
    
    if ([@"production" isEqualToString:[TI_APPLICATION_DEPLOYTYPE lowercaseString]]) {
      [PlotRelease initializeWithDelegate:plotDelegate];
           } else {

                [PlotDebug initializeWithDelegate:plotDelegate];
    }
}

-(void)initPlot:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    //NSLog(@"initPlot");
    
    NSNumber* notificationFilterEnabled = [args objectForKey:@"notificationFilterEnabled"];
    if (notificationFilterEnabled != nil) {
        plotDelegate.enableNotificationFilter = [notificationFilterEnabled boolValue];
    }
    
    NSNumber* geotriggerHandlerEnabled = [args objectForKey:@"geotriggerHandlerEnabled"];
    if (geotriggerHandlerEnabled != nil) {
        plotDelegate.enableGeotriggerHandler = [geotriggerHandlerEnabled boolValue];
    }
    
    //NSLog(@"launch options is nil: %i", launchOptions == nil);
    
    if (launchOptions != nil) {
        plotDelegate.handleNotificationDelegate = self;
        [plotDelegate initCalled];
        launchOptions = nil;
    }
}

-(void)handleNotification:(UNNotificationRequest*)notification {
    if ([self _hasListeners:@"plotNotificationReceived"]) {
        NSDictionary* eventNotification = [ComPlotprojectsTiConversions localNotificationToDictionary:notification];
        [self fireEvent:@"plotNotificationReceived" withObject:eventNotification];
    } else {
        NSString* data = [notification.content.userInfo objectForKey:@"action"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:data] options:@{} completionHandler:^(BOOL success){
            if(!success) {
                //NSLog(@"Unable to open URL.");
            }
        }];
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

-(void)setStringSegmentationProperty:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    
    NSString* key = nil;
    ENSURE_ARG_AT_INDEX(key, args, 0, NSString);
    
    NSString* value = nil;
    ENSURE_ARG_AT_INDEX(value, args, 1, NSString);
    
    [Plot setStringSegmentationProperty:value forKey:key];
}

-(void)setBooleanSegmentationProperty:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    
    NSString* key = nil;
    ENSURE_ARG_AT_INDEX(key, args, 0, NSString);
    
    NSNumber* value = nil;
    ENSURE_ARG_AT_INDEX(value, args, 1, NSNumber);
    
    [Plot setBooleanSegmentationProperty:[value boolValue] forKey:key];
}

-(void)setIntegerSegmentationProperty:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    
    NSString* key = nil;
    ENSURE_ARG_AT_INDEX(key, args, 0, NSString);
    
    NSNumber* value = nil;
    ENSURE_ARG_AT_INDEX(value, args, 1, NSNumber);
    
    [Plot setIntegerSegmentationProperty:[value longLongValue] forKey:key];
}

-(void)setDoubleSegmentationProperty:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    
    NSString* key = nil;
    ENSURE_ARG_AT_INDEX(key, args, 0, NSString);
    
    NSNumber* value = nil;
    ENSURE_ARG_AT_INDEX(value, args, 1, NSNumber);
    
    //NSLog(@"%@", value);
    
    [Plot setDoubleSegmentationProperty:[value doubleValue] forKey:key];
}

-(void)setDateSegmentationProperty:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    
    NSString* key = nil;
    ENSURE_ARG_AT_INDEX(key, args, 0, NSString);
    
    NSDate* value = nil;
    ENSURE_ARG_AT_INDEX(value, args, 1, NSDate);
    
    [Plot setDateSegmentationProperty:value forKey:key];
}

-(void)mailDebugLog:(id)args {
    ENSURE_UI_THREAD_0_ARGS
    
    [Plot mailDebugLog:TiApp.controller];
}

-(NSDictionary*)popFilterableNotifications:(id)args {
    //NSLog(@"popFilterableNotifications");
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [plotDelegate performSelectorOnMainThread:@selector(popFilterableNotificationsOnMainThread:) withObject:result waitUntilDone:YES];
    return result;
}

-(void)sendNotifications:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    //NSLog(@"sendNotifications:");
    
    NSString* filterId = [args objectForKey:@"filterId"];
    NSArray* notificationsPassed = [args objectForKey:@"notifications"];
    if (filterId == nil || [@"" isEqualToString:filterId]) {
        return;
    }
    [plotDelegate showNotificationsOnMainThread:filterId notifications:notificationsPassed];
}

-(NSDictionary*)popGeotriggers:(id)args {
    NSMutableDictionary* result = [NSMutableDictionary dictionary];
    [plotDelegate performSelectorOnMainThread:@selector(popGeotriggersOnMainThread:) withObject:result waitUntilDone:YES];
    return result;
}

-(void)markGeotriggersHandled:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    
    //NSLog(@"markGeotriggersHandled");
    
    NSString* handlerId = [args objectForKey:@"handlerId"];
    NSArray* geotriggersPassed = [args objectForKey:@"geotriggers"];
    if (handlerId == nil || [@"" isEqualToString:handlerId]) {
        return;
    }
    
    [plotDelegate handleGeotriggersOnMainThread:handlerId geotriggers:geotriggersPassed];
}

-(void)setCooldownPeriod:(int)period {
    [Plot setCooldownPeriod:period];
}

-(NSString*)version {
    return [Plot version];
}

-(NSArray*)getLoadedNotifications:(id)args {
    NSArray* notifications = [Plot loadedNotifications];
    NSMutableArray* jsonNotifications = [NSMutableArray array];
    for (UNNotificationRequest* localNotification in notifications) {
        [jsonNotifications addObject:[ComPlotprojectsTiConversions localNotificationToDictionary:localNotification]];
    }
	return jsonNotifications;
}

-(NSArray*)getLoadedGeotriggers:(id)args {
	NSArray* geotriggers = [Plot loadedGeotriggers];
	NSMutableArray* jsonGeotriggers = [NSMutableArray array];
    for (PlotGeotrigger* geotrigger in geotriggers) {
        [jsonGeotriggers addObject:[ComPlotprojectsTiConversions geotriggerToDictionary:geotrigger]];
    }
	return jsonGeotriggers;
}

-(NSArray*)getSentNotifications:(id)args {
    NSArray* notifications = [Plot sentNotifications];
    NSMutableArray* jsonNotifications = [NSMutableArray array];
    for (PlotSentNotification* sentNotification in notifications) {
        [jsonNotifications addObject:[ComPlotprojectsTiConversions sentNotificationToDictionary:sentNotification]];
    }
    return jsonNotifications;
}

-(NSArray*)getSentGeotriggers:(id)args {
    NSArray* geotriggers = [Plot sentGeotriggers];
    NSMutableArray* jsonGeotriggers = [NSMutableArray array];
    for (PlotSentGeotrigger* sentGeotrigger in geotriggers) {
        [jsonGeotriggers addObject:[ComPlotprojectsTiConversions sentGeotriggerToDictionary:sentGeotrigger]];
    }
    return jsonGeotriggers;
}

-(void)clearSentNotifications:(id)args {
    [Plot clearSentNotifications];
}

-(void)clearSentGeotriggers:(id)args {
    [Plot clearSentGeotriggers];
}

@end

#pragma clang diagnostic pop
