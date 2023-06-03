<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	// NoticeNo 값 넘어오지 않으면 noticeList.jsp로 이동
	// 요청값 유효성 검사
	if (request.getParameter("noticeNo") == null) {
		response.sendRedirect(request.getContextPath() + "/notice/noticeList.jsp");
		return;
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println(noticeNo + " <-- noticeNo(deleteNotice)");
	
	System.out.println("==========================deleteNotice==========================");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>deleteNotice</title>
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
		
		<div class="text-center">
			<h1>공지 삭제</h1>
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
		
		<a href="<%=request.getContextPath()%>/notice/noticeOne.jsp?noticeNo=<%=noticeNo%>" class="btn btn-outline-dark">뒤로 가기</a>
		<br>
		<form action="<%=request.getContextPath()%>/notice/deleteNoticeAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="text-bg-dark text-center">공지 번호</th>
					<td><input type="text" name="noticeNo" value="<%=noticeNo%>" readonly="readonly" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">비밀번호</th>
					<td><input type="password" name="noticePw" class="form-control w-25"></td>
				</tr>
			</table>
			<button type="submit" class="btn btn-dark">삭제</button>
		</form>
		</div>
	</body>
</html>