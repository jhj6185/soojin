<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Get</title>
<%@include file="../includes/header.jsp"%>

<script src="http://code.jquery.com/jquery-latest.js"></script>
<!-- 푸터에 있음 -->
<style>
.bigPictureWrapper{
position: absolute;
display: none;
justify-content: center;
align-items: center;
top: 0%;
width: 100%;
height: 100%;
background-color: gray;
z-index: 100;
background: rgba(255,255,255,0.5);
}
.bigPicture{
position: relative;
display: flex;
justify-content: center;
align-items: center;
}
.bigPicture img{
width: 400px;
}

.uploadResult{
width: 100%;
background-color: #ddd;
}
.uploadResult ul{
display:flex;
flex-flow: row;
justify-content: center;
align-items: center;
}
.uploadResult ul li{
list-style: none;
padding : 10px;
}
.uploadResult ul li img{
width: 20px;
}
/* 원본 이미지 보여주기 */
.uploadResult ul li span{
color: white
}
</style>
</head>
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
					<div class="uploadResult">
					<!-- 업로드시, 미리보기로 사진이 보일 공간, ul하나에 파일 하나씩 담김 -->
						<ul></ul>
					</div>
					<!-- 원본이미지 보여주기 -->
					<div class="bigPictureWrapper">
					<div class="bigPicture"></div>
					</div>
					<!-- 원본이미지 보여주기 끝 -->

					<%-- <button data-oper="modify" class="btn btn-default" onclick="location.href='/board/modify?bno=<c:out value="${board.bno}"/>'">Modify</button>
					<button data-oper="list" class="btn btn-default" onclick="location.href='/board/list'">List</button> --%>


					<!-- <button data-oper='modify' class="btn btn-outline btn-primary">Modify</button>
                  <button data-oper='list' class="btn btn-outline btn-success">List</button> -->
					<form id='operForm' action="/board/modify" method="get">
						<input type="hidden" id="bno" name="bno" value="${board.bno}">
						<input type="hidden" name="pageNum" value="${cri.pageNum}">
						<input type="hidden" name="amount" value="${cri.amount}">
						<input type="hidden" name="type" value="${cri.type}"> <input
							type="hidden" name="keyword" value="${cri.keyword}">
					</form>

					<button data-oper="modify"
						class="btn btn-outline btn-primary btn-sm">Modify</button>
					<button data-oper="list" class="btn btn-outline btn-info btn-sm">List</button>




				</div>
				<!-- /.table-responsive -->
			</div>
			<!-- /.panel-body -->
		</div>
		<!-- /.panel -->

		<!-- 댓글 창 시작 -->
		<div class="panel panel-default">
			<div class="panel-heading">
				<i class="fa fa-comments fa-fw">Reply</i>
				<button id="addReplyBtn" type="button"
					class="btn btn-primary btn-xs pull-right">댓글 작성</button>
			</div>
			<div class="panel-body">
				<ul class="chat">
					<li class="left clearfix" data-rno="12">
						<div>
							<div class="header">
								<strong class="primary-font">user00</strong> <small
									class="pull-right text-muted">2021-05-18 13:13</small>
							</div>
							<p>Good job</p>
						</div>
					</li>
				</ul>
			</div>
			<div class="panel-footer"></div>
		</div>
		<!-- 댓글 panel 끝 -->

		<!-- 모달창 생성 시작 -->
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
			aria-labelledby="myModallabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
						<h4 class="modal-title" id="myModalLabel">REPLY MODAL</h4>
					</div>
					<div class="modal-body">
						<div class="form-group">
							<label>Reply</label> <input class="form-control" name='reply'
								value="New Reply!!!!">
						</div>
						<!-- replyer, replyDate를 위한 div배치 -->
						<div class="form-group">
							<label>Replyer</label> <input class="form-control" name='replyer'
								value="New Reply!!!!">
						</div>
						<div class="form-group">
							<label>ReplyDate</label> <input class="form-control"
								name='replyDate' value="New Reply!!!!">
						</div>
					</div>
					<div class="modal-footer">
						<button type="button" id="modalModBtn" class="btn btn-info">Modify</button>
						<!-- id가 modalRemoveBtn, modalRegisterBtn, modalCloseBtn 배치 -->
						<button type="button" id="modalRemoveBtn" class="btn btn-info">Remove</button>
						<button type="button" id="modalRegisterBtn" class="btn btn-info">Register</button>
						<button type="button" id="modalCloseBtn" class="btn btn-info">Close</button>
					</div>
				</div>
				<!-- modal-content 끝 -->
			</div>

		</div>
		<!-- 모달창 생성 끝 -->

	</div>
	<!-- /.col-lg-6 -->
</div>
<!-- /.row -->

<!-- /#page-wrapper -->

