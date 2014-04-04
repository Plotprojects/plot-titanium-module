Plot Appcelerator Titanium module
========================
A module for Appcelerator Titanium apps that adds location based notifications. iBeacon support in beta for iOS.

### Supported platforms ###

This module was developed for Titanium 3.1.3.GA.
This plugins supports both IOS and Android.

### Installation ###

Install our module through the marketplace: https://marketplace.appcelerator.com/listing?q=Plot%20–%20Location%20Based%20Notifications

The following snippet has to be added to one of your scripts used to initialize your application (usually app.js or alloy.js):
```
var plot = require('com.plotprojects.ti');
plot.initPlot({ publicToken:'REPLACE_ME' });
```

You can obtain the public token at: http://www.plotprojects.com/getourplugin/

### Function reference ###

_plot.addEventListener("plotNotificationReceived", func)_

Allows specifying your own handler when a notification is opened by the user. The function is passed a notification object, which has the fields "message", "data" and "id". When no listener is added, then the "data" field will be treated as URI and opened.

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

### More information ###
Website: http://www.plotprojects.com/
Technical support: https://groups.google.com/forum/#!forum/plot-users

### License ###
The source files included in the repository are released under the Apache License, Version 2.0.
