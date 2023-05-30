package com.multi.service;

import java.util.List;

import com.multi.domain.BookVO;

public interface BookService {

	List<BookVO> getAllBook();
	BookVO getBookInfo(String isbn);
	int insertBook(BookVO book);
	int updateBook(BookVO book);
	int deleteBook(String isbn);
	
	List<BookVO> getPublishList();
	List<BookVO> getTitleList(String publish);
	List<BookVO> getFindBook(String title);
	
	List<String> getAutoComplete(String keyword);
}
