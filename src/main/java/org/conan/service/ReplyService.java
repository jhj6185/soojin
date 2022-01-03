package org.conan.service;

import java.util.List;

import org.conan.domain.Criteria;
import org.conan.domain.ReplyVO;

public interface ReplyService {

	public int register(ReplyVO vo);

	public ReplyVO get(Long rno);

	public int modify(ReplyVO vo);

	public int remove(Long rno);

	List<ReplyVO> getList(Criteria cri, Long bno);
	
}
