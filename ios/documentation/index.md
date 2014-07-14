Plot Appcelerator Titanium module for iOS
=========================================

A module for Appcelerator Titanium apps that adds location based notifications to your app. iBeacon support in beta for iOS.

### Supported platforms ###

This module was developed for Titanium 3.1.3.GA or newer.
This plugins supports both IOS and Android.

### Installation ###

Install our module through the marketplace: https://marketplace.appcelerator.com/listing?q=Plot%20–%20Location%20Based%20Notifications

The following snippet has to be added to one of your scripts used to initialize your application (usually app.js or alloy.js):
```
var plot = require('com.plotprojects.ti');
plot.initPlot({ publicToken: 'REPLACE_ME', notificationFilterEnabled: false });
```

You can obtain the public token at: http://www.plotprojects.com/getourplugin/

### Function reference ###

_plot.addEventListener("plotNotificationReceived", func)_

Allows specifying your own handler when a notification is opened by the user. The function is passed a notification object, which has the fields "message", "data" and "identifier". When no listener is added, then the "data" field will be treated as URI and opened.

_plot.initPlot(config)_

Initializes Plot. You must call this method before calling other methods other than the notification handler Plot provides.
The _config_ parameter is an object and may have the following properties:

<table>
<tr>
<td>publicToken</td><td>Your public token (required)</td>
</tr><tr>
<td>cooldownPeriod</td><td>The cooldown period between notifications in seconds. (default disabled)</td>
</tr><tr>
<td>enableOnFirstRun</td><td>Whether Plot should be automatically enabled on the first run (default true)</td>
</tr><tr>
<td>notificationFilterEnabled</td><td>Whether the notification filter should be enabled. See section about <a href="#notification-filter">Notification Filter</a> for more information. (default disabled)</td>
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

### More information ###
Website: http://www.plotprojects.com/

Technical support: https://groups.google.com/forum/#!forum/plot-users

### License ###
The source files included in the repository are released under the Apache License, Version 2.0.
