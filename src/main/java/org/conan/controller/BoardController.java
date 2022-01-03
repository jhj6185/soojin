package org.conan.controller;

import org.conan.domain.BoardVO;
import org.conan.domain.Criteria;
import org.conan.domain.PageDTO;
import org.conan.service.BoardService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	private BoardService service;
	
	@GetMapping("/list")
	public void list(Criteria cri, Model model) {

		log.info("list: " + cri);
		model.addAttribute("list", service.getList(cri));
		// model.addAttribute("pageMaker", new PageDTO(cri, 123));

		int total = service.getTotal(cri);
		log.info("total: " + total);
		model.addAttribute("pageMaker", new PageDTO(cri, total));

	}
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("register : "+ board);
		service.register(board);
		rttr.addFlashAttribute("result",board.getBno()); //result로 번호 보내주기
		return "redirect:/board/list"; //redirect:를 하지 않는 경우, 새로고침시 도배
	}
	/*
	 * @ModelAttribute : 자동으로 Model 의 데이터를 지정한 이름으로 담아줌.
	 * 사용하지 않아도 파라미터인 객체는 전달이 되지만, 좀 더 명시적으로 이름을 지정하기 위해 사용.
	 * ModelAttribute("cri") Criteria cri  ==  model.addAttribute("cri", cri)
	 */
	
	// 상세보기, 수정화면
		@GetMapping({"/get", "/modify"})
		public void get(@RequestParam("bno") Long bno, 
				@ModelAttribute("cri") Criteria cri,  //추가
				Model model) 
		{
			log.info("/get or modify");
			model.addAttribute("board", service.get(bno));
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
				Criteria cri,  //추가
				RedirectAttributes rttr) 
		{
			log.info("remove..." + bno);
			if (service.remove(bno)) {
				rttr.addFlashAttribute("result", "success");
			}
			rttr.addAttribute("pageNum", cri.getPageNum());
			rttr.addAttribute("amount", cri.getAmount());
			rttr.addAttribute("type", cri.getType());  
			rttr.addAttribute("keyword", cri.getKeyword()); 

			return "redirect:/board/list";
		}
	@GetMapping("/register")
	public void register() {

	}
	
	
}
