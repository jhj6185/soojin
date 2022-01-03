package org.conan.test;

import java.util.List;
import java.util.stream.IntStream;

import org.conan.domain.Criteria;
import org.conan.domain.ReplyVO;
import org.conan.mapper.ReplyMapper;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;


@RunWith(SpringJUnit4ClassRunner.class)

@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTest {
	
	@Setter(onMethod= @__({@Autowired}))
	private ReplyMapper mapper;
	
	@Test
	public void testMapper() {
		log.info(mapper);
	}
	
	
	  private Long[] bnoArr = {1L,4L,7L,9L,10L};
	  
	  @Test public void testCreate() { IntStream.rangeClosed(1,10).forEach(i->{
	  ReplyVO vo = new ReplyVO(); vo.setBno(bnoArr[i%5]); vo.setReply("댓글 테스트"+i);
	  vo.setReplyer("replyer"+i); mapper.insert(vo); }); }
	 
	  @Test
	  public void testRead() {
		  Long targetRno = 1L;
		  ReplyVO vo = mapper.read(targetRno);
		  log.info(vo);
	  }
	  
	  @Test
	  public void testDelete() {
		  Long targetRno = 1L;
		  mapper.delete(targetRno);
	  }
	  
	  @Test
	  public void testUpdate() {
		  Long targetRno = 10L;
		  ReplyVO vo= mapper.read(targetRno);//10번 읽은걸 vo에 넣어
		  vo.setReply("Update Reply"); //댓글 내용 이걸로 setting
		  int count = mapper.update(vo);
		  log.info("Update Count : "+count);
	  }
	  
	  @Test
	  public void testList() {
		  Criteria cri = new Criteria();
		  List<ReplyVO> replies =
				  mapper.getListWithPaging(cri, bnoArr[0]); //왜 배열로 만든거지? => 그냥 테스트하려고
		  //그리고 bnoArr에 담겨있는 0번째 값이 1L여서 1번글의 댓글이 쫘라락 불러와질거임
		  replies.forEach(reply -> log.info(reply));
	  }
}

