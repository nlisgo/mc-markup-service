package com.molcon.elife.util;

import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.util.Map;

public class FetchMarkupUtil {
	
public static void downloadFromUrl(String urlStr,String file)throws Exception{
		
		System.out.println(urlStr + " "+ file);
		try{
			URL url = new URL(urlStr);
			ReadableByteChannel rbc = Channels.newChannel(url.openStream());
			FileOutputStream fos = new FileOutputStream(file);
		    fos.getChannel().transferFrom(rbc, 0, Long.MAX_VALUE);
		    fos.close();
		    rbc.close();
		} catch (MalformedURLException e) {
			e.printStackTrace();
			throw e;
		} catch (IOException e){
			e.printStackTrace();
			throw e;
		}catch (Exception e) {
			throw e;
		}
       
        
        System.out.println("download done...");
	}
public static String getXpathByKey(String key,String doi){
	
	String xpath="";
	switch (key) {
	case "Abstract":
		xpath="//abstract[not(@abstract-type)]";
		break;
	case "Digest":
			xpath="//abstract[@abstract-type=\"executive-summary\"]";
			break;
	case "References":
		xpath="//ref-list";
		break;
	case "Acknowledgments":
		xpath="//ack";
		break;
	case "Decision letter":
		xpath="//sub-article[@article-type=\"article-commentary\"]";
		break;
	case "Author response":
		xpath="//sub-article[@article-type=\"reply\"]";
		break;
	case "Datasets":
		break;
	case "Fragment":
		xpath="//object-id[text()=\""+doi+"\"]/..";
		break;
	case "fig":
		xpath="//object-id[text()=\""+doi+"\"]/../..";
		break;
	default:
		break;
	}
	return xpath;
}

public static String getXslFile(String key){
	
	String xslFile="";
	switch (key) {
	case "Abstract":
		xslFile="abstract.xsl";
		break;
	case "Digest":
		xslFile="digest.xsl";
			break;
	case "References":
		xslFile="reference.xsl";
		break;
	case "Acknowledgments":
		xslFile="ack.xsl";
		break;
	case "Decision letter":
		xslFile="desLetter.xsl";
		break;
	case "Author response":
		xslFile="authorResponse.xsl";
		break;
	case "abstract":
		xslFile="abstract.xsl";
		break;
	case "table-wrap":
		xslFile="tableWrap.xsl";
		break;
	case "boxed-text":
		xslFile="boxedText.xsl";
		break;
	case "media":
		xslFile="media.xsl";
		break;
	case "supplementary-material":
		xslFile="supplementary-material.xsl";
		break;
	case "fig":
		xslFile="fig.xsl";
		break;
	case "fig-group":
		xslFile="fig-group.xsl";
		break;
	case "Datasets":
		break;
	default:
		break;
	}
	return xslFile;
}
}
