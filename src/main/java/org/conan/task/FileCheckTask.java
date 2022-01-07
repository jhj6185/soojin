package org.conan.task;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Log4j
@Component
public class FileCheckTask {
	@Scheduled(cron="0 * * * * *") //초침이 0을 지날때마다 실행되게 설정
	public void checkFiles() throws Exception{
		log.warn("file check task run.........");
		log.warn("=====================================");
	}
}
