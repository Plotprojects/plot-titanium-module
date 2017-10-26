/**
 * Copyright 2017 Floating Market B.V.
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
#import "ComPlotprojectsTiConversions.h"


@implementation ComPlotprojectsTiConversions

+(NSDictionary*)sentGeotriggerToDictionary:(PlotSentGeotrigger*)geotrigger {
    NSDictionary* userInfo = geotrigger.userInfo;
    NSMutableDictionary* eventGeotrigger = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                            [self nilToNSNull:[userInfo objectForKey:PlotGeotriggerDataKey]], @"data",
                                            [self nilToNSNull:[userInfo objectForKey:PlotGeotriggerGeofenceLatitude]], @"geofenceLatitude",
                                            [self nilToNSNull:[userInfo objectForKey:PlotGeotriggerGeofenceLongitude]], @"geofenceLongitude",
                                            [self nilToNSNull:[userInfo objectForKey:PlotGeotriggerTrigger]], @"trigger",
                                            [self nilToNSNull:[userInfo objectForKey:PlotGeotriggerIsBeacon]], @"isBeacon",
                                            [self nilToNSNull:[userInfo objectForKey:PlotGeotriggerName]], @"name",
                                            [self nilToNSNull:[userInfo objectForKey:PlotGeotriggerIdentifier]], @"identifier",
                                            [self nilToNSNull:[userInfo objectForKey:PlotNotificationMatchIdentifier]], @"matchIdentifier",
                                            [self nilToNSNull:[userInfo objectForKey:PlotGeotriggerMatchRange]], @"matchRange",
                                            @((int) [geotrigger.dateSent timeIntervalSince1970]), @"dateSent",
                                            nil];
    
    if (geotrigger.dateHandled != nil) {
        [eventGeotrigger setObject:@((int) [geotrigger.dateHandled timeIntervalSince1970]) forKey:@"dateHandled"];
        [eventGeotrigger setObject:@(YES) forKey:@"isHandled"];
    } else {
        [eventGeotrigger setObject:@(-1) forKey:@"dateHandled"];
        [eventGeotrigger setObject:@(NO) forKey:@"isHandled"];
    }
    
    return eventGeotrigger;
}

+(NSDictionary*)localNotificationToDictionary:(UNNotificationRequest*)notification {
    NSDictionary* eventNotification = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [self nilToNSNull:[notification.content.userInfo objectForKey:PlotNotificationDataKey]], @"data",
                                       [self nilToNSNull:[notification.content.userInfo objectForKey:PlotNotificationGeofenceLatitude]], @"geofenceLatitude",
                                       [self nilToNSNull:[notification.content.userInfo objectForKey:PlotNotificationGeofenceLongitude]], @"geofenceLongitude",
                                       [self nilToNSNull:[notification.content.userInfo objectForKey:PlotNotificationTrigger]], @"trigger",
                                       [self nilToNSNull:[notification.content.userInfo objectForKey:PlotNotificationIsBeacon]], @"isBeacon",
                                       [self nilToNSNull:notification.content.body], @"message",
                                       [self nilToNSNull:[notification.content.userInfo objectForKey:PlotNotificationIdentifier]], @"identifier",
                                       [self nilToNSNull:[notification.content.userInfo objectForKey:PlotNotificationMatchRange]], @"matchRange",
                                       [self nilToNSNull:[notification.content.userInfo objectForKey:PlotNotificationHandlerType]], @"notificationHandlerType",
                                       nil];
    
    return eventNotification;
}

+(NSDictionary*)geotriggerToDictionary:(PlotGeotrigger*)geotrigger {
    NSDictionary* eventGeotrigger = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerDataKey]], @"data",
                                     [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerGeofenceLatitude]], @"geofenceLatitude",
                                     [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerGeofenceLongitude]], @"geofenceLongitude",
                                     [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerTrigger]], @"trigger",
                                     [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerIsBeacon]], @"isBeacon",
                                     [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerName]], @"name",
                                     [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerIdentifier]], @"identifier",
                                     [self nilToNSNull:[geotrigger.userInfo objectForKey:PlotGeotriggerMatchRange]], @"matchRange",
                                     nil];
    
    return eventGeotrigger;
}

+(NSDictionary*)sentNotificationToDictionary:(PlotSentNotification*)notification {
    NSDictionary* userInfo = notification.userInfo;
    NSMutableDictionary* eventNotification = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                              [self nilToNSNull:[userInfo objectForKey:PlotNotificationDataKey]], @"data",
                                              [self nilToNSNull:[userInfo objectForKey:PlotNotificationGeofenceLatitude]], @"geofenceLatitude",
                                              [self nilToNSNull:[userInfo objectForKey:PlotNotificationGeofenceLongitude]], @"geofenceLongitude",
                                              [self nilToNSNull:[userInfo objectForKey:PlotNotificationTrigger]], @"trigger",
                                              [self nilToNSNull:[userInfo objectForKey:PlotNotificationIsBeacon]], @"isBeacon",
                                              [self nilToNSNull:[userInfo objectForKey:PlotNotificationMessage]], @"message",
                                              [self nilToNSNull:[userInfo objectForKey:PlotNotificationIdentifier]], @"identifier",
                                              [self nilToNSNull:[userInfo objectForKey:PlotNotificationMatchIdentifier]], @"matchIdentifier",
                                              [self nilToNSNull:[userInfo objectForKey:PlotNotificationMatchRange]], @"matchRange",
                                              [self nilToNSNull:[userInfo objectForKey:PlotNotificationHandlerType]], @"notificationHandlerType",
                                              @((int)[notification.dateSent timeIntervalSince1970]), @"dateSent",
                                              nil];
    
    if (notification.dateOpened != nil) {
        [eventNotification setObject:@((int)[notification.dateOpened timeIntervalSince1970]) forKey:@"dateOpened"];
        [eventNotification setObject:@(YES) forKey:@"isOpened"];
    } else {
        [eventNotification setObject:@(-1) forKey:@"dateOpened"];
        [eventNotification setObject:@(NO) forKey:@"isOpened"];
    }
    
    return eventNotification;
}

+(UNNotificationRequest*)transformNotification:(NSDictionary*)data index:(NSDictionary<NSString*, UNNotificationRequest*>*)index {
    NSString* identifier = [data objectForKey:@"identifier"];
    if (identifier == nil) {
        return nil;
    }
    UNNotificationRequest* notificationRequest = [index objectForKey:identifier];
    if (![notificationRequest isKindOfClass:[UNNotificationRequest class]]) {
        NSLog(@"UNNotificationRequest is of wrong type, %@", NSStringFromClass([notificationRequest class]));
        return nil;
    }
    
    NSMutableDictionary* newUserInfo = [NSMutableDictionary dictionaryWithDictionary:notificationRequest.content.userInfo];
    
    NSString* message = [data objectForKey:@"message"];
    if (message == nil) {
        message = @"";
    }
    
    
    [newUserInfo setObject:message forKey:PlotNotificationMessage];
    [newUserInfo setObject:[data objectForKey:@"data"] forKey:PlotNotificationDataKey];
    
    UNMutableNotificationContent* newContent = [notificationRequest.content mutableCopy];
    newContent.userInfo = newUserInfo;
    NSString* escapedBody = [message stringByReplacingOccurrencesOfString:@"%" withString:@"%%"];
    newContent.title = escapedBody;
    newContent.body = escapedBody;
    
    UNNotificationRequest* newLocalNotification = [UNNotificationRequest requestWithIdentifier:notificationRequest.identifier
                                                                                       content:newContent
                                                                                       trigger:notificationRequest.trigger];
    
    return newLocalNotification;
}

+(PlotGeotrigger*)transformGeotrigger:(NSDictionary*)data index:(NSDictionary*)index {
    NSString* identifier = [data objectForKey:@"identifier"];
    if (identifier == nil) {
        return nil;
    }
    PlotGeotrigger* geotrigger = [index objectForKey:identifier];
    if (![geotrigger isKindOfClass:[PlotGeotrigger class]]) {
        NSLog(@"PlotGeotrigger is of wrong type, %@", NSStringFromClass([PlotGeotrigger class]));
        return nil;
    }
    NSMutableDictionary* newUserInfo = [NSMutableDictionary dictionaryWithDictionary:geotrigger.userInfo];
    geotrigger.userInfo = newUserInfo;
    
    return geotrigger;
}

+(id)nilToNSNull:(id)obj {
    if (obj == nil) {
        return [NSNull null];
    }
    return obj;
}

@end
