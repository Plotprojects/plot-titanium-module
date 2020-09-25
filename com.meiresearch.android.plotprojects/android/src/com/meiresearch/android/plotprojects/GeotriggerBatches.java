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
package com.meiresearch.android.plotprojects;

import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import android.util.Log;

import android.app.Service;

import com.plotprojects.retail.android.Geotrigger;
import com.plotprojects.retail.android.GeotriggerHandlerUtil.Batch;


public final class GeotriggerBatches {
    private static final Object lock = new Object();
    private static final Queue<BatchWithStartId> pendingBatches = new LinkedList<BatchWithStartId>();
    private static final Map<String, BatchWithStartId> activeBatches = new HashMap<String, BatchWithStartId>();
    private static int batchId = 0;
    
    private GeotriggerBatches() {
        Log.d("GeotriggerBatches", "GeotriggerBatches");
    }
    
    public static void addBatch(Batch batch, Service service, int startId) {
        Log.d("GeotriggerBatches", "addBatch");
        if (batch == null) {
            return;
        }
        synchronized(lock) {
            pendingBatches.add(new BatchWithStartId(batch, service, startId));
        }
    }
    
    public static GeotriggersAndId popBatch() {
        synchronized(lock) {
            Log.d("GeotriggerBatches", "GeotriggersAndId popBatch");
            String newBatchId = Integer.toString(batchId++);
            BatchWithStartId batchWithStartId = pendingBatches.poll();
            if (batchWithStartId == null) {
                return null;
            }
            activeBatches.put(newBatchId, batchWithStartId);
            return new GeotriggersAndId(batchWithStartId.getBatch().getGeotriggers(), newBatchId);
        }
    }
    
    public static List<Geotrigger> getBatch(String batchId) {
        synchronized(lock) {
            Log.d("GeotriggerBatches", "List<Geotrigger> getBatch(String batchId)");
            BatchWithStartId batch = activeBatches.get(batchId);
            if (batch != null) {
                return batch.getBatch().getGeotriggers();
            }
            return null;
        }
    }
    
    public static void sendBatch(String batchId, List<Geotrigger> geotriggers) {
        synchronized(lock) {
            Log.d("GeotriggerBatches", "sendBatch(String batchId, List<Geotrigger> geotriggers)");
            BatchWithStartId batchWithStartId = activeBatches.remove(batchId);
            if (batchWithStartId != null) {
                Batch batch = batchWithStartId.getBatch();
                batch.markGeotriggersHandled(geotriggers);
                
                batchWithStartId.getService().stopSelf(batchWithStartId.getStartId());
            }
        }
    }
    
    private static final class BatchWithStartId {
        private final Batch batch;
        private final Service service;
        private final int startId;
        
        public BatchWithStartId(Batch batch, Service service, int startId) {
            Log.d("GeotriggerBatches", "BatchWIthStartId");
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
    
    public static final class GeotriggersAndId {
        private final List<Geotrigger> geotriggers;
        private final String id;
        
        public GeotriggersAndId(List<Geotrigger> geotriggers, String id) {
            Log.d("GeotriggerBatches", "geotriggersAndId(List<Geotrigger> geotriggers, String id)");
            this.geotriggers = geotriggers;
            this.id = id;
        }
        
        public List<Geotrigger> getGeotriggers() {
            Log.d("GeotriggerBatches", "List<Geotrigger> getGeotriggers()");
            return geotriggers;
        }
        public String getId() {
            Log.d("GeotriggerBatches", "getId()");
            return id;
        }
    }
}
