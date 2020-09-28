/**
 * com.meiresearch.android.plotprojects
 *
 * Created by Jon Kravetz
 * Copyright (c) 2020 Your Company. All rights reserved.
 */

#import "ComMeiresearchAndroidPlotprojectsModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"

@implementation ComMeiresearchAndroidPlotprojectsModule

#pragma mark Internal

// This is generated for your module, please do not change it
- (id)moduleGUID
{
  return @"ca7b8770-fe1a-4770-8a95-cf2a5ca98376";
}

// This is generated for your module, please do not change it
- (NSString *)moduleId
{
  return @"com.meiresearch.android.plotprojects";
}

#pragma mark Lifecycle

- (void)startup
{
  // This method is called when the module is first loaded
  // You *must* call the superclass
  [super startup];
  DebugLog(@"[DEBUG] %@ loaded", self);
}

#pragma Public APIs

- (NSString *)example:(id)args
{
  // Example method. 
  // Call with "MyModule.example(args)"
  return @"hello world";
}

- (NSString *)exampleProp
{
  // Example property getter. 
  // Call with "MyModule.exampleProp" or "MyModule.getExampleProp()"
  return @"Titanium rocks!";
}

- (void)setExampleProp:(id)value
{
  // Example property setter. 
  // Call with "MyModule.exampleProp = 'newValue'" or "MyModule.setExampleProp('newValue')"
}

@end
