package org.conan.service;

import java.util.List;

import org.conan.domain.Criteria;
import org.conan.domain.ReplyPageDTO;
import org.conan.domain.ReplyVO;
import org.conan.mapper.ReplyMapper;
import org.conan.persistence.BoardMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
public class ReplyServiceImpl implements ReplyService {
	@Setter(onMethod_=@Autowired)
	private ReplyMapper mapper;
	@Setter(onMethod_=@Autowired)
	private BoardMapper boardMapper;
	
	@Transactional
	@Override
	public int register(ReplyVO vo) {//댓글 작성시 댓글 수가 +1되도록
		log.info("register...."+vo);
		boardMapper.updateReplyCnt(vo.getBno(),1);
		return mapper.insert(vo);
	}
	@Override
	public ReplyVO get(Long rno) {
		log.info("get........"+rno);
		return mapper.read(rno);
	}
	@Override
	public int modify(ReplyVO vo) {
		log.info("modify......"+vo);
		return mapper.update(vo);
	}
	
	@Transactional
	@Override
	public int remove(Long rno) { //댓글 삭제시 댓글수가 -1되도록
		log.info("remove..........."+rno);
		ReplyVO vo = mapper.read(rno);
		boardMapper.updateReplyCnt(vo.getBno(), -1);
		return mapper.delete(rno);
	}
	@Override
	public List<ReplyVO> getList(Criteria cri, Long bno){
		log.info("get Reply List of a Board........."+bno);
		return mapper.getListWithPaging(cri, bno);
	}
	
	@Override
	public ReplyPageDTO getListPage(Criteria cri, Long bno) {
		log.info(bno+"의 댓글 count 갯수 : "+ mapper.getCountByBno(bno));
		return new ReplyPageDTO(
				mapper.getCountByBno(bno),
				mapper.getListWithPaging(cri, bno));
	}
}
