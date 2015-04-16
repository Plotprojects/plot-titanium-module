
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

geotriggersHandler.geotriggers = geotriggersPassed;

//always call plot.markGeoTriggersHandled function, even if geotriggersPassed becomes empty 
plot.markGeoTriggersHandled(geotriggersHandler); 