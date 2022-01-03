<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<title>Get</title>
<%@include file="../includes/header.jsp"%>

<script src="http://code.jquery.com/jquery-latest.js"></script>
<!-- 푸터에 있음 -->
<script type="text/javascript" src="/resources/js/reply.js"></script>
<!-- 경로는 그냥 절대경로로 해도됨 -->

<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">BOARD GET</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">Board Get (게시글 조회)</div>
				<!-- /.panel-heading -->
				<div class="panel-body">

					<div class="form-group">
						<label>Bno</label><input class="form-control" name="bno"
							value='<c:out value="${board.bno}"/>' readonly="readonly">
					</div>
					<div class="form-group">
						<label>Title</label><input class="form-control" name="title"
							value='<c:out value="${board.title}"/>' readonly="readonly">
						<%-- <label>Title</label><input class="form-control" name="title" value="${board.title}"/> --%>
					</div>
					<div class="form-group">
						<label>Content</label>
						<textarea class="form-control" name="content" rows="3"
							readonly="readonly">${board.content}</textarea>
					</div>
					<div class="form-group">
						<label>Writer</label><input class="form-control" name="writer"
							value='<c:out value="${board.writer}"/>' readonly="readonly">
					</div>
					

					<%-- <button data-oper="modify" class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">Modify</button>
					<button data-oper="list" class="btn btn-default" onclick="location.href='/board/list'">List</button> --%>


					<!-- <button data-oper='modify' class="btn btn-outline btn-primary">Modify</button>
                  <button data-oper='list' class="btn btn-outline btn-success">List</button> -->
					<form id='operForm' action="/board/modify" method="get">
						<input type="hidden" id="bno" name="bno" value="${board.bno}">
						<input type="hidden" name="pageNum" value="${cri.pageNum}">
						<input type="hidden" name="amount" value="${cri.amount}">
						<input type="hidden" name="type" value="${cri.type}">
						<input type="hidden" name="keyword" value="${cri.keyword}">
					</form>
						
						<button data-oper="modify" class="btn btn-outline btn-primary btn-sm">Modify</button>
						<button data-oper="list" class="btn btn-outline btn-info btn-sm">List</button>
					



				</div>
				<!-- /.table-responsive -->
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->
	</div>
	<!-- /.col-lg-6 -->
</div>
<!-- /.row -->

<!-- /#page-wrapper -->

<script type="text/javascript">
	$(document).ready(function(){
		
		//reply module
		console.log(replyService);
		
		var operForm = $("#operForm");
		$('button[data-oper="modify"]').on("click",function(e){
			operForm.attr("action","/board/modify").submit();
		});
		$('button[data-oper="list"]').on("click",function(e){
			operForm.find("#bno").remove();
			operForm.attr("action","/board/list");
			operForm.submit();
		});
		
		var bnoValue='<c:out value="${board.bno}"/>'; //get으로 보는 글의 bno
		replyService.add( //add 함수 호출
				{reply : "JS TEST", replyer: "js tester", bno : bnoValue }, //댓글로 등록될 데이터
				function(result){
					alert("RESULT : "+result);
				})
				
		replyService.getList( //게시글을 조회할 때마다 댓글 추가됨
				{bno : bnoValue, page : 1},
				function(list){
					for (var i=0, len = list.length || 0; i<len; i++){
						console.log(list[i]);
					}
				});
		
		/* replyService.remove(3, function(count){ //get으로 들어가면 rno가 3인 댓글 삭제됨
			console.log(count);
			if(count==="success"){ alert("REMOVED");}
		}, function(err){
			alert('error occurred....');
		}); */
		
		replyService.update({ //게시글을 조회하면 게시글의 rno가 4 인 댓글을 수정해주는 기능
			rno:4,
			bno:bnoValue,
			reply:"modified reply..."
		}, function(result){
			alert("수정 완료");
		})
		
		replyService.get(4,function(data){ //특정 댓글 조회 테스트
			console.log("뀨엥뀨잉---------------------------"+data);
		// 뀨엥뀨잉--------------[object Object] 로 출력됨
		});
	});
</script>




<%@include file="../includes/footer.jsp"%>
</body>

</html>