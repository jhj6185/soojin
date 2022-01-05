package org.conan.persistence;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.conan.domain.BoardVO;
import org.conan.domain.Criteria;

public interface BoardMapper {//기능들 다 정의
	//@Select("select * from tbl_board where bno>0")
	public List<BoardVO> getList();
	public void insert(BoardVO board);
	public BoardVO read(long bno);
	public int delete(long bno);
	public int update(BoardVO board);
	public void insertSelectKey(BoardVO board);
	public List<BoardVO> getListWithPaging(Criteria cri);
	public int getTotalCount(Criteria cri);
	public void updateReplyCnt(@Param("bno")Long bno, @Param("amount") int amount);
}
