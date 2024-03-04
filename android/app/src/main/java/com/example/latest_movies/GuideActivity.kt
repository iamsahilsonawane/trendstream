package com.example.latest_movies

import android.view.View // Add this line
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.jakewharton.threetenabp.AndroidThreeTen

class GuideActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Hide the status bar.
        window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_FULLSCREEN
        // Remember that you should never show the action bar if the
        // status bar is hidden, so hide that too if necessary.
        actionBar?.hide()

        // Hide the status bar.
        window.decorView.systemUiVisibility = View.SYSTEM_UI_FLAG_FULLSCREEN
        // Remember that you should never show the action bar if the
        // status bar is hidden, so hide that too if necessary.
        actionBar?.hide()

        AndroidThreeTen.init(this)
        setContentView(R.layout.activity_guide)
        supportActionBar?.hide()
        supportFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, EpgFragment())
            .commit()
    }
}
