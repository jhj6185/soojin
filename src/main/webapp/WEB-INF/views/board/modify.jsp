<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<title>Modify</title>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<!-- 푸터에 있음 -->
<%@include file="../includes/header.jsp"%>
<%@include file="../includes/footer.jsp"%>
<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">BOARD MODIFY</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">Board Modify (게시글 수정)</div>
				<!-- /.panel-heading -->
				<div class="panel-body">
					<form role="form" action="/board/modify" method="post">
						<input type="hidden" name="pageNum" value="${cri.pageNum}">
						<input type="hidden" name="amount" value="${cri.amount}">
						<input type="hidden" name="type" value="${cri.type}"> <input
							type="hidden" name="keyword" value="${cri.keyword}">

						<div class="form-group">
							<label>Bno</label><input class="form-control" name="bno"
								value='<c:out value="${board.bno}"/>' readonly="readonly">
						</div>
						<div class="form-group">
							<label>Title</label><input class="form-control" name="title"
								value='<c:out value="${board.title}"/>'>
							<%-- <label>Title</label><input class="form-control" name="title" value="${board.title}"/> --%>
						</div>
						<div class="form-group">
							<label>Content</label>
							<textarea class="form-control" name="content" rows="3">${board.content}</textarea>
						</div>
						<div class="form-group">
							<label>Writer</label><input class="form-control" name="writer"
								value='<c:out value="${board.writer}"/>' readonly="readonly">
						</div>
						<div class="form-group">
							<label>regDate</label><input class="form-control" name="regDate"
								value='<fmt:formatDate value="${board.regDate}" pattern="yyyy/MM/dd"/>'
								readonly="readonly">
						</div>
						<div class="form-group">
							<label>updateDate</label><input class="form-control"
								name="updateDate"
								value='<fmt:formatDate value="${board.updateDate}" pattern="yyyy/MM/dd"/>'
								readonly="readonly">
						</div>


						<button type="submit" data-oper="modify" class="btn btn-info">Modify</button>
						<button type="submit" data-oper="remove" class="btn btn-danger">Remove</button>
						<button type="submit" data-oper="list" class="btn btn-success">List</button>
					</form>
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
	$(document).ready(function() {
		var formObj = $("form");
		
		$('button').on("click", function(e) {
			e.preventDefault();
			var operation = $(this).data("oper");
			console.log(operation);
			if (operation === 'remove') {
				formObj.attr("action", "/board/remove");
			} else if (operation === 'list') {
				formObj.attr("action", "/board/list").attr("method", "get");

				//수정/삭제 취소 후, 목록 페이지로 이동
				//pageNum 과 amount 만 사용하므로,
				//<form> 태그에서 필요한 부분만 잠시 복사(clone) 해서 보관해 두고, 
				//<form> 태그 안에 내용은 지워(empty)버립니다.
				//이후에 다시 필요한 태그들만 추가해서 '/board/list' 를 호출
				formObj.attr("action", "/board/list").attr("method", "get");

				var pageNumTag = $("input[name='pageNum']").clone(); //잠시 보관용
				var amountTag = $("input[name='amount']").clone();
				var keywordTag = $("input[name='keyword']").clone();
				var typeTag = $("input[name='type']").clone();

				formObj.empty(); //제거

				formObj.append(pageNumTag); //필요한 태그들만 추가
				formObj.append(amountTag);
				formObj.append(keywordTag);
				formObj.append(typeTag);
			}
			formObj.submit();
		});
	});
</script>

</body>


</html>