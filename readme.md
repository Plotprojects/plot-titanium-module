Plot Appcelerator module
========================
A module for Titinium apps that adds location based notifications. 

### Supported platforms ###

This module was developed for Titanium 3.1.3.GA.
This plugins supports both IOS and Android.

### Installation ###

The following snippet has to one of your scripts used to initialise your application:
```
var plot = require('com.plotprojects.ti');
plot.initPlot({ publicKey:'REPLACE_ME' });
```

You can obtain the public key at: http://www.plotprojects.com/

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