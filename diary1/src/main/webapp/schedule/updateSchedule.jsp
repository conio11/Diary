<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>    
    
<%
	// post 방식 인코딩
	request.setCharacterEncoding("UTF-8");

	if (request.getParameter("scheduleNo") == null) {
		response.sendRedirect("./scheduleList.jsp");
		return; // 코드 진행 종료
	}
	
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println(scheduleNo + " <--scheduleNo(updateSchedule)");
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	 
	String sql = "SELECT schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate, updatedate FROM schedule WHERE schedule_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);	
	stmt.setInt(1, scheduleNo); // stmt의 ? 에 pracNo 대입
	System.out.println(stmt + " <-- stmt(updateSchedule)");
	
	// stmt를 ResultSet 타입으로 변환
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + " <-- rs(updateSchedule)");
	
	// 자료구조 ResultSet 타입을 일반적인 자료구조 타입으로 변환
	Schedule schedule = null;
	if (rs.next()) {
		schedule = new Schedule();
		schedule.scheduleNo = rs.getInt("scheduleNo");
		schedule.scheduleDate = rs.getString("scheduleDate");
		schedule.scheduleTime = rs.getString("scheduleTime");
		schedule.scheduleMemo = rs.getString("scheduleMemo");
		schedule.scheduleColor = rs.getString("scheduleColor");
		schedule.createdate= rs.getString("createdate");
		schedule.updatedate = rs.getString("updatedate");
	}
	 
	System.out.println("==========================updateSchedule==========================");
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>updateSchedule</title>
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
			<h1>일정 수정</h1>
		</div>
		<%
			if (request.getParameter("msg") != null) {	
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
		<form action="<%=request.getContextPath()%>/schedule/updateScheduleAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="text-bg-dark text-center">일정 번호</th>
					<td><input type="text" name="scheduleNo" value="<%=schedule.scheduleNo%>" readonly="readonly" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">비밀번호</th>
					<td><input type="password" name="schedulePw" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">일정 날짜</th>
					<td><input type="date" name="scheduleDate" value="<%=schedule.scheduleDate%>" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">일정 시간</th>
					<td><input type="time" name="scheduleTime" value="<%=schedule.scheduleTime%>" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">폰트 색상</th>
					<td><input type="color" name="scheduleColor" value="<%=schedule.scheduleColor%>" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">메모</th>
					<td><textarea cols="60" rows="5" name="scheduleMemo" class="form-control w-75"><%=schedule.scheduleMemo%></textarea></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">작성일자</th>
					<td><%=schedule.createdate.substring(0, 10)%></td> <!-- DB 내 데이터 그대로 출력, 넘길 값 X -->
				</tr>
				<tr>
					<th class="text-bg-dark text-center">수정일자</th>
					<td><%=schedule.updatedate.substring(0, 10)%></td> <!-- DB 내 데이터 그대로 출력, 넘길 값 X -->
				</tr>
			</table>
			<button type="submit" class="btn btn-dark">수정</button>
		</form>
		</div>
	</body>
</html>