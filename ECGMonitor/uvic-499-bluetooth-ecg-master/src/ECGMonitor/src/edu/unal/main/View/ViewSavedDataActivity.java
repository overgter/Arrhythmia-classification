package edu.unal.main.View;

import java.io.IOException;
import java.util.ArrayList;
import java.util.concurrent.LinkedBlockingQueue;

import org.achartengine.ChartFactory;
import org.achartengine.GraphicalView;
import org.achartengine.model.XYMultipleSeriesDataset;
import org.achartengine.model.XYSeries;
import org.achartengine.renderer.XYMultipleSeriesRenderer;
import org.achartengine.renderer.XYSeriesRenderer;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;

import edu.unal.main.Data.EcgObject;
import edu.unal.main.R;
import edu.unal.main.Services.BluetoothConnService;
import edu.unal.main.Data.XmlParser;


public class ViewSavedDataActivity extends Activity {

	 private XYMultipleSeriesRenderer renderer;
	 private XYSeriesRenderer rendererSeries;
	 private XYSeries xySeries;
	 private XYMultipleSeriesDataset dataset;
	 private GraphicalView view;
	 
	 // TODO: The sampling rate here needs to be accurate (it's not now)
	 private double samplingRate = 1;
	 private int xLookahead = 20;
	 private int yMax = 6;
	 private int yMin = 5;
	 
	 private ArrayList<Double> savedData = new ArrayList<Double>();
	 public LinkedBlockingQueue<Double> queue = BluetoothConnService.bluetoothQueueForSaving;
	
	/* TODO: encapsulate this cross-app
	 * Gets the appropriate file to write to.  If multiple users are supported, should have a new file for each
	 * and some way to know who's file to access.
	 * 
	 * For now, just use/overwrite the same file each time the service is started.
	 */
	 
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_chart);

        //Read data from file xml /ECGMonitor/assets/ecg.xml
        readSavedData("ecg.xml");
		displaySavedData();

        // TODO: for now, saved data should just fill with in-memory history queue
		/*for (Object d : queue.toArray()) {
			savedData.add((Double)d);
		}*/
	}
	
	
	// Puts all file data into main memory array
	public void readSavedData(String filename) {

         // Eventually we just need to replace for this
        XmlParser parser = new XmlParser();
        try {
            EcgObject ecgdata = parser.parse(getAssets().open(filename));
            String [] stringValues = ecgdata.getSignalSamples();
            for (int i = 0;i<stringValues.length;i++){
                Double d = Double.valueOf(stringValues[i]);
                savedData.add((Double)d);
            }
        }catch (IOException e) {
            System.out.println(e);
        }
	}
		
	public void displaySavedData() {
		
		initChartStuff();
		dataset = new XYMultipleSeriesDataset();
		xySeries = new XYSeries(renderer.getChartTitle());
		
		// fill series
	    double currentX = 0;
		for (Double d : savedData) {
			xySeries.add(currentX, d);
			currentX += samplingRate;
			if (d > yMax) {
				yMax = d.intValue();
			}
			if ( d < yMin) {
				yMin = d.intValue();
			}
		}

		dataset.addSeries(xySeries);
	    
		// TODO: Setup the X axis max and mins once we have a filled series
		int xCurr = xySeries.getItemCount();
		int xMin = (xCurr-400 >= 0) ? xCurr-400 : 0;
        renderer.setXAxisMax(xCurr+xLookahead);
	    renderer.setXAxisMin(xMin);
	    renderer.setYAxisMax(yMax);
	    renderer.setYAxisMin(yMin);
	    
		view = ChartFactory.getLineChartView(getApplicationContext(), dataset, renderer);
	    view.refreshDrawableState();
	    setContentView(view);
	    
	}
	
	// TODO: This stuff taken from ECGChartActivity
	private void initChartStuff() {
		renderer = new XYMultipleSeriesRenderer(); 
	    renderer.setApplyBackgroundColor(true);
	    renderer.setBackgroundColor(Color.BLACK);//argb(100, 50, 50, 50));
	    renderer.setLabelsTextSize(35);
	    renderer.setLegendTextSize(35);
	    renderer.setAxesColor(Color.WHITE);
	    renderer.setAxisTitleTextSize(35);
	    renderer.setChartTitle("ECG Heartbeat");
	    renderer.setChartTitleTextSize(35);
	    renderer.setFitLegend(false);
	    renderer.setGridColor(Color.BLACK);
	    renderer.setPanEnabled(true, true); // TODO
	    renderer.setPointSize(1);
	    renderer.setXTitle("X");
	    renderer.setYTitle("Y");
	    renderer.setMargins(new int []{5, 50, 50, 5}); // TODO: i doubled
	    renderer.setZoomButtonsVisible(false);
	    renderer.setZoomEnabled(true); // TODO: try true
        renderer.setBarSpacing(10);
	    renderer.setShowGrid(false);
	    
	    // TODO: Reset the MAX AND MIN VALUES!!
	    renderer.setYAxisMax(yMax);//2.4);
	    renderer.setYAxisMin(yMin);//0.4);
	    
	    rendererSeries = new XYSeriesRenderer();
	    rendererSeries.setColor(Color.GREEN);
	    rendererSeries.setLineWidth(5f);
	    renderer.addSeriesRenderer(rendererSeries);
    }
	
}
