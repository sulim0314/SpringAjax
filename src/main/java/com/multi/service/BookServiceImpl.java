package com.multi.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.multi.domain.BookVO;
@Service("bookService")
public class BookServiceImpl implements BookService{

	@Override
	public List<BookVO> getAllBook() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public BookVO getBookInfo(String isbn) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public int insertBook(BookVO book) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int updateBook(BookVO book) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public int deleteBook(String isbn) {
		// TODO Auto-generated method stub
		return 0;
	}

}
