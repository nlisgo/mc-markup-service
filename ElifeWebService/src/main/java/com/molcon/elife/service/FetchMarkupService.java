package com.molcon.elife.service;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.StringWriter;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathFactory;

import org.springframework.stereotype.Service;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.XMLReader;

import com.molcon.elife.util.FetchMarkupUtil;

@Service
public class FetchMarkupService {
	
	public String getXmlFromAmazonS3(String doi,String xpathKey)throws Exception{
	  
		logAccessWebService(doi, xpathKey);
		
		Pattern pattern=Pattern.compile("(eLife\\.)([0-9]+)(\\.[0-9]+)?");
		Matcher matcher=pattern.matcher(doi);
		String elifeFolder=null;
		String fragment=null;
		while(matcher.find()){
			elifeFolder=matcher.group(2);
			fragment=matcher.group(3);
		}
		
		
	    String url="https://s3.amazonaws.com/elife-cdn/elife-articles/"+elifeFolder+"/"+"elife"+elifeFolder+".xml";
	    
	    if(!new File("/home/elife/jats-xml/"+Paths.get(url).toFile().getName()).exists()){
	    	try{
	    		FetchMarkupUtil.downloadFromUrl(url, "/home/elife/jats-xml/"+Paths.get(url).toFile().getName());
	    	}catch(Exception e){
	    		return "Error Occured While Processing";
	    	}
	    	 
	    }
	    	
	    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		dbf.setValidating(false);
		DocumentBuilder db = dbf.newDocumentBuilder();
		
		Document doc = db.parse("/home/elife/jats-xml/"+Paths.get(url).toFile().getName());
		
		XPathFactory factory = XPathFactory.newInstance();
		
		XPath xpath = factory.newXPath();
		
		//get the xpath w.r.t key
		String expression=FetchMarkupUtil.getXpathByKey(xpathKey,doi);
		
		//xpath evaluation
		StringBuilder xpathContent=new StringBuilder();
		Node node=(Node)xpath.evaluate(expression, doc, XPathConstants.NODE);
		if(node==null){
			return "No Data for selected key :"+xpathKey;
		} 
		if(fragment!=null){
			xpathKey=node.getNodeName();
		}
		Element mainElement=(Element)node;
		mainElement.setAttribute("xmlns:xlink", "http://www.w3.org/1999/xlink");
		
		xpathContent.append(nodeToString(node));
		
		//creating the xml file
		try(FileWriter filewriter = new FileWriter(new File("/home/elife/elife.xml"))) {
			
			filewriter.write(xpathContent.toString());
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		StreamSource xpathContentStreamSource = new StreamSource(new File("/home/elife/elife.xml"));
		
		
		StreamSource xlsStreamSource = new StreamSource(Paths
	            .get("/home/elife/"+FetchMarkupUtil.getXslFile(xpathKey))
	            .toAbsolutePath().toFile());
		
		
		
		TransformerFactory transformerFactory=TransformerFactory.newInstance();

		StringWriter writer= new StringWriter();
		StreamResult result = new StreamResult(writer);
	    
		//transformation of xml using xsl
	    Transformer transformer = transformerFactory.newTransformer(xlsStreamSource);
	    transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
	    transformer.transform(xpathContentStreamSource, result);
	    
		
		return writer.getBuffer().toString();
		//xpathContentMap.put();
	
	}
	
	public  String nodeToString(Node node)throws TransformerException{
	    StringWriter buf = new StringWriter();
	    Transformer xform = TransformerFactory.newInstance().newTransformer();
	    xform.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "no");
	    xform.transform(new DOMSource(node), new StreamResult(buf));
	    return(buf.toString());
	}
	public void logAccessWebService(String doi,String xpathKey){
		
		try(FileWriter filewriter = new FileWriter(new File("/home/elife/elifeWebServiceLog.txt"),true)) {
			
			filewriter.write(new Date()+"\t"+doi+"\t"+xpathKey+"\t");
			filewriter.write("\n");
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace(); 
		}
	}
}
