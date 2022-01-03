package org.conan.test;

import static org.junit.Assert.fail;

import java.sql.Connection;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

//Runner 클래스(테스트 메소드를 실행하는 클래스) 를 SpringJUnit4ClassRunner로 함
@RunWith(SpringJUnit4ClassRunner.class)
//location 속성 경로에 있는 xml 파일을 이용해서 스프링이 로딩됨
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j

public class DataSourceTest {

	@Setter(onMethod_= {@Autowired})
	private DataSource ds;
	
	
	   @Test 
	     public void testConnection() { 
	        try( 
	              Connection con =
	              ds.getConnection()){ log.info(con); 
	        }catch(Exception e) {
	           fail(e.getMessage()); }
	     
	        }

	   @Setter(onMethod_= {@Autowired})
	   private SqlSessionFactory sqlSessionFactory;
	@Test
	public void testMyBatis() {
		try(SqlSession session = sqlSessionFactory.openSession();
				Connection con = session.getConnection();){
			log.info(session);
			log.info(con);}
		catch(Exception e) {
			fail(e.getMessage());
		}
	}
	
}
