package com.multi.domain;

import java.sql.Date;

import lombok.Data;

@Data
public class BookVO {
	
	private String isbn;
	private String title;
	private String publish;
	private int price;
	private Date published;
	private String bimage;

}
