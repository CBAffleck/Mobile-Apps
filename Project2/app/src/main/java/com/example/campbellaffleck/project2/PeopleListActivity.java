package com.example.campbellaffleck.project2;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
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
        if (userLat == 0) {
            url = "https://api.geocod.io/v1.3/geocode?postal_code=" + userZip + "&fields=cd&api_key=" + geoCodKey;
        } else {
            url = "https://api.geocod.io/v1.3/reverse?q=" + userLat + "," + userLon + "&fields=cd&api_key=" + geoCodKey;
        }
        queue = Volley.newRequestQueue(this);
        getGeoCodResponse();
//        chamber = "house";
//        proPubUrl = "https://api.propublica.org/congress/v1/members/senate/" + state + "/current.json";
//        getProPubResponse(proPubUrl);
    }

    //Method to get the district numbers from the json object that's returned from the api call to geocodio
    private void getGeoCodResponse() {
        final TextView jsonString = (TextView) findViewById(R.id.jsonString);
        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null,
        new Response.Listener<JSONObject>() {
            @Override
            public void onResponse(JSONObject response) {
                try {
                    JSONArray jsonArray = response.getJSONArray("results");
                    System.out.println(jsonArray);
                    JSONObject resultObj = jsonArray.getJSONObject(0);
                    JSONObject fields = resultObj.getJSONObject("fields");
                    JSONObject address = resultObj.getJSONObject("address_components");
                    state = address.getString("state");
                    System.out.println("AAAAAAAAAAAAAA "+ state);
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
                                JSONObject bio = legislator.getJSONObject("bio");
                                String fname = bio.getString("first_name");
                                String lname = bio.getString("last_name");
                                String party = bio.getString("party");
                                JSONObject contact = legislator.getJSONObject("contact");
                                String website = contact.getString("url");
                                String email = contact.getString("contact_form");
                                if (email.isEmpty()) {
                                    email = "No public email.";
                                }
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
                            JSONObject bio = legislator.getJSONObject("bio");
                            String fname = bio.getString("first_name");
                            String lname = bio.getString("last_name");
                            String party = bio.getString("party");
                            JSONObject contact = legislator.getJSONObject("contact");
                            String website = contact.getString("url");
                            String email = contact.getString("contact_form");
                            if (email.isEmpty()) {
                                email = "No public email.";
                            }
                            person.add(type + " "  + fname + " " + lname);
                            person.add(party);
                            person.add(website);
                            person.add(email);
                            legislators.add(person);
                        }
                        jsonString.append("\n District: " + String.valueOf(districtNum));
                        System.out.println(legislators);
                        jsonString.append("\n Legislators: " + legislators);
                    }
//                    //After getting the districts and state, make a call to the propublica api to get senator info
//                    proPubUrl = "https://api.propublica.org/congress/v1/members/" + chamber + "/" + state + "/current.json";
//                    getProPubResponse(proPubUrl);
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

//    private void getProPubResponse(String url) {
//        final TextView jsonString = (TextView) findViewById(R.id.jsonString2);
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
//                headers.put("X-API_Key", proPubKey);
//                return headers;
//            }
//        };
//        queue.add(request);
//    }
}
