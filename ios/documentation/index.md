# plot-ios-module Module

## Description

Enable the power of Location Based Notifications provided by Plot in your Titanium apps.

## Accessing the plot-ios-module Module

To access this module from JavaScript, you would do the following:

	var plot = require("com.plotprojects.ti");

The plot variable is a reference to the Module object.	

## Function reference 

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

## More information

http://www.plotprojects.com

## License

The source files included in the repository are released under the Apache License, Version 2.0.
