/**
 * Copyright 2013 Floating Market B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.plotprojects.titanium;

import android.app.Activity;

import com.plotprojects.retail.android.Plot;
import com.plotprojects.retail.android.PlotConfiguration;

import java.util.HashMap;

import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiApplication;

@Kroll.module(name="PlotAndroidModule", id="com.plotprojects.ti")
public class PlotAndroidModule extends KrollModule
{

	private static final String ENABLE_ON_FIRST_RUN_FIELD = "enableOnFirstRun";
	private static final String COOLDOWN_PERIOD_FIELD = "cooldownPeriod";
	private static final String PUBLIC_TOKEN_FIELD = "publicToken";

	@Kroll.method
	public void initPlot(@SuppressWarnings("rawtypes") HashMap configuration) {
		TiApplication appContext = TiApplication.getInstance();
		Activity activity = appContext.getCurrentActivity();
		
		if (configuration == null) {
			throw new IllegalArgumentException("No configuration object provided.");
		}
			
		if (!configuration.containsKey(PUBLIC_TOKEN_FIELD)) {
			throw new IllegalArgumentException("Public key not specified.");
		}
		
		if (!(configuration.get(PUBLIC_TOKEN_FIELD) instanceof String)) {
			throw new IllegalArgumentException("Public key not specified correctly.");
		}
			
		PlotConfiguration config = new PlotConfiguration((String) configuration.get(PUBLIC_TOKEN_FIELD));
		
		if (configuration.containsKey(COOLDOWN_PERIOD_FIELD) && !(configuration.get(COOLDOWN_PERIOD_FIELD) instanceof Integer)) {
			throw new IllegalArgumentException("Cooldown period not specified correctly.");
		}
		else if (configuration.containsKey(COOLDOWN_PERIOD_FIELD)) {
			config.setCooldownPeriod((Integer) configuration.get(COOLDOWN_PERIOD_FIELD));
		}
			
		if (configuration.containsKey(ENABLE_ON_FIRST_RUN_FIELD) && !(configuration.get(ENABLE_ON_FIRST_RUN_FIELD) instanceof Boolean)) {
			throw new IllegalArgumentException("Enable on first run not specified correctly.");
		}
		else if (configuration.containsKey(ENABLE_ON_FIRST_RUN_FIELD)) {
			config.setEnableOnFirstRun((Boolean) configuration.get(ENABLE_ON_FIRST_RUN_FIELD));
		}
		Plot.init(activity, config);
	}
	
	@Kroll.method
	public void enable() {
		Plot.enable();
	}
	
	@Kroll.method
	public void disable() {
		Plot.disable();
	}
	
	@Kroll.getProperty @Kroll.method
	public boolean getEnabled() {
		return Plot.isEnabled();
	}
	
	@Kroll.method
	public void setCooldownPeriod(int cooldownSeconds) {
		Plot.setCooldownPeriod(cooldownSeconds);
	}
	
	@Kroll.getProperty @Kroll.method
	public String getVersion() {
		return Plot.getVersion();
	}	

}
