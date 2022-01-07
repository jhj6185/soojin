package org.conan.domain;

import lombok.Data;

@Data
public class AttachFileDTO {
	private String fileName;
	private String uploadPath;
	private String uuid;
	private boolean fileType;
}
//업로드된 파일의 데이터 반환
//업로드 이후에 반환해야 하는 정보
//- 업로드 된 파일의 이름과 원본 파일의 이름
// - 파일이 저장된 경로
// - 업로드 된 파일이 이미지파일인가 아닌가에 대한 정보
//정보들을 객체로 처리하고 json으로 전송