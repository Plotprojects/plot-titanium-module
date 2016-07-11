/**
 * Copyright 2016 Floating Market B.V.
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

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;

import android.app.Service;

import com.plotprojects.retail.android.FilterableNotification;
import com.plotprojects.retail.android.NotificationFilterUtil.Batch;

public final class NotificationBatches {
	private static final Object lock = new Object();
	private static final Queue<BatchWithStartId> pendingBatches = new LinkedList<BatchWithStartId>();
	private static final Map<String, BatchWithStartId> activeBatches = new HashMap<String, BatchWithStartId>();
	private static int batchId = 0;
	
	private NotificationBatches() {		
	}
	
	public static void addBatch(Batch batch, Service service, int startId) {
		if (batch == null) {
			return;
		}
		synchronized(lock) {
			pendingBatches.add(new BatchWithStartId(batch, service, startId));
		}
	}
	
	public static NotificationsAndId popBatch() {
		synchronized(lock) {
			String newBatchId = Integer.toString(batchId++);
			BatchWithStartId batchWithStartId = pendingBatches.poll();
			if (batchWithStartId == null) {
				return null;
			}
			activeBatches.put(newBatchId, batchWithStartId);
			return new NotificationsAndId(batchWithStartId.getBatch().getNotifications(), newBatchId);
		}
	}
	
	public static List<FilterableNotification> getBatch(String batchId) {
		synchronized(lock) {
			BatchWithStartId batch = activeBatches.get(batchId);
			if (batch != null) {
				return batch.getBatch().getNotifications();
			}
			return null;
		}
	}
	
	public static void sendBatch(String batchId, List<FilterableNotification> notifications) {
		synchronized(lock) {
			BatchWithStartId batchWithStartId = activeBatches.remove(batchId);
			if (batchWithStartId != null) {
				Batch batch = batchWithStartId.getBatch();
				batch.sendNotifications(notifications);
				
				batchWithStartId.getService().stopSelf(batchWithStartId.getStartId());
			}
		}
	}
	
	private static final class BatchWithStartId {
		private final Batch batch;
		private final Service service;
		private final int startId;
		
		public BatchWithStartId(Batch batch, Service service, int startId) {
			this.batch = batch;
			this.service = service;
			this.startId = startId;
		}

		public Batch getBatch() {
			return batch;
		}
		
		public Service getService() {
			return service;
		}

		public int getStartId() {
			return startId;
		}
	}
	
	public static final class NotificationsAndId {
		private final List<FilterableNotification> notifications;
		private final String id;
		
		public NotificationsAndId(List<FilterableNotification> notifications, String id) {
			this.notifications = notifications;
			this.id = id;
		}
		
		public List<FilterableNotification> getNotifications() {
			return notifications;
		}
		public String getId() {
			return id;
		}
	}
}
