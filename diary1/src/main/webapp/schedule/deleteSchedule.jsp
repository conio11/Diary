<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	// 인코딩 설정
	request.setCharacterEncoding("UTF-8");

	// 요청값 유효성 검사
	if (request.getParameter("scheduleNo") == null) {
		response.sendRedirect(request.getContextPath() + "/schedule/scheduleListByDate.jsp");
		return;
	}
	
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println(scheduleNo + " <-- scheduleNo(deleteSchedule)");
	
	System.out.println("==========================deleteSchedule==========================");
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>deleteSchedule</title>
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
			<h1>일정 삭제</h1>
		</div>
		<form action="<%=request.getContextPath()%>/schedule/deleteScheduleAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="text-bg-dark text-center">일정 번호</th>
					<td>
						<input type="text" name="scheduleNo" value="<%=scheduleNo%>" readonly="readonly" class="form-control w-25">
					</td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">비밀번호</th>
					<td>
						<input type="password" name="schedulePw" class="form-control w-25">
					</td>
				</tr>
			</table>
			<button type="submit" class="btn btn-dark">삭제</button>
		</form>
		</div>
	</body>
</html>