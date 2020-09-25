var PlotProjects = require('com.meiresearch.android.plotprojects');

Ti.API.info('Plot version: ' + PlotProjects.version);

var geotriggersHandler = PlotProjects.popGeotriggers();
var geotriggersPassed = [];

for (var i = 0; i < geotriggersHandler.geotriggers.length; i++) {
    var geotrigger = geotriggersHandler.geotriggers[i];
    if (geotrigger.data == "pass") {
        geotriggersPassed.push(geotrigger);
    }

    Ti.API.info(JSON.stringify(geotrigger));
}

//always call PlotProjects.markGeotriggersHandled function, even if geotriggersHandler.geotriggers becomes empty
PlotProjects.markGeotriggersHandled(geotriggersPassed);