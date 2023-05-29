package com.multi.service;

import java.util.List;

import javax.inject.Inject;

import org.springframework.stereotype.Service;

import com.multi.domain.BookVO;
import com.multi.mapper.BookMapper;
@Service("bookService")
public class BookServiceImpl implements BookService{
	@Inject
	private BookMapper bMapper;
	
	@Override
	public List<BookVO> getAllBook() {
		return bMapper.getAllBook();
	}

	@Override
	public BookVO getBookInfo(String isbn) {
		return bMapper.getBookInfo(isbn);
	}

	@Override
	public int insertBook(BookVO book) {
		return 0;
	}

	@Override
	public int updateBook(BookVO book) {
		return bMapper.updateBook(book);
	}

	@Override
	public int deleteBook(String isbn) {		
		return bMapper.deleteBook(isbn);
	}

	@Override
	public List<BookVO> getPublishList() {
		
		return bMapper.getPublishList();
	}

	@Override
	public List<BookVO> getTitleList(String publish) {
		return bMapper.getTitleList(publish);
	}

	@Override
	public List<BookVO> getFindBook(String title) {
		// TODO Auto-generated method stub
		return null;
	}

}
