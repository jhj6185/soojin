package org.conan.service;

import java.util.List;

import org.conan.domain.BoardAttachVO;
import org.conan.domain.BoardVO;
import org.conan.domain.Criteria;
import org.conan.mapper.BoardAttachMapper;
import org.conan.persistence.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
@Log4j
@Service
//전체 생성자 초기화
//@AllArgsConstructor
public class BoardServiceImpl implements BoardService {
	@Setter(onMethod=@__({@Autowired})) //전체 생성자 초기화하면 사용x
	private BoardMapper mapper;
	@Setter(onMethod=@__({@Autowired})) //전체 생성자 초기화하면 사용x
	private BoardAttachMapper attachMapper;
	
	@Transactional
	@Override
	public void register(BoardVO board) {
		log.info("register...."+board);
		mapper.insertSelectKey(board);
		if(board.getAttachList()==null || board.getAttachList().size()<=0) {
			return;
		}
		log.info("보드서비스임플 : "+board.getBno());
		  board.getAttachList().forEach(attach->{ attach.setBno(board.getBno());
		  attachMapper.insert(attach); });
		 
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("get...."+bno);
		return mapper.read(bno);
	}
	
	@Transactional
	@Override
	public boolean modify(BoardVO board) {
		log.info("modify...."+board);
		attachMapper.deleteAll(board.getBno()); //db에서 모든 첨부파일 정보 삭제
		boolean modifyResult = mapper.update(board)==1; //board 테이블 정보 수정
		if(modifyResult && board.getAttachList()!= null&& board.getAttachList().size()>0) {
			board.getAttachList().forEach(attach->{
				attach.setBno(board.getBno());
				attachMapper.insert(attach); //db에 첨부파일 정보 저장
			});
		}
		//첨부파일은 수정이라는 개념 존재 x
		//db에서 기존 파일 모두 삭제후 남아있던 목록의 파일들 추가 ->
		// db 내용과 서버 업로드 폴더의 내용 불일치( 주기적으로 파일과 db비교하여 일치시키는 작업 추가)
		return modifyResult;
	}
	
	@Transactional
	@Override
	public boolean remove(Long bno) {
		log.info("remove...."+bno);
		attachMapper.deleteAll(bno); //첨부파일과 게시물이 같이 삭제되도록
		return mapper.delete(bno)==1;
	}

	@Override
	public List<BoardVO> getList() {
		log.info("getList.........");
		return mapper.getList();
	}
	
	@Override
	public List<BoardVO> getList(Criteria cri){
		log.info("getList with criteria : "+cri);
		return mapper.getListWithPaging(cri);
	}
	
	@Override
	public int getTotal(Criteria cri) {
		log.info("get total count");
		return mapper.getTotalCount(cri);
	}
	
	@Override
	public List<BoardAttachVO> getAttachList(Long bno){
		log.info("get Attach list by bno"+bno);
		return attachMapper.findByBno(bno);
	}
}
