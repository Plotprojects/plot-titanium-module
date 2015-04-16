// open a single window
var win = Ti.UI.createWindow({
	backgroundColor:'white'
});
var label = Ti.UI.createLabel();
win.add(label);
win.open();

//Add the following lines to tiApp.xml at ios/plist/dict:
//<key>NSLocationAlwaysUsageDescription</key>
//<string>Your location is used to instantly inform you when you are near a location that is interesting to you.</string>

var plot = require('com.plotprojects.ti');


label.text = plot.version;


//Optional:
// plot.addEventListener("plotNotificationReceived", function(notification) {
//   alert(notification.message);
// });

plot.initPlot({	notificationFilterEnabled: true }); //Get your public token from http://www.plotprojects.com/getourplugin/
