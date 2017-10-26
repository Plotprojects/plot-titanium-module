//
//  ComPlotprojectsTiPlotDelegate.h
//  plot-ios-module
//
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>
#import <PlotProjects/Plot.h>

@protocol ComPlotprojectsTiHandleNotificationDelegate <NSObject>
@required
-(void)handleNotification:(UNNotificationRequest*)notification;

@end

@interface ComPlotprojectsTiPlotDelegate : NSObject<PlotDelegate> {    
    NSMutableArray<PlotFilterNotifications*>* notificationsToFilter;
    NSMutableArray<PlotHandleGeotriggers*>* geotriggersToHandle;
    
    NSMutableArray<UNNotificationRequest*>* notificationsToHandleQueued;
    NSMutableArray<PlotFilterNotifications*>* notificationsToFilterQueued;
    NSMutableArray<PlotHandleGeotriggers*>* geotriggersToHandleQueued;
    
    NSMutableDictionary<NSString*, PlotFilterNotifications*>* notificationsBeingFiltered;
    NSMutableDictionary<NSString*, PlotHandleGeotriggers*>* geotriggersBeingHandled;
    
    __weak id<ComPlotprojectsTiHandleNotificationDelegate> handleNotificationDelegate;
    
    BOOL enableNotificationFilter;
    BOOL enableGeotriggerHandler;
    BOOL plotInitCalled;
    
    int filterIndex;
    int handlerIndex;
}
@property(assign, nonatomic) BOOL enableNotificationFilter;
@property(assign, nonatomic) BOOL enableGeotriggerHandler;
@property(weak, nonatomic) id<ComPlotprojectsTiHandleNotificationDelegate> handleNotificationDelegate;

-(void)popFilterableNotificationsOnMainThread:(NSMutableDictionary*)result;
-(void)popGeotriggersOnMainThread:(NSMutableDictionary*)result;

-(void)showNotificationsOnMainThread:(NSString*)filterId notifications:(NSArray*)notifications;
-(void)handleGeotriggersOnMainThread:(NSString*)handlerId geotriggers:(NSArray*)geotriggersPassed;

-(void)initCalled;

@end
