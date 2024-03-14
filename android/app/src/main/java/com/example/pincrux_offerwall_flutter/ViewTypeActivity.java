package com.example.pincrux_offerwall_flutter;

import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.LinearLayoutCompat;

import com.pincrux.offerwall.PincruxOfferwall;
import com.pincrux.offerwall.ui.common.impl.PincruxCloseImpl;

public class ViewTypeActivity extends AppCompatActivity {
    private static final String TAG = ViewTypeActivity.class.getSimpleName();

    private PincruxOfferwall offerwall;

    private boolean isPaused;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_type);

        offerwall = PincruxOfferwall.getInstance();

        LinearLayoutCompat offerwallView = findViewById(R.id.offerwall_view);
        View view = offerwall.getPincruxOfferwallView(this, new PincruxCloseImpl() {
            @Override
            public void onClose() {
                finish();
            }

            @Override
            public void onPermissionDenied() {
                // 충전소 최초 진입시 동의 팝업에서 거부를 선택
                Log.i(TAG, "onPermissionDenied");
            }

            @Override
            public void onAction() {
                Log.i(TAG, "onAction");
            }
        });

        if (view != null) {
            offerwallView.addView(view);
        }
    }

    @Override
    protected void onResume() {
        super.onResume();

        if (isPaused && offerwall != null) {
            offerwall.refreshOfferwall();
        }
    }

    @Override
    protected void onPause() {
        super.onPause();

        isPaused = true;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        if (offerwall != null) {
            offerwall.destroyView();
        }
    }
}
