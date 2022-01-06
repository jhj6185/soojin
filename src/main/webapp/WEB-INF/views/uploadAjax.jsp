<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.uploadResult{
width: 100%;
height: 50px;
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
padding 10px;
}
.uploadResult ul li img{
width: 20px;
}
/* 원본 이미지 보여주기 */
.uploadResult ul li span{
color: white
}
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
</style>
</head>
<body>
<div class="uploadDiv">
<input type="file" name="uploadFile" multiple>
</div>
<div class="uploadResult">
<ul></ul>
</div>
<!-- 원본이미지 보여주기 -->
<div class="bigPictureWrapper">
<div class="bigPicture"></div>
</div>
<!-- 원본이미지 보여주기 끝 -->
<button id="uploadBtn">Upload</button>
</body>
<!-- jQuery -->
<script src="/resources/vendor/jquery/jquery.min.js"></script>
<script>
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

//x표시 이벤트 처리
$(".uploadResult").on("click","span",function(e){
	var targetFile = $(this).data("file");
	var type=$(this).data("type");
	console.log(targetFile);
	$.ajax({
		url: '/deleteFile',
		data: {fileName:targetFile, type:type},
		dataType:'text',
		type: 'post',
		success: function(result){ alert(result); }
	}); //$.ajax
})

$(document).ready(function(){
	var cloneObj=$(".uploadDiv").clone();
	//업로드 전에<input type='file'>객체가 포함된 <div> 복사
	
	//업로드 된 이미지 처리
	var uploadResult=$(".uploadResult ul");
	
	function showUploadedFile(uploadResultArr){
		var str="";
		//console.dir(uploadResultArr);
		//일반 파일의 처리
		$(uploadResultArr).each(function(i,obj){
			if(!obj.image){//이미지 아님
				var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
				str+="<li><div><a href='/download?fileName="+fileCallPath+"'><img src='/resources/images/attach.png'>"
						+obj.fileName+"</a><span data-file=\'"+fileCallPath+"\' data-type='file'>x</span></div></li>"; 
						//이미지 아닌거의 attach.png 아이콘 클릭시 다운로드됨
			}else{// 이미지인 경우
			/* str+="<li>"+obj.fileName+"</li>"; */
			var fileCallPath =
				encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
			//원본 이미지 보여주기
			var originPath = obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName;
			originPath=originPath.replace(new RegExp(/\\/g),"/");
			str+="<li><a href=\"javascript:showImage(\'"+originPath+"\')\"><img src='/display?fileName="
					+fileCallPath+" '></a><span data-file=\'"+fileCallPath+"\' data-type='image'>x</span></li>";
					
			}
		});
		uploadResult.append(str);
	}//showUploadedFile
	
	//파일의 확장자나 크기 사전처리 - 정규식을 이용해서 파일 확장자 체크
	var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
	var maxSize = 5242880;
	function checkExtension(fileName, fileSize){
		if(fileSize>=maxSize){
			alert("파일 크기 초과");
			return false;
		}
		if(regex.test(fileName)){//zip파일 업로드시 (test는 javascript의 if문 문법임)
		//regex랑 fileName이 일치하면
			alert("해당 종류의 파일은 업로드 할 수 없음");
			return false;
		}
		return true;
	}
	//upload버튼 클릭시
	$("#uploadBtn").on("click", function(e){
		var formData = new FormData();
		var inputFile=$("input[name='uploadFile']");
		var files = inputFile[0].files;
		console.log(files);
		
		//add filedata to formdata
		for(var i=0; i<files.length; i++){
			if(!checkExtension(files[i].name, files[i].size)){//파일 확장자 체크
				return false;
			}
			formData.append("uploadFile",files[i]);
		}
		console.log("files.length : "+files.length);
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
	});
	
	
	
	
})
</script>
</html>