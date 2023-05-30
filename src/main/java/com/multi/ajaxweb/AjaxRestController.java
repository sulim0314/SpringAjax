package com.multi.ajaxweb;

import java.util.List;

import javax.inject.Inject;

import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.multi.domain.BookVO;
import com.multi.service.BookService;

import lombok.extern.log4j.Log4j;
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
@Log4j
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
	@GetMapping(value="/books",produces="application/json")
	public List<BookVO> bookAll(@RequestParam(defaultValue="") String keyword){
		log.info("keyword=="+keyword);
		
		List<BookVO> arr=null;
		if(keyword.isEmpty()) {	//keyword가 없다면 모든 도서정보 가져오기
			arr=bService.getAllBook();
		}else {
			//검색한 도서정보 가져오기
			arr=bService.getFindBook(keyword);
		}
		return arr;
	}
	
	@GetMapping(value="/books/{isbn}", produces="application/json")
	public BookVO bookInfo(@PathVariable("isbn") String isbn) {
		log.info("isbn: "+isbn);
		BookVO book=this.bService.getBookInfo(isbn);
		return book;
	}
	
	@PutMapping(value="/books/{isbn}", produces="application/json")
	public ModelMap bookUpdate(@PathVariable("isbn") String isbn, @RequestBody BookVO vo) {
		log.info("isbn: "+isbn+", vo: "+vo);
		int n=this.bService.updateBook(vo);
		String str=(n>0)?"OK":"Fail";
		
		ModelMap map=new ModelMap("result",str);
		return map;
	}
	
	@DeleteMapping(value="/books/{isbn}", produces="application/json")
	public ModelMap bookDelete(@PathVariable("isbn") String isbn) {
		log.info("isbn="+isbn);
		int n=bService.deleteBook(isbn);
		String str=(n>0)?"OK":"Fail";
		
		ModelMap map=new ModelMap("result", str);
		return map;
	}
	
	
	@GetMapping(value="/publishList", produces="application/json")
	public List<BookVO> getPublishList(){
		List<BookVO> arr=bService.getPublishList();
		return arr;
	}
	
	@GetMapping(value="/titleList", produces="application/json")
	public List<BookVO> getTitleList(@RequestParam("publish") String publish){
		
		return bService.getTitleList(publish);
	}
	
	@PostMapping(value="/autoComp", produces="application/json")
	public List<String> getAutoComplete(@RequestParam(defaultValue="") String keyword){
		log.info("keyowrd: "+keyword);
		
		return bService.getAutoComplete(keyword);
	}
	

}















