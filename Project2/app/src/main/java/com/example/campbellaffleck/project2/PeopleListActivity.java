package com.example.campbellaffleck.project2;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.support.v7.widget.CardView;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;

import org.json.JSONArray;
import org.json.JSONException;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

public class PeopleListActivity extends AppCompatActivity {

    String url;
    String proPubUrl;
    String state;
    String chamber;
    LinearLayout mylayout;
    List<Integer> districts = new ArrayList<>();
    List<List<String>> legislators = new ArrayList<List<String>>();
    private RequestQueue queue;
    //GeoCodio API Key
    final String geoCodKey = "9ebb9f32bbeb5355fbbbb3f3ef3e9b53b7ee5bb";
    //ProPublica Congress API Key
    String proPubKey = "ueFwgvEE9RxTZelGlUgUIfPzk7dFJcIKdizU0Y9I";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_people_list);
        chamber = "senate";

        //Set variables from the data passed in from the Home Activity
        Bundle b = getIntent().getExtras();
        Double userLat = b.getDouble("userLat");
        Double userLon = b.getDouble("userLon");
        Integer userZip = b.getInt("userZip");

        //Use either zip code or lat/long to create a url from which to get GeoCodio data
        if (userZip != 0) {
            url = "https://api.geocod.io/v1.3/geocode?postal_code=" + userZip + "&fields=cd&api_key=" + geoCodKey;
        } else {
            url = "https://api.geocod.io/v1.3/reverse?q=" + userLat + "," + userLon + "&fields=cd&api_key=" + geoCodKey;
        }
        System.out.println(url);
        queue = Volley.newRequestQueue(this);
        getGeoCodResponse();
