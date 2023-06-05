package com.multi.domain;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

public class BookNaverProxy {
	
	String apiUrl="https://openapi.naver.com/v1/search/book.json";
	
	public String getNaverBook(String keyword, String start, String display) throws Exception{
		
		 String clientId = "DOSUpDJTgnyhNl65UHCv"; //애플리케이션 클라이언트 아이디
	        String clientSecret = "5SrhqOOKps"; //애플리케이션 클라이언트 시크릿


	        String text = null;
	        try {
	            text = URLEncoder.encode(keyword, "UTF-8");
	        } catch (UnsupportedEncodingException e) {
	            throw new RuntimeException("검색어 인코딩 실패",e);
	        }
	        apiUrl+="?query="+text+"&start="+start+"&display="+display;
	        System.out.println(apiUrl);
	        
	        URL url=new URL(apiUrl);
	        HttpURLConnection con=(HttpURLConnection)url.openConnection();
	        con.setRequestMethod("GET");
	        con.setRequestProperty("X-Naver-Client-Id", clientId);
	        con.setRequestProperty("X-Naver-Client-Secret", clientSecret);
	        
	        int resCode=con.getResponseCode();//200
	        
	        System.out.println("resCode: "+resCode);
	        BufferedReader br=null;
	        if(resCode==200) {
	        	br=new BufferedReader(new InputStreamReader(con.getInputStream(),"UTF-8"));
	        }else {
	        	br=new BufferedReader(new InputStreamReader(con.getErrorStream(),"UTF-8"));
	        }
	        
	        StringBuilder buf=new StringBuilder();
	        String str="";
	        while((str=br.readLine())!=null) {
	        	buf.append(str);
	        	System.out.println(str);
	        }
	        br.close();
	        
	        String response=buf.toString();
	        return response;		
	}//---------------------------------------

	public static void main(String[] args) throws Exception{
		BookNaverProxy app=new BookNaverProxy();
		String str=app.getNaverBook("Spring", "1", "10");
	}
	
}
