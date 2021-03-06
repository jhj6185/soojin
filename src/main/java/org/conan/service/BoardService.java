package org.conan.service;

import java.util.List;

import org.conan.domain.BoardAttachVO;
import org.conan.domain.BoardVO;
import org.conan.domain.Criteria;

public interface BoardService {
	public void register(BoardVO board);
	public BoardVO get(Long bno);
	public boolean modify(BoardVO board);
	public boolean remove(Long bno);
	public List<BoardVO> getList();
	List<BoardVO> getList(Criteria cri);
	//boardServiceImpl, boardServiceTest랑 다 이어지기때문에
	//impl, test에서 인자로 criteria 받고 싶으면 여기서도 인자를 가진 형태로 선언해줘야함
	public int getTotal(Criteria cri); //impl이랑 똑같이 선언하면 됨
	List<BoardAttachVO> getAttachList(Long bno);
}
