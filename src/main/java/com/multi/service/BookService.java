package com.multi.service;

import java.util.List;

import com.multi.domain.BookVO;

public interface BookService {

	List<BookVO> getAllBook();
	BookVO getBookInfo(String isbn);
	int insertBook(BookVO book);
	int updateBook(BookVO book);
	int deleteBook(String isbn);
}
