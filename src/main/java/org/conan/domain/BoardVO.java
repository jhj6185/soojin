package org.conan.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class BoardVO {
	private Long bno; 
	private String title; 
	private String content;
	private String writer;
	private Date regDate;
	private Date updateDate;
	private int replyCnt; //댓글 수
	private List<BoardAttachVO> attachList; //여러개의 첨부파일을 가진다
}
