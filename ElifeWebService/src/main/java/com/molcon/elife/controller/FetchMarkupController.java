package com.molcon.elife.controller;

import java.net.URLDecoder;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.molcon.elife.service.FetchMarkupService;
import com.molcon.elife.util.FetchMarkupUtil;

@RestController
@RequestMapping("/service/fetchMarkup")
public class FetchMarkupController {
	
	@Autowired
	FetchMarkupService fetchMarkupService; 
	
	@RequestMapping(value="/{doi1:.+}/{doi2:.+}/{xpathKey}",method=RequestMethod.GET)
	public String getMarkup(@PathVariable String doi1,@PathVariable String doi2,@PathVariable String xpathKey)throws Exception{
		String doi=doi1+"/"+doi2; 
		System.out.println("web service(3 param) doi :" +(doi)+" xpath key :"+xpathKey);
		System.out.println("web service(3 param) doi :" +URLDecoder.decode(doi, "UTF-8")+" xpath key :"+xpathKey);
		String result="";
		
		result=fetchMarkupService.getXmlFromAmazonS3(URLDecoder.decode(doi, "UTF-8"), xpathKey);
		
		return result;
	}
	@RequestMapping(value="/{doi:.+}/{xpathKey}",method=RequestMethod.GET)
	public String getMarkup(@PathVariable String doi,@PathVariable String xpathKey)throws Exception{
		System.out.println("web service(2 param) doi :" +(doi)+" xpath key :"+xpathKey);
		System.out.println("web service(2 param) doi :" +URLDecoder.decode(doi, "UTF-8")+" xpath key :"+xpathKey);
		if(xpathKey.contains("eLife")){
			doi=doi+"/"+xpathKey;
			xpathKey="Fragment";
		}
		String result="";
		result=fetchMarkupService.getXmlFromAmazonS3(URLDecoder.decode(doi, "UTF-8"), xpathKey);
		
		return result;
	}
	@RequestMapping(value="/{doi:.+}",method=RequestMethod.GET)
	public String getMarkup(@PathVariable String doi)throws Exception{
		System.out.println("web service(1 param) doi :" +(doi));
		String result="";
		String xpathKey="Fragment";
		result=fetchMarkupService.getXmlFromAmazonS3(URLDecoder.decode(doi, "UTF-8"), xpathKey);
		
		return result;
	}
}
