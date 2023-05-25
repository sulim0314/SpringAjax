package com.multi.domain;

import java.sql.Timestamp;

import lombok.Data;

@Data
public class BookVO {
	
	private String isbn;
	private String title;
	private String publish;
	private int price;
	private Timestamp published;
	private String bimage;

}
