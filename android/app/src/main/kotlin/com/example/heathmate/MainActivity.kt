package com.example.heathmate
import io.flutter.embedding.android.FlutterActivity
import android.content.Context
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.heathmate/steps"
    private var steps = 0
    private lateinit var sensorManager: SensorManager
    private var stepCounterSensor: Sensor? = null
    private lateinit var stepListener: SensorEventListener

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getSteps") {
                result.success(steps)
            } else {
                result.notImplemented()
            }
        }

        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        stepCounterSensor = sensorManager.getDefaultSensor(Sensor.TYPE_STEP_COUNTER)

        if (stepCounterSensor != null) {
            stepListener = object : SensorEventListener {
                override fun onSensorChanged(event: SensorEvent) {
                    steps = event.values[0].toInt()
                }

                override fun onAccuracyChanged(sensor: Sensor, accuracy: Int) {
                    // Handle accuracy changes if needed
                }
            }

            sensorManager.registerListener(stepListener, stepCounterSensor, SensorManager.SENSOR_DELAY_NORMAL)
        } else {
            // Handle the case where the sensor is not available
            println("Step Counter Sensor not available.")
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        if (stepCounterSensor != null) {
            sensorManager.unregisterListener(stepListener)
        }
    }
}
