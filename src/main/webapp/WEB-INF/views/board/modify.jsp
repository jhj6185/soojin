<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<style>
.uploadResult {
	width: 100%;
	background-color: #ddd;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li {
	list-style: none;
	padding: 10px;
}

.uploadResult ul li img {
	width: 20px;
}
/* 원본 이미지 보여주기 */
.uploadResult ul li span {
	color: white
}
</style>
<title>Modify</title>
<script src="http://code.jquery.com/jquery-latest.js"></script>
<!-- 푸터에 있음 -->
<%@include file="../includes/header.jsp"%>
<%@include file="../includes/footer.jsp"%>
</head>
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
						
						<div class="form-group uploadDiv">
							<input type="file" name="uploadFile" multiple>
							<!-- 파일선택 버튼 -->
						</div>
						<div class="uploadResult">
							<!-- 업로드시, 미리보기로 사진이 보일 공간, ul하나에 파일 하나씩 담김 -->
							<ul></ul>
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
			} else if(operation === 'modify'){//게시판 수정 이벤트 처리
				console.log('submit clicked');
				var str="";
				$(".uploadResult ul li").each(function(i,obj){
					var jobj = $(obj);
					console.dir(jobj);
					str+="<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
					str+="<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
					str+="<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
					str+="<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type")+"'>";
				});
				formObj.append(str);
			}			
			formObj.submit();
		}); //button click end
		
		var cloneObj=$(".uploadDiv").clone();
		//업로드 전에<input type='file'>객체가 포함된 <div> 복사
		
		//업로드 된 이미지 처리
		var uploadResult=$(".uploadResult ul");
		
		//첨부파일의 변경 처리
		$(".uploadResult").on("click","button",function(e){
			var targetFile = $(this).data("file");
			var type= $(this).data("type");
			var targetLi = $(this).closest("li");
			
			if(confirm("이 파일을 삭제하시겠습니까? ")){
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
			
			$.ajax({
				url: '/deleteFile',
				data : {fileName : targetFile, type : type},
				dataType : 'text',
				type: 'post',
				success : function(result){
					alert(result);
					targetLi.remove();
				}
			}); //$.ajax
		}); //uploadResult click event
		
		//첨부된 파일리스트 bno로 가져오기
		var bno='<c:out value="${board.bno}"/>';
		$.getJSON("/board/getAttachList", {bno: bno}, function(arr){
			console.log(arr);
				var str="";
				$(arr).each(function(i,obj){//forEach문은 첫번째값이 index, 두번째값이 객체
					//하나만쓸때는 객체만()에 넣어준다
					//uploadResultArr이 obj로 하나씩 들어감
					//여기서 obj는 showUploadedFile(result)로 호출되서 들어오는데, result는 첨부한 파일의 리스트이다
					if(!obj.fileType){//이미지 아님
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
						str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename= '"+obj.fileName+"' data-type='"+obj.image+"'><div><span>"+obj.fileName+"</span>";
						str+="<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button>";
						str+="<br>";
						str+="<img src='/resources/images/attach.png'></a>";
						str+="</div></li>";
					}else{// 이미지인 경우
					
					var fileCallPath =
						encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);

					str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
					str+="<span>"+obj.fileName+"</span>";
					str+="<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'> <i class='fa fa-times'></i></button>";
					str+="<br><img src='/display?fileName="+fileCallPath+"'>";
					/* str+="<br><img src='javascript:showImage(\'"+fileCallPath+"'>"; */
					str+="</div></li>";
					}
			});
			$(".uploadResult ul").html(str);
		}); //end getJson
		
		function showUploadedFile(uploadResultArr){
			//업로드 된 결과를 화면에 썸네일 또는 아이콘으로 출력하기
			if(!uploadResultArr|| uploadResultArr.length == 0){ return; }
			var uploadUL = $(".uploadResult ul");
			var str="";
			//console.dir(uploadResultArr);
			//일반 파일의 처리
			$(uploadResultArr).each(function(i,obj){//forEach문은 첫번째값이 index, 두번째값이 객체
				//하나만쓸때는 객체만()에 넣어준다
				//uploadResultArr이 obj로 하나씩 들어감
				//여기서 obj는 showUploadedFile(result)로 호출되서 들어오는데, result는 첨부한 파일의 리스트이다
				if(!obj.fileType){//이미지 아님
					var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
					str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename= '"+obj.fileName+"' data-type='"+obj.fileType+"'><div><span>"+obj.fileName+"</span>";
					str+="<button type='button' data-file=\'"+fileCallPath+"\' data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str+="<img src='/resources/images/attach.png'></a>";
					str+="</div></li>";
				}else{// 이미지인 경우
				
				var fileCallPath =
					encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);

				str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.fileType+"'><div>";
				str+="<span>"+obj.fileName+"</span>";
				str+="<button type='button' data-file=\'"+fileCallPath+"\' data-type='image' class='btn btn-warning btn-circle'> <i class='fa fa-times'></i></button>";
				str+="<br><img src='/display?fileName="+fileCallPath+"'>";
				str+="</div></li>";
				}
			});
			$(".uploadResult ul").html(str);
			//uploadUL.append(str);
		}//showUploadedFile
		
		//파일의 확장자나 크기 사전처리 - 정규식을 이용해서 파일 확장자 체크
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880;
		function checkExtension(fileName, fileSize) {
			if (fileSize >= maxSize) {
				alert("파일 크기 초과");
				return false;
			}
			if (regex.test(fileName)) {//zip파일 업로드시 (test는 javascript의 if문 문법임)
				//regex랑 fileName이 일치하면
				alert("해당 종류의 파일은 업로드 할 수 없음");
				return false;
			}
			return true;
		}
		
		//파일선택 클릭해서 파일 업로드하는게 바뀔때마다 파일업로드
		$(document).on('change',"input[type='file']", function(e){
		/* $("input[type='file']").change(function(e) { */
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files;

			//add filedata to formdata
			for (var i = 0; i < files.length; i++) {
				if (!checkExtension(files[i].name, files[i].size)) {//파일 확장자 체크
					return false;
				}
				formData.append("uploadFile", files[i]);
			}
			
			$.ajax({
				url: '/uploadAjaxAction',
				processData: false, //전달할 데이터를 query string을 만들지 말 것
				contentType: false,
				data: formData, //전달할 데이터
				type : 'POST',
				dataType : 'json',
				success: function(result){
					alert('Uploaded');
					console.log(result);
					showUploadedFile(result);//업로드 된 이미지 처리
					$(".uploadDiv").html(cloneObj.html()); //미리 파일 업로드 전 input을 복사해놓은거를
					//업로드가 성공적으로 완료되면 다시 html에 보여줌

				}
			}); //$.ajax

		})
	});
</script>

</body>


</html>