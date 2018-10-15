package com.example.campbellaffleck.proj01_electrictime;

import android.content.res.Configuration;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import java.util.ArrayList;
import java.util.Dictionary;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.Toast;
import android.widget.AdapterView.OnItemSelectedListener;

public class MainActivity extends AppCompatActivity implements OnItemSelectedListener {

    Boolean timePressed = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final Spinner spinner1 = (Spinner) findViewById(R.id.transportation_spinner1);
        final Spinner spinner2 = (Spinner) findViewById(R.id.transportation_spinner2);
        spinner1.setOnItemSelectedListener(this);
        spinner2.setOnItemSelectedListener(this);

        final List<String> transport_modes = new ArrayList<String>();
        transport_modes.add("Walking");
        transport_modes.add("Boosted Mini S Board");
        transport_modes.add("Evolve Skateboard");
        transport_modes.add("OneWheel");
        transport_modes.add("MotoTec Skateboard");
        transport_modes.add("Segway Ninebot One S1");
        transport_modes.add("Segway i2 SE");
        transport_modes.add("Razor Scooter");
        transport_modes.add("GeoBlade 500");
        transport_modes.add("Hovertrax Hoverboard");

        ArrayAdapter<String> dataAdapter = new ArrayAdapter<String>(this, R.layout.support_simple_spinner_dropdown_item, transport_modes);
        dataAdapter.setDropDownViewResource(R.layout.support_simple_spinner_dropdown_item);
        spinner1.setAdapter(dataAdapter);
        spinner2.setAdapter(dataAdapter);

        final Map<String, List<Double>> transportInfo = new HashMap<String, List<Double>>();
        List<Double> walkDist = new ArrayList<Double>();
        walkDist.add(3.1);
        walkDist.add(30.0);
        transportInfo.put("Walking", walkDist);
        List<Double> boostDist = new ArrayList<Double>();
        boostDist.add(18.0);
        boostDist.add(7.0);
        transportInfo.put("Boosted Mini S Board", boostDist);
        List<Double> evoDist = new ArrayList<Double>();
        evoDist.add(26.0);
        evoDist.add(31.0);
        transportInfo.put("Evolve Skateboard", evoDist);
        List<Double> oneDist = new ArrayList<Double>();
        oneDist.add(19.0);
        oneDist.add(7.0);
        transportInfo.put("OneWheel", oneDist);
        List<Double> motoDist = new ArrayList<Double>();
        motoDist.add(22.0);
        motoDist.add(10.0);
        transportInfo.put("MotoTec Skateboard", motoDist);
        List<Double> segDist = new ArrayList<Double>();
        segDist.add(12.5);
        segDist.add(15.0);
        transportInfo.put("Segway Ninebot One S1", segDist);
        List<Double> segiDist = new ArrayList<Double>();
        segiDist.add(12.5);
        segiDist.add(24.0);
        transportInfo.put("Segway i2 SE", segiDist);
        List<Double> razDist = new ArrayList<Double>();
        razDist.add(10.0);
        razDist.add(7.0);
        transportInfo.put("Razor Scooter", razDist);
        List<Double> geoDist = new ArrayList<Double>();
        geoDist.add(15.0);
        geoDist.add(8.0);
        transportInfo.put("GeoBlade 500", geoDist);
        List<Double> hoverDist = new ArrayList<Double>();
        hoverDist.add(8.0);
        hoverDist.add(8.0);
        transportInfo.put("Hovertrax Hoverboard", hoverDist);

        Button button = (Button) findViewById(R.id.button);
        final EditText edit_text = (EditText) findViewById(R.id.distInput);
        final RadioButton timeMark = (RadioButton) findViewById(R.id.radioButton1);
        final RadioButton distMark = (RadioButton) findViewById(R.id.radioButton2);
        distMark.setChecked(true);
        final TextView alert = (TextView) findViewById(R.id.alert);
        alert.setVisibility(View.INVISIBLE);
        timeMark.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                String newHint = "Time in Hours";
                edit_text.setHint(newHint);
                timePressed = true;
                distMark.setChecked(false);
            }
        });
        distMark.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                String newHint = "Distance in Miles";
                edit_text.setHint(newHint);
                timePressed = false;
                timeMark.setChecked(false);
            }
        });
        button.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                String initialMode = spinner1.getSelectedItem().toString();
                String finalMode = spinner2.getSelectedItem().toString();
                System.out.println(finalMode);

                double ispeed = transportInfo.get(initialMode).get(0);
                double fspeed = transportInfo.get(finalMode).get(0);
                double userInput = Double.parseDouble(edit_text.getText().toString());
                if (timePressed == Boolean.FALSE) {
                    double iTime = userInput / ispeed;
                    double fTime = userInput / fspeed;
                    String iTimeString;
                    String fTimeString;
                    if (Double.toString(iTime).length() < 5) {
                        iTimeString = Double.toString(iTime) + " hours";
                    } else {
                        iTimeString = Double.toString(iTime).substring(0, 4) + " hours";
                    }
                    if (Double.toString(fTime).length() < 5) {
                        fTimeString = Double.toString(fTime) + " hours";
                    } else {
                        fTimeString = Double.toString(fTime).substring(0, 4) + " hours";
                    }
                    TextView startingTime = (TextView) findViewById(R.id.output2);
                    TextView convertedTime = (TextView) findViewById(R.id.output);
                    startingTime.setText(iTimeString);
                    convertedTime.setText(fTimeString);
                    if (userInput > transportInfo.get(finalMode).get(1)) {
                        String alertText = "You can't travel that far with " + finalMode + "!";
                        alert.setText(alertText);
                        alert.setVisibility(View.VISIBLE);
                    } else {
                        alert.setVisibility(View.INVISIBLE);
                    }
                } else {
                    double iDist = userInput * ispeed;
                    double fDist = userInput * fspeed;
                    String iDistString = Double.toString(iDist) + " miles";
                    String fDistString = Double.toString(fDist) + " miles";
                    TextView startingDist = (TextView) findViewById(R.id.output2);
                    TextView convertedDist = (TextView) findViewById(R.id.output);
                    startingDist.setText(iDistString);
                    convertedDist.setText(fDistString);
                    if (fDist > transportInfo.get(finalMode).get(1)) {
                        String alertText = "You can't travel that far with " + finalMode + "!";
                        alert.setText(alertText);
                        alert.setVisibility(View.VISIBLE);
                    } else {
                        alert.setVisibility(View.INVISIBLE);
                    }
                }
            }
        });

    }

    @Override
    public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {}
    public void onNothingSelected(AdapterView<?> arg0) {}
}