<script type="text/javascript" src="/resources/js/reply.js"></script>
<!-- 경로는 그냥 절대경로로 해도됨 -->
<script type="text/javascript">
	$(document)
			.ready(
					function() {

						//reply module --> reply.js에서 replyService에 함수를 선언해놓음
						//그 함수들은 replyService.함수이름 으로 사용가능
						console.log(replyService);

						var operForm = $("#operForm");
						$('button[data-oper="modify"]').on(
								"click",
								function(e) {
									operForm.attr("action", "/board/modify")
											.submit();
								});
						$('button[data-oper="list"]').on("click", function(e) {
							operForm.find("#bno").remove();
							operForm.attr("action", "/board/list");
							operForm.submit();
						});

						var bnoValue = '<c:out value="${board.bno}"/>'; //get으로 보는 글의 bno
						/* replyService.add( //add 함수 호출
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
								}); */

						/* replyService.remove(3, function(count){ //get으로 들어가면 rno가 3인 댓글 삭제됨
							console.log(count);
							if(count==="success"){ alert("REMOVED");}
						}, function(err){
							alert('error occurred....');
						}); */

						/* replyService.update({ //게시글을 조회하면 게시글의 rno가 4 인 댓글을 수정해주는 기능
							rno:4,
							bno:bnoValue,
							reply:"modified reply..."
						}, function(result){
							alert("수정 완료");
						})
						
						replyService.get(4,function(data){ //특정 댓글 조회 테스트
							console.log("뀨엥뀨잉---------------------------"+data);
						// 뀨엥뀨잉--------------[object Object] 로 출력됨
						}); */

						
						//댓글의 페이지 번호 처리
						var pageNum = 1;
						var replyPageFooter = $(".panel-footer");
						function showReplyPage(replyCnt) { //replyCnt는 reply.js에 가서 replyCnt를 callback해줘서
							//replyCnt를 쓸수있다 -> 
							console.log("showReplyPage : " + replyCnt);
							var endNum = Math.ceil(pageNum / 10.0) * 10;
							var startNum = endNum - 9;
							var prev = startNum != 1;
							var next = false;
							if (endNum * 10 >= replyCnt) {
								endNum = Math.ceil(replyCnt / 10.0);
							}
							if (endNum * 10 < replyCnt) {
								next = true;
							}
							var str = "<ul class='pagination pull-right'>";

								if (prev) {
									str += "<li class='page-item'><a class='page-link' href='"
											+ (startNum - 1)
											+ "'>Previous</a></li>";
								}
								for (var i = startNum; i <= endNum; i++) {
									var active = pageNum == i ? "active" : "";
									str += "<li class='page-item "+active+"'><a class='page-link' href='"+i+"'>"
											+ i + "</a></li>";
								}
								if (next) {
									str += "<li class='page-item'><a class='page-link' href='"
											+ (endNum + 1) + "'>Next</a></li>";
								}
								str += "</ul></div>";
								console.log(str);
								replyPageFooter.html(str);
							} //showReplyPage
						
							//페이지 번호 클릭 시 새로운 댓글 출력
							replyPageFooter.on("click", "li a", function(e){
								e.preventDefault();
								console.log("page click");
								var targetPageNum = $(this).attr("href");
								console.log("targetPageNum : "+targetPageNum);
								pageNum = targetPageNum;
								showList(pageNum);//댓글 수정과 삭제시에도 댓글이 포함된 페이지로 이동하도록 수정
							})
						
						//댓글이벤트 처리
						var replyUL = $(".chat");
						showList(1);
						function showList(page) {
							replyService.getList(
							//반환값이 list
							{
								bno : bnoValue,//bno와 page를 reply.js의 param으로 들어가게보냄
								page : page || 1
							},
							function(replyCnt, list) {
								console.log("replyCnt : "
										+ replyCnt);
								console.log("list : " + list);
								if (page == 0) {
									pageNum = Math
											.ceil(replyCnt / 10.0);
									showList(pageNum);
									return;
								}
								var str = "";
								if (list == null
										|| list.length == 0) {
									replyUL.html("");
									return;
								}
								for (var i = 0, len = list.length || 0; i < len; i++) {
									str += "<li class='left clearfix' data-rno='"+list[i].rno+"'>";
									str += "<div><div class='header'><strong class='primary-font'>"
											+ list[i].replyer
											+ "</strong>";
									str += "<small class='pull-right text-muted'>"
											+ replyService
													.displayTime(list[i].replyDate)
											+ "</small><div>";
									str += "<p>"
											+ list[i].reply
											+ "</p><div></li>";
								}
								replyUL.html(str);
								showReplyPage(replyCnt);
							}); //function call
						} //showList

						//댓글 작성 버튼 클릭시 모달 보이기
						var modal = $(".modal");
						var modalInputReply = modal.find("input[name='reply']");
						var modalInputReplyer = modal
								.find("input[name='replyer']");
						var modalInputReplyDate = modal
								.find("input[name='replyDate']");

						var modalModBtn = $("#modalModBtn");
						var modalRemoveBtn = $("#modalRemoveBtn");
						var modalRegisterBtn = $("#modalRegisterBtn");

						$("#addReplyBtn").on("click", function(e) {
							modal.find("input").val("");
							modalInputReplyDate.closest("div").hide();
							modal.find("button[id!='modalCloseBtn']").hide(); //댓글작성 버튼 클릭시
							//close버튼만 보여야하므로
							modalRegisterBtn.show();
							$(".modal").modal("show");
						});

						//새로운 댓글 처리(새 댓글 추가 기능)
						modalRegisterBtn.on("click", function(e) {
							var reply = {
								reply : modalInputReply.val(),
								replyer : modalInputReplyer.val(),
								bno : bnoValue
							};
							replyService.add(reply, function(result) {
								alert(result); //댓글 등록이 정상임을 팝업으로 알림
								modal.find("input").val(""); //댓글 등록이 정상적으로 이뤄지면 내용을 지움
								modal.modal("hide"); //모달 창 지움
								showList(0); //새로운 댓글을 추가하면 page값을 0으로 전송하고, 댓글의 전체숫자를
								//파악한 후에 페이지 이동
							})
						})

						// 특정 댓글의 클릭 이벤트
						$(".chat")
								.on("click","li",
								function(e) {
									modalInputReplyDate.closest("div")
											.show(); //댓글 클릭할 때마다 replyDate를 무조건 보여주도록 설정
									//댓글 작성 버튼을 누를때 replyDate를 hide 시켜놔서 댓작성 버튼 눌렀다가 댓글 버튼 누르면
									// 날짜가 안보이는 이슈가 있었음
									var rno = $(this).data("rno");
									replyService.get(
										rno,
										function(reply) {
											modalInputReply.val(reply.reply);
											modalInputReplyer.val(reply.replyer);
											modalInputReplyDate
													.val(replyService.displayTime(reply.replyDate))
													.attr("readonly","readonly");
											modal.data("rno",reply.rno);
											modal.find("button[id!='modalCloseBtn']").hide();
											modalModBtn.show();
											modalRemoveBtn.show();
											$(".modal").modal("show");
										})
									});

						//댓글의 수정/삭제 처리 이벤트
						modalModBtn.on("click", function(e) {
							var reply = {
								rno : modal.data("rno"),
								reply : modalInputReply.val()
							};
							replyService.update(reply, function(result) {
								alert(result);
								modal.modal("hide");
								showList(1);
							});
						});

						modalRemoveBtn.on("click", function(e) {
							var rno = modal.data("rno");
							replyService.remove(rno, function(result) {
								alert(result);
								modal.modal("hide");
								showList(1);
							});
						});
						
						//첨부된 파일리스트 bno로 가져오기
						var bno='<c:out value="${board.bno}"/>';
						$.getJSON("/board/getAttachList", {bno: bno}, function(arr){
							console.log(arr);
								var str="";
								$(arr).each(function(i,obj){//forEach문은 첫번째값이 index, 두번째값이 객체
									console.dir("dkkk앙아아아ㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏㅏ");
									//하나만쓸때는 객체만()에 넣어준다
									//uploadResultArr이 obj로 하나씩 들어감
									//여기서 obj는 showUploadedFile(result)로 호출되서 들어오는데, result는 첨부한 파일의 리스트이다
									if(!obj.fileType){//이미지 아님
										var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
										str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename= '"+obj.fileName+"' data-type='"+obj.image+"'><div><span>"+obj.fileName+"</span>";
										str+="<br>";
										str+="<img src='/resources/images/attach.png'></a>";
										str+="</div></li>";
									}else{// 이미지인 경우
									
									var fileCallPath =
										encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
	
									str+="<li data-path='"+obj.uploadPath+"' data-uuid='"+obj.uuid+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
									str+="<span>"+obj.fileName+"</span>";
									str+="<br><img src='/display?fileName="+fileCallPath+"'>";
									/* str+="<br><img src='javascript:showImage(\'"+fileCallPath+"'>"; */
									str+="</div></li>";
									}
							});
							$(".uploadResult ul").html(str);
						}); //end getJson
						
						function showImage(fileCallPath){
							alert(fileCallPath);
							//원본 이미지 보여주기(미리보기 사진 클릭시 사진확대)
							$(".bigPictureWrapper").css("display","flex").show();
							$(".bigPicture").html("<img src='/display?fileName="+encodeURI(fileCallPath)+"'>")
							.animate({width: '100%', height: '100%'}, 1000);
						}// <a>태그에서 직접 showImage() 호출할 수 있도록 document ready 외부에 선언

						//커진 화면 클릭시 닫히는 기능
						$(".bigPictureWrapper").on("click", function(e){
							$(".bigPicture").animate({width: '0%', height: '0%'}, 1000);
							setTimeout(function(){
								$('.bigPictureWrapper').hide();
							},1000);
						}) //bigPictureWrapper click
						

					});
</script>




<%@include file="../includes/footer.jsp"%>
</body>

</html>