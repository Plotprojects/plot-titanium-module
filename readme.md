Plot Appcelerator Titanium module
=================================
A module for Appcelerator Titanium apps that adds location based notifications to your app.

### Supported platforms ###

This module was developed for Titanium 3.1.3.GA or newer.
This plugins supports both IOS and Android.


### Integration ###

You can find the full integration guide at our website:

:book: [Full Integration Guide](https://files.plotprojects.com/documentation/#appcelerator-integration):book: [Quick Integration Guide](https://www.plotprojects.com/quick-install#appcelerator)

### Configuration ###

Additional settings are possible using the `plotconfig.json` configuration file, an example is shown below. More information about where to place the configuration file, please have a look at [the integration guide](https://files.plotprojects.com/documentation/#appcelerator-integration). The publicToken and enableOnFirstRun fields are required, the notificationSmallIcon, notificationAccentColor and askPermissionAgainAfterDays options are Android only, the maxRegionsMonitored is an iOS only setting.
	
Information about these settings can be found in our extensive documentation, in chapter 1.4: [http://www.plotprojects.com/documentation#ConfigurationFile](http://www.plotprojects.com/documentation#ConfigurationFile)

```	
{
  "publicToken": "REPLACE_ME",
  "enableOnFirstRun": true,
  "notificationSmallIcon": "ic_mood_white_24dp",
  "notificationAccentColor": "#01579B",
  "askPermissionAgainAfterDays": 3,	
  "maxRegionsMonitored": 20	
}
```

### Function reference ###

_plot.addEventListener("plotNotificationReceived", func)_

Allows specifying your own handler when a notification is opened by the user. The function is passed a notification object, which has the fields "message", "data" and "identifier". When no listener is added, then the "data" field will be treated as URI and opened. **Be sure to call this method before _plotInit_ is called.**

_plot.initPlot(config)_

Initializes Plot. You must call this method before calling other methods other than the notification handler Plot provides. Please note that initialization is asynchronous. Any other calls to the Plot library should wait at least 1000 ms (e.g. use setTimeout).
The _config_ parameter is an object and may have the following properties:

<table>
<tr>
<td>publicToken</td><td>Your public token <em>Deprecated, use configuration file instead</em></td>
</tr><tr>
<td>cooldownPeriod</td><td>The cooldown period between notifications in seconds. (default disabled) <em>Deprecated, use setCooldownPeriod() instead</em></td>
</tr><tr>
<td>enableOnFirstRun</td><td>Whether Plot should be automatically enabled on the first run (default true) <em>Deprecated, use configuration file instead</em></td>
</tr><tr>
<td>notificationFilterEnabled</td><td>Whether the notification filter should be enabled. See section about <a href="#notification-filter">Notification Filter</a> for more information. (default disabled)</td>
</tr><tr>
<td>geotriggerHandlerEnabled</td><td>Whether the geotrigger handler should be enabled. See section about <a href="#geotrigger-handler">Geotrigger Handler</a> for more information. (default disabled)</td>
</tr>
</table>

_plot.enable()_

Enables Plot.

_plot.disable()_

Disables Plot.

_plot.enabled_

Returns whether plot is enabled (read-only).

_plot.setCooldownPeriod(cooldownSeconds)_

Updates the cooldown period.

_plot.version_

Returns the current version of the Plot plugin.

_plot.popFilterableNotifications()_

Returns an object which contains the notifications that can be filtered or edited. The notifications are in the _notifications_ property. The other properties are read-only. Only to be called from the Notification Filter.

_plot.sendNotifications(filterableNotifications)_

Sends the modified notifications returned from popFilterableNotifications(). Only call this method once per call to popFilterableNotifications(). Only to be called from the Notification Filter.

_plot.mailDebugLog()_

Sends the collected debug log via mail. It will open your mail application to send the mail.

_plot.popGeotriggers()_

Returns an object which contains the geotriggers that can be handled. The geotriggers are in the _geotriggers_ property. All properties are read-only. Only to be called from the Geotrigger Handler.

_plot.markGeotriggersHandled(geotriggers)_

Sends the handled geotriggers obtained from popGeotriggers(). Only call this method once per call to popGeotriggers(). Only to be called from the Geotrigger Handler.

### Function reference - Segmentation ###

More information about this feature can be found on our documentation page: [http://www.plotprojects.com/documentation#appcelerator_segmentation](http://www.plotprojects.com/documentation#appcelerator_segmentation)

_plot.setStringSegmentationProperty(property, value)_

Sets a string property for the device on which notifications can be segmented.

_plot.setBooleanSegmentationProperty(property, value)_

Sets a boolean property for the device on which notifications can be segmented.

_plot.setIntegerSegmentationProperty(property, value)_

Sets an integer property for the device on which notifications can be segmented.

_plot.setDoubleSegmentationProperty(property, value)_

Sets a double property for the device on which notifications can be segmented.

_plot.setDateSegmentationProperty(property, value)_

Sets a date property for the device on which notifications can be segmented. Value should be a JavaScript Date.

### Notification Filter ###

The notification filter allows you to filter out or edit notifications before they are shown. To enable the notification filter, you add the property _notificationFilterEnabled_ with the value _true_ to object passed to initPlot. When the notification filter is disabled the notification filter script won't be executed and all notifications will shown.

You define the filter in _assets/plotfilter.js_. When Plot detects that a notification could be shown, it executes the script. The script runs in a different context than the normal scripts are executed. Therefore you cannot reference views or global variables from the notification filter.

The message and the data property of the notification can be modified. You can remove notifications from the array you don't want to show. Always call _plot.popFilterableNotifications()_ and _plot.sendNotifications(filterableNotifications)_, even when no notifications will be shown. 

An example for _assets/plotfilter.js_:
```
var plot = require('com.plotprojects.ti');

Ti.API.info('Notification Filter. Plot version: ' + plot.version);

var filterableNotifications = plot.popFilterableNotifications();

for (var i = 0; i < filterableNotifications.notifications.length; i++) {
    var n = filterableNotifications.notifications[i];
    n.message = "TestMessage: " + n.message;
    n.data = "Test123: " + n.data;
}

//always call plot.sendNotifications function, even if filterableNotifications.notifications becomes empty 
plot.sendNotifications(filterableNotifications); 
```

### Geotrigger Handler ###

When you want to handle your geotriggers, or use them as trigger events for your own code, you can use the geotrigger handler. To enable the geotrigger handler, you add the property _geotriggerHandlerEnabled_ with the value _true_ to object passed to initPlot. When the geotrigger handler is disabled all geotriggers will be counted as handled.

You define the handler in _assets/plotgeotriggerhandler.js_. When Plot detects that a geotrigger has triggered, it executes the script. The script runs in a different context than the normal scripts are executed. Therefore you cannot reference views or global variables from the geotrigger handler.

You can remove geotriggers from the array you don't want to mark as handled. Always call _plot.popGeotriggers()_ and _plot.markGeotriggersHandled(geotriggers)_.

An example for _assets/plotgeotriggerhandler.js_:
```
var plot = require('com.plotprojects.ti');

Ti.API.info('Plot version: ' + plot.version);

var geotriggersHandler = plot.popGeotriggers();
var geotriggersPassed = [];

for (var i = 0; i < geotriggersHandler.geotriggers.length; i++) {
    var geotrigger = geotriggersHandler.geotriggers[i];
    if (geotrigger.data == "pass") {
        geotriggersPassed.push(geotrigger);
    }

    Ti.API.info(JSON.stringify(geotrigger));
}

//always call plot.markGeotriggersHandled function, even if geotriggersHandler.geotriggers becomes empty
plot.markGeotriggersHandled(geotriggersPassed);
```

### Retrieve cached notifications or geotriggers ###

It is possible to retrieve the list of notifications and geotriggers the Plot library is currently listening to. You can, for example, use this to show the user what is near him. This can also be used to see what Plot has loaded for debugging purposes.

You can call _plot.getLoadedNotifications()_ to retrieve the notifications, and call _plot.getLoadedGeotriggers()_ to retrieve the geotriggers.

Please note that this is an optional feature and not needed in order for the Plot library to work.
 
An example implementation would be
```
var plot = require('com.plotprojects.ti');

var cachedNotifications = plot.getLoadedNotifications();
var cachedGeotriggers = plot.getLoadedGeotriggers();
```

### Retrieve sent notifications or geotriggers ###

It is possible to get a list of the notifications and geotriggers that have been sent by this library. You can call the methods _plot.getSentNotifications()_ and _plot.getSentGeotriggers()_
to get a list of the 100 latest sent notifications/geotriggers. 

The list can be cleared with _plot.clearSentNotifications()_ and _plot.clearSentGeotriggers()_.

### More information ###
Website: https://www.plotprojects.com/

Documentation: https://www.plotprojects.com/documentation/

[![gitTio](http://gitt.io/badge.svg)](http://gitt.io/component/com.plotprojects.ti)

### License ###
The source files included in the repository are released under the Apache License, Version 2.0.
