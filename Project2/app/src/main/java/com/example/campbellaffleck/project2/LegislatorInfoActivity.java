package com.example.campbellaffleck.project2;

import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;

public class LegislatorInfoActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_legislator_info);

        Bundle b = getIntent().getExtras();
        final String legislator = b.getString("legislator");
        final String party = b.getString("party");
        System.out.println(party);
        final String website = b.getString("website");
        final String email = b.getString("email");
        System.out.println(email);

        final TextView nameView = (TextView) findViewById(R.id.nameView);
        final TextView websiteView = (TextView) findViewById(R.id.websiteView);
        final TextView emailView = (TextView) findViewById(R.id.emailView);
        final TextView demView = (TextView) findViewById(R.id.demView);
        final TextView repView = (TextView) findViewById(R.id.repView);

        nameView.setText(legislator);
        if (party.contains("Dem")) {
            demView.setVisibility(View.VISIBLE);
            repView.setVisibility(View.INVISIBLE);
        } else {
            demView.setVisibility(View.INVISIBLE);
            repView.setVisibility(View.VISIBLE);
        }

        websiteView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(website));
                startActivity(browserIntent);
            }
        });


        emailView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!email.contains("null")) {
                    Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(email));
                    startActivity(browserIntent);
                } else {
                    String noCon = "No form of contact";
                    emailView.setText(noCon);
                    emailView.setTextColor(Color.RED);
                }
            }
        });

    }
}
