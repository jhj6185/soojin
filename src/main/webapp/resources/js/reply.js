
console.log("Reply Module..............");
var replyService=(function(){
	
   function add(reply, callback, error){ //ajax 처리 후 동작해야 하는 함수
	console.log("reply......");
	$.ajax({ //ajax로 replyController 호출
		type:'post',
		url:'/replies/new',
		data : JSON.stringify(reply),
		contentType: "application/json; charset=utf-8",
		success: function(result, status, xhr){
			if(callback){ callback(result);}
		},
		error : function(xhr, status, er){
			if(error){error(er);}
		}
	})
} // add

	function getList(param, callback, error){  //param이 데이터
		var bno = param.bno;
		var page = param.page || 1;
		$.getJSON("/replies/pages/"+bno+"/"+page+".json",
			function(data){
				if(callback){ callback(data.replyCnt, data.list); }//반환값이 list
				// 게시글의 댓글 수와 페이지를 사용하도록 수정했음
			}).fail(function(xhr, status, err){
				if(error){ error(); }
			});
	}// getList
	
	function remove(rno, callback, error){
		$.ajax({
			type : 'delete',
			url : '/replies/'+rno,
			success:function(deleteResult, status, xhr){
				if(callback){ callback(deleteResult) ; }
			},
			error : function (xhr, status, er){
				if(error){error(er);}
			}
		});
	} //remove
	
	function update(reply, callback, error){
		$.ajax({
			type : 'put',
			url : '/replies/'+reply.rno,
			data : JSON.stringify(reply),
			contentType: "application/json; charset=utf-8",
			success: function(result, status, xhr){
				if(callback){ callback(result); }
			},
			error:function(xhr, status, er){
				if(error){ error(er); }
			}
		});
	} //update
	
	function get(rno, callback, error){ //특정 댓글 조회
		$.get("/replies/"+rno+".json", function(result){
			if(callback){ callback(result); }
		}).fail(function(xhr, status, err){
			if(error){ error(); }
		});
	} //get
	
	function displayTime(timeValue){ // 당일에 해당하는 데이터는 시/분/초, 
	// 전일 등록된 데이터는 년/월/일 출력
		var today=new Date();
		var gap = today.getTime()-timeValue;
		var dateObj = new Date(timeValue);
		var str="";
		if(gap<(1000*60*60*24)){
			var hh=dateObj.getHours(); var mi= dateObj.getMinutes();
			var ss = dateObj.getSeconds();
			return [(hh>9?'': '0')+hh, ':',(mi> 9? '' : '0')+mi, ':',
			(ss>9? '':'0')+ss].join('');
		}else{
			var yy = dateObj.getFullYear();
			var mm= dateObj.getMonth()+1;
			var dd= dateObj.getDate();
			return [yy, '/', (mm>9?'':'0')+mm, '/', (dd>9 ? '' : '0')+dd].join('');
		}
	}// displayTime
	
return {add : add, getList: getList, remove: remove, 
		update : update, get : get, displayTime : displayTime}; 
		//모듈 패턴으로 외부에 노출하는 정보

})();         // reply Service라는 변수에 name이라는 속성, "AAA"라는 값을 가진 객체 할당