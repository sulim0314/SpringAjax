package com.multi.ajaxweb;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.multi.domain.UserVO;

import lombok.extern.log4j.Log4j;
//@RestController : restful방식을 지원
@Controller
@Log4j
public class AjaxController {
	
	@GetMapping("/ajaxView")
	public String ajaxView() {
		
		return "ajax/ajaxView";//뷰네임
	}
	
	@GetMapping(value="/ajaxPizzaText", produces = "text/plain; charset=UTF-8")
	@ResponseBody //반환하는 값(String)이 뷰네임이 아니라 데이터를 반환한다는 의미로 붙여준다
	public String ajaxResponse(@RequestParam(defaultValue = "") String phone) {
		log.info("phone="+phone);
		if(phone.isEmpty()||phone.equals("0000")) {//회원정보가 없을 경우
			return "0||";
		}else if(phone.equals("1111")) {
			return "111|서울 마포구 서교동|김철수";
		}else {		
			return "100|서울 마포구 상수동|홍길동";
		}
	}//------------------------------
	@GetMapping(value="/ajaxPizza", produces="application/xml")
	@ResponseBody
	public Map<String,String> ajaxXml(@RequestParam(defaultValue = "") String phone){
		log.info("phone="+phone);
		Map<String, String> map=new HashMap<>();
		map.put("userNo", "200");
		map.put("name", "이영희");
		map.put("addr", "서울 마포구 합정동");
		
		return map;
	}//---------------------------------
	
	@GetMapping(value="/ajaxVO", produces = "application/json")
	@ResponseBody
	public UserVO ajaxVO(@RequestParam(defaultValue="0")int num, @RequestParam(defaultValue="아무개")String name) {
		log.info("num: "+num+", name: "+name);
		UserVO user=new UserVO(num, name,"010-8585-7777","서울 강남구 삼성동");
		return user;
	}
	
	@PostMapping(value="/ajaxList",produces="application/json")
	@ResponseBody
	public List<UserVO> ajaxList(@RequestParam(defaultValue="0")int num, @RequestParam(defaultValue="아무개")String name){
		log.info("num: "+num+", name: "+name);
		List<UserVO> arr=new ArrayList<>();
		arr.add(new UserVO(num,name,"1111","서울"));
		arr.add(new UserVO(200,"이영희","2222","부산"));
		arr.add(new UserVO(300,"손길동","3333","광주"));
		return arr;
	} 
	
	@PostMapping(value="/ajaxJsonParam",produces="application/json")
	@ResponseBody
	public List<UserVO> ajaxJsonParam(@RequestBody UserVO vo){
		log.info("vo="+vo);
		List<UserVO> arr=new ArrayList<>();
		arr.add(new UserVO(vo.getNum(),vo.getName(),"1111","서울"));
		arr.add(new UserVO(200,"이영희","2222","부산"));
		arr.add(new UserVO(300,"손길동","3333","광주"));
		return arr;
	}
	//파일 업로드 ajax
	@PostMapping(value="/ajaxFile", produces="application/json")
	@ResponseBody
	public ModelMap ajaxFile(HttpServletRequest req,@RequestParam("filename") MultipartFile mf) {
		ServletContext ctx=req.getServletContext();
		String upDir=ctx.getRealPath("/resources/Upload");
		File dir=new File(upDir);
		if(!dir.exists()) {
			dir.mkdirs();			
		}
		log.info("upDir: "+upDir);
		String fname=mf.getOriginalFilename();
		log.info("fname: "+fname);
		try {
			mf.transferTo(new File(upDir, fname));
		}catch(IOException e) {
			log.error(e);
		}
		ModelMap map=new ModelMap("result","OK");
		map.put("filename", fname);
		return map;
	}
	
	//{result:OK} {result:Fail}
	

}











