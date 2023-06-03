<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>insertNotice</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
	</head>
	<body>
		<!-- 메인 메뉴: 상단 좌측 '홈으로', '공지 리스트', '일정 리스트' 버튼 -->
		<div class="container mt-3">
		<div>
			<a href="<%=request.getContextPath()%>/home.jsp" class="btn btn-outline-dark">홈으로</a>
			<a href="<%=request.getContextPath()%>/notice/noticeList.jsp" class="btn btn-outline-dark">공지 리스트</a>
			<a href="<%=request.getContextPath()%>/schedule/scheduleList.jsp" class="btn btn-outline-dark">일정 리스트</a>
		</div>
		<br>
		<div class="text-center">
			<h1>새 공지 입력</h1>
		</div>
		
		<!-- action에서 받아온 msg 값이 null이 아닐 경우 (오류가 있을 경우) 출력  -->
		<div class="text-danger">
			<%
				if (request.getParameter("msg") != null) {
			%>
					<%=request.getParameter("msg")%>
			<%
				}
			%>
		</div>
		
		<form action="<%=request.getContextPath()%>/notice/insertNoticeAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="text-bg-dark text-center">공지 제목</th>
					<td>
						<input type="text" name="noticeTitle" class="form-control w-75">
					</td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">내용</th>
					<td>
						<textarea rows="5" cols="80" name="noticeContent" class="form-control w-75"></textarea>
					</td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">작성자</th>
					<td>
						<input type="text" name="noticeWriter" class="form-control w-75">
					</td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">비밀번호</th>
					<td>
						<input type="password" name="noticePw" class="form-control w-75">
					</td>
				</tr>
			</table>
			<button type="submit" class="btn btn-outline-dark">입력</button>
		</form>
		</div>
	</body>
</html>