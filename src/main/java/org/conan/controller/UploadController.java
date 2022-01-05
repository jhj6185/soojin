package org.conan.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;

@Controller
@Log4j
public class UploadController {
	
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str= sdf.format(date);
		return str.replace("-", File.separator);
	}
	
	@GetMapping("/uploadForm")
	public void uploadForm() {
		log.info("upload form");
	}
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		String uploadFolder="c:/upload";
		for(MultipartFile multipartFile: uploadFile) {
			log.info("----------------------");
			log.info("Upload File Name : "+multipartFile.getOriginalFilename());
			log.info("Upload File Size : "+multipartFile.getSize());
			
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			try {
				multipartFile.transferTo(saveFile);
			}catch(Exception e) {
				log.error(e.getMessage());
			}
		}
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload ajax");
	}
	
	@PostMapping("/uploadAjaxAction")
	public void uploadAjaxPost(MultipartFile[] uploadFile) {
		String uploadFolder="c:\\upload";
		//폴더 생성하기
		File uploadPath =new File(uploadFolder, getFolder());//getFoler()는 맨 위에 만들어놨는데
		//현재날짜를 읽어서 폴더로 만들어주는거 임
		//글고 결국엔 new File()안에있는 쉼표가 +같은 개념이라서 uploadFolder인 c:\\upload + 날짜폴더를 uploadPath로
		//지정 해준다. ( 그니까 upload폴더 가 부모폴더, getFolder()가 하위폴더로 만들어지도록 한거)
		log.info("upload Path : "+uploadPath);
		
		for(MultipartFile multipartFile: uploadFile) {
			log.info("------------------------------");
			log.info("Upload File Name : "+multipartFile.getOriginalFilename());
			log.info("Upload File Size : "+multipartFile.getSize());
			//File saveFile = new File(uploadPath, multipartFile.getOriginalFilename());
			//주석한 이유는 실습땜시 ,, 이거는 그냥 파일명으로 저장되는 기능
			//파일 저장하는 경로를 uploadPath로 가게 하려고 uploadPath를 적어준다.
			//uploadPath 는 C:\\upload\날짜폴더\ 이다.
			
			//중복된 이름의 파일 처리
			UUID uuid = UUID.randomUUID();
			String uploadFileName=multipartFile.getOriginalFilename();
			uploadFileName = uuid.toString()+"_"+uploadFileName;
			File saveFile = new File(uploadPath, uploadFileName);//uuid를 이용해서 고유한 파일명 생성
			
			try {
				multipartFile.transferTo(saveFile);
				if(uploadPath.exists() == false) {//폴더가 존재하지 않으면 새로 생성
					uploadPath.mkdirs(); // yyyy/MM/dd폴더 생성
				}
				
				
			}catch(Exception e) {
				log.error(e.getMessage());
			}
			
		}
	}
	
	
}
