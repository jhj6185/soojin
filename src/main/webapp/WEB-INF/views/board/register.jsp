<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<title>Register</title>
<%@include file="../includes/header.jsp"%>

<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<h1 class="page-header">BOARD REGISTER</h1>
		</div>
		<!-- /.col-lg-12 -->
	</div>
	<!-- /.row -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default">
				<div class="panel-heading">Board Register (게시글 등록)</div>
				<!-- /.panel-heading -->
				<div class="panel-body">
					<form role="form" action="/board/register" method="post">
						<div class = "form-group">
							<label>Title</label><input class="form-control" name="title">
						</div>
						<div class = "form-group">
							<label>Content</label><textarea class="form-control" name="content" rows="3"></textarea>
						</div>
						<div class = "form-group">
							<label>Writer</label><input class="form-control" name="writer">
						</div>
						<button type ="submit" class="btn btn-default">Submit</button>
						<button type ="reset" class="btn btn-default">Reset</button>
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


<%@include file="../includes/footer.jsp"%>
</body>

</html>