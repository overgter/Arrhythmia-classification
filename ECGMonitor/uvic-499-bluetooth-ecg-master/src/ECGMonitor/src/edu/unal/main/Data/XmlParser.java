package edu.unal.main.Data;

import org.xmlpull.v1.XmlPullParser;
import org.xmlpull.v1.XmlPullParserException;
import org.xmlpull.v1.XmlPullParserFactory;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

/**
 * This class help to parse a xml file into a java object
 * Created by yesika on 08/05/2015.
 */
public class XmlParser {

    private EcgObject ecgObject;
    private String text;

    public EcgObject parse(InputStream is)
    {
        XmlPullParserFactory factory = null;
        XmlPullParser xpp = null;
        try {
            factory = XmlPullParserFactory.newInstance();
            factory.setNamespaceAware(true);
            xpp = factory.newPullParser();
            xpp.setInput(is,null);

            int eventType = xpp.getEventType();
            while (eventType != XmlPullParser.END_DOCUMENT) {
                String tagname = xpp.getName();
                switch (eventType){
                    case XmlPullParser.START_TAG:
                        if (tagname.equals("ecgObject")){
                            // create a new instance of ecgObject
                            ecgObject = new EcgObject();
                        }
                        break;
                    case XmlPullParser.TEXT:
                        text = xpp.getText();
                        break;
                    case XmlPullParser.END_TAG:
                        if(tagname.equals("beatType")){
                           ecgObject.setBeatTypes(text);
                        }else if (tagname.equals("fp")){
                           ecgObject.setFiducialPoints(text);
                        }else if (tagname.equals("signal")){
                           ecgObject.setSignalSamples(text);
                        }
                        break;
                    default:
                        break;
                }

                eventType = xpp.next();
            }
       }
        catch(XmlPullParserException e){
            System.out.println(" ***" + e.getMessage());
            e.printStackTrace();
        }catch (IOException e) {
            e.printStackTrace();
        }

        //Before return a file is stored
        InputStreamAFile(is);
        return ecgObject;

    }

    public void InputStreamAFile(InputStream is){
        try{
            File f=new File("assets\\ecg.xml");
            OutputStream output=new FileOutputStream(f);
            byte[] buf =new byte[1024];
            int len;
            while((len=is.read(buf))>0){
                output.write(buf,0,len);
            }
            output.close();
            is.close();
            System.out.println("File created!");
        }catch(IOException e){
            System.out.println("Error, File was not created : "+e.toString());
        }
    }
}
