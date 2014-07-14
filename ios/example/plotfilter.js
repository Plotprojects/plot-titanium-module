
var plot = require('com.plotprojects.ti');

Ti.API.info('Plot version: ' + plot.version);

var filterableNotifications = plot.popFilterableNotifications();

for (var i = 0; i < filterableNotifications.notifications.length; i++) {
	var n = filterableNotifications.notifications[i];
	n.message = "TestMessage: " + n.message;
	n.data = "TestData: " + n.data;
	
	Ti.API.info(JSON.stringify(n));
}

//always call plot.sendNotifications function, even if filterableNotifications.notifications becomes empty 
plot.sendNotifications(filterableNotifications); 
