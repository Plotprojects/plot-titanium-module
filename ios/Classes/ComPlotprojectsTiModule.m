/**
 * Copyright 2013 Floating Market B.V.
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
#import "TiUtils.h"
#import "Plot.h"

static NSDictionary* launchOptions;

@implementation ComPlotprojectsTiModule

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

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

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

+(void)load {
    NSLog(@"Plot Loaded");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didFinishLaunching:)
                                                 name:UIApplicationDidFinishLaunchingNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveLocalNotification:)
                                                 name:kTiLocalNotification
                                               object:nil];
}

+(void)didFinishLaunching:(NSNotification*)notification {
    launchOptions = notification.userInfo;
    if (launchOptions == nil) {
        //launchOptions is nil when not start because of notification or url open
        launchOptions = [NSDictionary dictionary];
    }
}

+(id)objectFromDictionary:(NSDictionary*)dict forKey:(NSString*)key {
    id result = [dict objectForKey:key];
    if ([result isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return result;
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
    
    [Plot handleNotification:localNotification];
    
}

-(void)initPlot:(id)args {
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args,NSDictionary);
    if  (launchOptions != nil) {
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
        
        NSNumber* enableBackgroundModeWarning = [args objectForKey:@"enableBackgroundModeWarning"];
        if (enableBackgroundModeWarning != nil) {
            [config setEnableBackgroundModeWarning:[enableBackgroundModeWarning boolValue]];
        }
        
        [Plot initializeWithConfiguration:config launchOptions:launchOptions];
        launchOptions = nil;
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

-(void)setCooldownPeriod:(int)period {
    [Plot setCooldownPeriod:period];
}

-(void)setEnableBackgroundModeWarning:(BOOL)enabled {
    [Plot setEnableBackgroundModeWarning:enabled];
}

-(NSString*)version {
    return [Plot version];
}

@end
