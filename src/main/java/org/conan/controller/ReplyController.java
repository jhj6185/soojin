package org.conan.controller;

import org.conan.domain.Criteria;
import org.conan.domain.ReplyPageDTO;
import org.conan.domain.ReplyVO;
import org.conan.service.ReplyService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@RequestMapping("/replies")
@RestController
@Log4j
@AllArgsConstructor
public class ReplyController {
	private ReplyService service;

	// 등록작업과 테스트
	@PostMapping(value = "/new", consumes = "application/json", produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> create(@RequestBody ReplyVO vo) {//@RequestBody는 파라미터로 들어오는걸 ReplyVO형태로
		//바꿔주는 역할을 한다
		log.info("ReplyVO : " + vo); // replyer, reply, bno 필요
		int insertCount = service.register(vo); //insert한 갯수(댓글)
		log.info("Reply INSERT COUNT : " + insertCount);
		return insertCount == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}

	// 특정 게시물의 댓글 목록
	@GetMapping(value = "/pages/{bno}/{page}", produces = { MediaType.APPLICATION_XML_VALUE,
			MediaType.APPLICATION_JSON_VALUE })
	public ResponseEntity<ReplyPageDTO> getList(@PathVariable("page") int page, @PathVariable("bno") Long bno) {
		//반환타입을 알고싶다면? return을 봐봐 근데 ResponseEntity<>가 있지?
		//그러면 public ResponseEntity의 <> 안에 ReplyPageDTO가 있지?
		//이게 반환타입이얌 . 그니까 service.getListPage(cri,bno)도 반환타입이 ReplyPageDTO인거
		//*****개꿀팁 : service.getListPage(cri,bno)에 마우스갖다대면 맨 첫번째 뜨는게 반환타입!
		log.info("getList....");
		Criteria cri = new Criteria(page, 10); //댓글을 한 페이지당 10개씩 보여줌
		log.info("cri : " + cri);
		return new ResponseEntity<> (service.getListPage(cri, bno), HttpStatus.OK);
	}

	@GetMapping(value = "/{rno}", // 댓글의 조회
			produces = { MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_VALUE })
	public ResponseEntity<ReplyVO> get(@PathVariable("rno") Long rno) {
		log.info("get : " + rno);
		return new ResponseEntity<>(service.get(rno), HttpStatus.OK);
	}

	// 댓글의 삭제
	@DeleteMapping(value = "/{rno}", produces = { MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno) {
		log.info("remove : " + rno);
		return service.remove(rno) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}

	// 댓글의 수정
	@RequestMapping(method = { RequestMethod.PUT,
			RequestMethod.PATCH }, value = "/{rno}", consumes = "application/json", produces = {
					MediaType.TEXT_PLAIN_VALUE })
	public ResponseEntity<String> modify(@RequestBody ReplyVO vo, @PathVariable("rno") Long rno) {
		vo.setRno(rno);
		log.info("rno: " + rno);
		log.info("modify : " + vo);
		return service.modify(vo) == 1 ? new ResponseEntity<>("success", HttpStatus.OK)
				: new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}