//        FrameLayout frame1 = (FrameLayout) findViewById(R.id.frame1);
//        frame1.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View v) {
//                jsonString.setText("CLICKED");
//            }
//        });
//        chamber = "house";
//        proPubUrl = "https://api.propublica.org/congress/v1/members/senate/" + state + "/current.json";
//        getProPubResponse(proPubUrl);
    }

    //Method to get the district numbers from the json object that's returned from the api call to geocodio
    private void getGeoCodResponse() {
        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null,
        new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject response) {
                try {
                    JSONArray jsonArray = response.getJSONArray("results");
                    JSONObject resultObj = jsonArray.getJSONObject(0);
                    JSONObject fields = resultObj.getJSONObject("fields");
                    JSONObject address = resultObj.getJSONObject("address_components");
                    state = address.getString("state");
                    JSONArray newArray = fields.getJSONArray("congressional_districts");
                    //This loop goes over each district object in the congressional districts array
                    for (int i = 0; i < newArray.length(); i++) {
                        JSONObject congressional_district = newArray.getJSONObject(i);
                        int districtNum = congressional_district.getInt("district_number");
                        districts.add(districtNum);
                        JSONArray peopleArray = congressional_district.getJSONArray("current_legislators");
                        //On the first pass this for loop gets the district representative and the 2 state senators
                        if (i == 0) {
                            for (int j = 0; j < peopleArray.length(); j++) {
                                ArrayList<String> person = new ArrayList<String>();
                                JSONObject legislator = peopleArray.getJSONObject(j);
                                String type = legislator.getString("type");
                                if (type.contains("rep")) {
                                    type = "R" + type.substring(1);
                                } else {
                                    type = "S" + type.substring(1);
                                }
                                JSONObject bio = legislator.getJSONObject("bio");
                                String fname = bio.getString("first_name");
                                String lname = bio.getString("last_name");
                                String party = bio.getString("party");
                                JSONObject contact = legislator.getJSONObject("contact");
                                String website = contact.getString("url");
                                String email = contact.getString("contact_form");
                                //Add all of the legislators info to an array solely for them
                                person.add(type + " "  + fname + " " + lname);
                                person.add(party);
                                person.add(website);
                                person.add(email);
                                //Add that legislator array to the array of all legislators to be displayed to the user
                                legislators.add(person);
                            }
                        }
                        // After the first pass the state senators are already added, so we just need to representative for each district
                        else {
                            ArrayList<String> person = new ArrayList<String>();
                            JSONObject legislator = peopleArray.getJSONObject(0);
                            String type = legislator.getString("type");
                            if (type.contains("rep")) {
                                type = "R" + type.substring(1);
                            } else {
                                type = "S" + type.substring(1);
                            }
                            JSONObject bio = legislator.getJSONObject("bio");
                            String fname = bio.getString("first_name");
                            String lname = bio.getString("last_name");
                            String party = bio.getString("party");
                            JSONObject contact = legislator.getJSONObject("contact");
                            String website = contact.getString("url");
                            String email = contact.getString("contact_form");
                            person.add(type + " "  + fname + " " + lname);
                            person.add(party);
                            person.add(website);
                            person.add(email);
                            legislators.add(person);
                        }
                    }
//                    //After getting the districts and state, make a call to the propublica api to get senator info
//                    proPubUrl = "https://api.propublica.org/congress/v1/members/" + chamber + "/" + state + "/current.json";
//                    getProPubResponse(proPubUrl);
                    addInfoBoxes();
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                VolleyLog.e("Error: ", error.getMessage());
            }
        });
        queue.add(request);
    }

    private void addInfoBoxes() {
        mylayout = (LinearLayout) findViewById(R.id.linearLay);
        for (int i = 0; i < legislators.size(); i++) {
            CardView.LayoutParams lparams = new CardView.LayoutParams(CardView.LayoutParams.MATCH_PARENT, 200);
            lparams.setMargins(0,0,0,100);
            CardView display = new CardView(this);
            display.setRadius(20);
            display.setLayoutParams(lparams);

            //Formatting for legislator's name
            TextView name = new TextView(this);
            name.setText(legislators.get(i).get(0));
            name.setTextSize(24);
            name.setGravity(Gravity.TOP|Gravity.LEFT);
            name.setPadding(30,20,0,0);
            name.setTextColor(Color.GRAY);
            name.setTypeface(null, Typeface.BOLD);

            //Formatting for displaying the legislator's party
            TextView party = new TextView(this);
            String legParty = legislators.get(i).get(1);
            if (legislators.get(i).get(1).contains("Dem")) {
                party.setTextColor(Color.BLUE);
            } else {
                party.setTextColor(Color.RED);
            }
            party.setText(legParty);
            party.setTextSize(18);
            party.setGravity(Gravity.BOTTOM|Gravity.LEFT);
            party.setPadding(32,0,0,45);
            party.setTypeface(null, Typeface.BOLD_ITALIC);

            //Formatting for displaying the more info arrow icon
            ImageView moreInfo = new ImageView(this);
            moreInfo.setImageResource(R.drawable.rightarrow);
            CardView.LayoutParams iconParams = new CardView.LayoutParams(100, 100);
            iconParams.setMargins(840,50,0,0);
            moreInfo.setLayoutParams(iconParams);

            //Add views to main cardView
            display.addView(name);
            display.addView(party);
            display.addView(moreInfo);

            //Add cardView to the layout
            mylayout.addView(display);

            name.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    String legislator = ((TextView) v).getText().toString();
                    String party = "";
                    String website = "";
                    String email = "";
                    for (int j = 0; j < legislators.size(); j++) {
                        if (legislators.get(j).get(0) == legislator) {
                            party = legislators.get(j).get(1);
                            website = legislators.get(j).get(2);
                            email = legislators.get(j).get(3);
                        }
                    }
                    Intent startlegislatorInfoActivity = new Intent(PeopleListActivity.this, LegislatorInfoActivity.class);
                    Bundle b = new Bundle();
                    b.putString("legislator", legislator);
                    b.putString("party", party);
                    b.putString("website", website);
                    b.putString("email", email);
                    startlegislatorInfoActivity.putExtras(b);
                    startActivity(startlegislatorInfoActivity);
                }
            });
        }
    }

//    private void getProPubResponse(String url) {
//        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null,
//                new Response.Listener<JSONObject>() {
//                    @Override
//                    public void onResponse(JSONObject response) {
//                        try {
//                            if (chamber == "senate") {
//                                JSONArray jsonArray = response.getJSONArray("results");
//                                for (int i = 0; i < jsonArray.length(); i++) {
//                                    JSONObject senator = jsonArray.getJSONObject(i);
//                                    int districtNum = senator.getInt("district_number");
//                                    districts.add(districtNum);
//                                    jsonString.append("\n District: " + String.valueOf(districtNum));
//                                }
//                            } else {
//
//                            }
//                        } catch (JSONException e) {
//                            e.printStackTrace();
//                        }
//                    }
//                }, new Response.ErrorListener() {
//            @Override
//            public void onErrorResponse(VolleyError error) {
//                VolleyLog.e("Error: ", error.getMessage());
//            }
//        }) {
//            @Override
//            public Map getHeaders() throws AuthFailureError {
//                HashMap headers = new HashMap();
//                headers.put("X-API-Key", proPubKey);
//                return headers;
//            }
//        };
//        queue.add(request);
//    }
}
