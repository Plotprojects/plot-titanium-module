Plot Appcelerator module
========================
A module for Titinium apps that adds location based notifications. 

### Supported platforms ###

This module was developed for Titanium 3.1.3.GA.
This plugins supports both IOS and Android.

### Installation ###

Install our module through the Help -> Install Mobile Module. The URLs are:
- IOS: http://www.plotprojects.com/downloads/com.plotprojects.ti-iphone-latest.zip
- Android: http://www.plotprojects.com/downloads/com.plotprojects.ti-android-latest.zip

The following snippet has to one of your scripts used to initialize your application:
```
var plot = require('com.plotprojects.ti');
plot.initPlot({ publicToken:'REPLACE_ME' });
```

You can obtain the public token at: http://www.plotprojects.com/

The following snippet has to be added to tiapp.xml to the ```ti:app``` element:
```
<ios>
  <plist>
    <dict>
      <key>UIBackgroundModes</key>
      <array>
        <string>location</string>
      </array>
    </dict>   
  </plist>
</ios>
```

### Function reference ###

_plot.initPlot(config)_

Initialises Plot. You must call this method before calling other methods Plot provides.
The _config_ parameter is an object and may have the following properties:

<table>
<tr>
<td>publicToken</td><td>Your public token (required)</td>
</tr><tr>
<td>cooldownPeriod</td><td>The cooldown period between notifications in seconds. (default disabled)</td>
</tr><tr>
<td>cooldownPeriod</td><td>Whether Plot should be automatically enabled on the first run (default true)</td>
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

### License ###
The source files included in the repository are released under the Apache License, Version 2.0.