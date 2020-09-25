package com.plotprojects.exampleapp;

import android.os.Bundle;
import android.app.Activity;

import com.plotprojects.retail.android.Plot;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Plot.init(this);
    }

}
