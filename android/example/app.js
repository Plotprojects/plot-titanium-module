// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
win.add(label);
win.open();

var plot = require('com.plotprojects.ti');


label.text = plot.version;


//Optional:
// plot.addEventListener("plotNotificationReceived", function(notification) {
//   alert(notification.message);
// });

plot.initPlot({	publicToken:'REPLACE_ME', notificationFilterEnabled: false }); //Get your public token from http://www.plotprojects.com/getourplugin/
