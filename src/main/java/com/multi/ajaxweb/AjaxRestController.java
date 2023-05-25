package com.multi.ajaxweb;

import java.util.ArrayList;
import java.util.List;

import javax.inject.Inject;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.multi.domain.BookVO;
import com.multi.service.BookService;
/* Rest : Representational State Transfer의 약자
 * - 전송방식과 URI를 결합해서 원하는 작업을 지정하여 처리하도록 하는 방식
 * 	 GET/POST/PUT/DELETE
 *   - GET : 조회
 *   - DELETE : 삭제처리
 *   - POST : INSERT처리
 *   - PUT : Update처리
 *   ...
 *   URI +GET/POST/PUT/DELETE
 *   
 *   GET : /users/100 ==> 100번 회원의 정보를 조회하는 로직 처리한다
 *   GET : /users ===> 모든 회원 목록을 조회하는 로직을 처리한다
 *   DELETE: /delete/3 ==> 3번 회원 정보를 삭제 처리...
 * @RestController==> REST방식의 데이터를 처리하는 여러 기능을 쉽게 할 수 있다.
 * */
@RestController
public class AjaxRestController {
	
	@Inject
	private BookService bService;
	
	@GetMapping("/book_old")
	public String bookForm() {
		
		return "ajax/book";//@RestController에서는 뷰네임이 아니라 응답 데이터로 취급한다
	}
	
	@GetMapping("/book")
	public ModelAndView bookForm2() {
		ModelAndView mv=new ModelAndView();
		mv.addObject("msg", "Ajax 도서 정보");//데이터
		mv.setViewName("ajax/book");//뷰네임
		return mv;
	}
	@GetMapping("/books")
	public List<BookVO> bookAll(){
		List<BookVO> arr=new ArrayList<>();
		return arr;
	}
	
	

}




