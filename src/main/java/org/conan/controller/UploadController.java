package org.conan.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.conan.domain.AttachFileDTO;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j
public class UploadController {
	
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str= sdf.format(date);
		return str.replace("-", File.separator);
	}
	
	
	  private boolean checkImageType(File file) {//이미지 파일 여부의 판단
	  try {
	  String contentType =
	  Files.probeContentType(file.toPath()); return
	  contentType.startsWith("image"); }
	  catch(IOException e) { e.printStackTrace();
	  } return false; 
	  //true 면 이미지파일인것 
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
	
	@PostMapping(value="/uploadAjaxAction", produces= MediaType.APPLICATION_JSON_VALUE)
	@ResponseBody
		public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile){
		String uploadFolder="c:\\upload";
		List<AttachFileDTO> list = new ArrayList<>();
		//폴더 생성하기
		File uploadPath =new File(uploadFolder, getFolder());//getFoler()는 맨 위에 만들어놨는데
		//현재날짜를 읽어서 폴더로 만들어주는거 임
		//글고 결국엔 new File()안에있는 쉼표가 +같은 개념이라서 uploadFolder인 c:\\upload + 날짜폴더를 uploadPath로
		//지정 해준다. ( 그니까 upload폴더 가 부모폴더, getFolder()가 하위폴더로 만들어지도록 한거)
		log.info("upload Path : "+uploadPath);
		if(uploadPath.exists() == false) {//폴더가 존재하지 않으면 새로 생성
			uploadPath.mkdirs(); // yyyy/MM/dd폴더 생성
		}
		
		for(MultipartFile multipartFile: uploadFile) {
			AttachFileDTO attachDTO = new AttachFileDTO();
			log.info("------------------------------");
			log.info("Upload File Name : "+multipartFile.getOriginalFilename());
			log.info("Upload File Size : "+multipartFile.getSize());
			//File saveFile = new File(uploadPath, multipartFile.getOriginalFilename());
			//주석한 이유는 실습땜시 ,, 이거는 그냥 파일명으로 저장되는 기능
			//파일 저장하는 경로를 uploadPath로 가게 하려고 uploadPath를 적어준다.
			//uploadPath 는 C:\\upload\날짜폴더\ 이다.
			
			//중복된 이름의 파일 처리
			UUID uuid = UUID.randomUUID();
			String uploadFileName=multipartFile.getOriginalFilename(); //파일이름 설정
			attachDTO.setFileName(uploadFileName); //이게 없으니까 dto에 filename이 null로 들어갔다
			uploadFileName = uuid.toString()+"_"+uploadFileName;
			File saveFile = new File(uploadPath, uploadFileName);//uuid를 이용해서 고유한 파일명 생성
			
			try {
				multipartFile.transferTo(saveFile);
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(getFolder());
			  //썸네일을 처리하는 단계
			  if(checkImageType(saveFile)) { //이미지 파일이면
				  attachDTO.setImage(true);
			  FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath,
			  "s_"+uploadFileName)); //이미지 파일이면 s_를 붙여서 저장하도록 함.(이게 썸네일)
			  Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail,
			  100,100); thumbnail.close(); 
			  }
				list.add(attachDTO);
				log.info("attachDTO : "+attachDTO);
				//attachDTO의 파일 네임을 바꾸는 부분이 빠졌다....
			}catch(Exception e) {
				log.error(e.getMessage());
			} //for
		}
		return new ResponseEntity<>(list,HttpStatus.OK);
	}
	
	@GetMapping("/display")// display?fileName=파일ㄴㅔ임 으로 들어감
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		log.info("fileName : "+fileName);
		File file = new File("c:/upload/"+fileName);
		log.info("file : "+file);
		ResponseEntity<byte[]> result = null;
		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			//적당한 MIME 타입(미디어 타입)을 헤더에 추가함
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file),
					header, HttpStatus.OK);
		}catch(IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	//첨부파일의 다운로드
	@GetMapping(value="download", produces=MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(String fileName){
		log.info("download file : "+fileName);
		Resource resource = new FileSystemResource("c:/upload/"+fileName);
		//ppt에선 urid도 나와잇는데 아님
		if(resource.exists() == false) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		log.info("resource : "+resource);
		String resourceName= resource.getFilename();
		
		//remove UUID
		String resourceOriginalName= resourceName.substring(resourceName.indexOf("_")+1);
		log.info("resourceOriginalName : "+resourceOriginalName);
		HttpHeaders headers = new HttpHeaders();
		try {
			//다운로드시 저장되는 이름
			headers.add("Content-Disposition", "attachment; fileName="+new String(resourceOriginalName
					.getBytes("UTF-8"), "ISO-8859-1"));//resourceName은 uuid가 들어가는name인데 resourceOriginalName
			//으로 바꿔주고 부터는 uploadAjax에서 업로드 후,클릭해서 다운받는거 할 때 uuid없이 클-린하게 파일명 이쁘게 들어감
		}catch(UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource> (resource, headers, HttpStatus.OK);
	}
	
}
