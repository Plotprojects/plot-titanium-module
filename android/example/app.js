// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
win.add(label);
win.open();

var plot = require('com.plotprojects.ti');
plot.initPlot({	publicToken:'REPLACE_ME' });


label.text = plot.version;