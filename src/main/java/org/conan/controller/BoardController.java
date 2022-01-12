package org.conan.controller;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.conan.domain.BoardAttachVO;
import org.conan.domain.BoardVO;
import org.conan.domain.Criteria;
import org.conan.domain.PageDTO;
import org.conan.service.BoardService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	private BoardService service; //serviceImpl로 가야함, service엔 걍 함수이름만 선언되어있고
	//기능은 serviceImpl에 있음
	
	//서버에 업로드 된 파일들을 삭제하기 위한 메소드
	private void deleteFiles(List<BoardAttachVO> attachList) {
		if(attachList == null|| attachList.size() == 0) { return; }
		log.info("delete attach files............");
		log.info(attachList);
		attachList.forEach(attach->{
			try {
				Path file = Paths.get("c:/upload/"+attach.getUploadPath()+"/"+
			attach.getUuid()+"_"+attach.getFileName());
				Files.deleteIfExists(file);
				if(Files.probeContentType(file).startsWith("image")) {
					Path thumbNail = Paths.get("c:/upload/"+attach.getUploadPath()+
							"/s_"+attach.getUuid()+"_"+attach.getFileName());
					Files.delete(thumbNail);
				}
			}catch(Exception e) {
				log.error("delete file error : "+e.getMessage());
			}
		});
	}
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {

		log.info("list: " + cri);
		model.addAttribute("list", service.getList(cri));

		int total = service.getTotal(cri);
		log.info("total: " + total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));

	}
	@PostMapping("/register") //게시글 저장
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register : "+ board); //board는 게시글을 저장할 때 딱 하나의 
		// bno,title,content,writer~을 가짐
		//데이터 수집 여부 확인
		if(board.getAttachList() !=null) {
			board.getAttachList().forEach(attach -> log.info("11111"+attach));
		}
		  service.register(board); //register가 실행되면 register 안에 있는 selectKey도 실행됨
		  rttr.addFlashAttribute("result",board.getBno()); //getBno는 BoardVO에서 번호를 가져오는거고
		  //insertSelectKey의 selectKey는 mysql의 bno값을 가져와서 boardVO에 setting 해 주는것
		  //그니까 순서상 register 의 selectKey가 boardVO의 bno는 첨에 0일 텐데, 그걸 mysql에서
		  //가져와서 setting 해주는 것임
		  //그 후에 그 번호를 가져와주는게 board.getBno()
		  //그렇게 얻은것을 result로 번호 보내주기
		 return "redirect:/board/list"; //redirect:를 하지 않는 경우, 새로고침시 도배
		 //(confirm 하라는 alert창이 계속 뜸)
	}
	/*
	 * @ModelAttribute : 자동으로 Model 의 데이터를 지정한 이름으로 담아줌.
	 * 사용하지 않아도 파라미터인 객체는 전달이 되지만, 좀 더 명시적으로 이름을 지정하기 위해 사용.
	 * ModelAttribute("cri") Criteria cri  ==  model.addAttribute("cri", cri)
	 */
	
	@GetMapping("/register")
	   public void register() {
		//url로 들어가는 것을 postMapping이 허용하지 않아서 하나 만들어줌
	   }
	
	// 상세보기, 수정화면
		@GetMapping({"/get", "/modify"})
		public void get(@RequestParam("bno") Long bno, 
				@ModelAttribute("cri") Criteria cri,  //추가
				Model model) 
		{
			log.info("/get or modify");
			model.addAttribute("board", service.get(bno));
			//cri가 뭐냐면 bno를 requestParam으로 받잖아?? 그러면 bno는 bno로 들어가
			// 근데 bno외에 get 방식으로 오는 정보들은 cri 라는 데에다가 다 받아버리겠다 이거임
			//그리고 cri를 %{cri.~~~}로 사용할 수도 있게 됨!!
			// get 이랑 modify페이지에서 el태그 사용 가능한것
		}
		
		// 수정처리
		@PostMapping("/modify")
		public String modify(
				BoardVO board, 
				@ModelAttribute("cri") Criteria cri,  //추가
				RedirectAttributes rttr) 
		{
			log.info("modify: " + board);

			if (service.modify(board)) {
				rttr.addFlashAttribute("result", "success");
			}
			rttr.addAttribute("pageNum", cri.getPageNum());
			rttr.addAttribute("amount", cri.getAmount());
			rttr.addAttribute("type", cri.getType());  
			rttr.addAttribute("keyword", cri.getKeyword());  

			return "redirect:/board/list";
		}	
		
		// 삭제 처리
		@PostMapping("/remove")
		public String remove(
				@RequestParam("bno") Long bno,
				@ModelAttribute ("cri") Criteria cri,  //추가
				RedirectAttributes rttr) 
		{
			log.info("remove..." + bno);
			List<BoardAttachVO> attachList = service.getAttachList(bno);
			if (service.remove(bno)) {
				deleteFiles(attachList);
				rttr.addFlashAttribute("result", "success");
			}
			rttr.addAttribute("pageNum", cri.getPageNum());
			rttr.addAttribute("amount", cri.getAmount());
			rttr.addAttribute("type", cri.getType());  
			rttr.addAttribute("keyword", cri.getKeyword()); 

			return "redirect:/board/list";
		}
		
		//게시물 조회할 때 파일 관련 자료를 json데이터로 만들어서 화면에 전송
		@GetMapping(value = "/getAttachList", produces = MediaType.APPLICATION_JSON_VALUE)
		@ResponseBody
		public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno){
			log.info("getAttachList"+bno);
			return new ResponseEntity<>(service.getAttachList(bno), HttpStatus.OK);
		}
	
	
}
