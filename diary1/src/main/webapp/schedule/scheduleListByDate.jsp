<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%> 

<%
	// 일정 입력 + 일별 스케줄 리스트 

	// 인코딩 설정
	request.setCharacterEncoding("UTF-8");
	
	// y, m, d, 값이 null 또는 공백값이면 scheduleList.jsp로 이동
	if (request.getParameter("y") == null
	|| request.getParameter("m") == null
	|| request.getParameter("d") == null
	|| request.getParameter("y").equals("")
	|| request.getParameter("m").equals("")
	|| request.getParameter("d").equals("")) {
		response.sendRedirect(request.getContextPath() + "/schedule/scheduleList.jsp");
		return; // 실행 종료
	}
	
	// Date(날짜)값 슬라이스
	int y = Integer.parseInt(request.getParameter("y"));
	int m = Integer.parseInt(request.getParameter("m")) + 1; // 자바 API -> 12월(11로 표기) / MariaDB -> 12월(12로 표기)
	int d = Integer.parseInt(request.getParameter("d"));

	// 디버깅
	System.out.println(y + " <-- y(scheduleListByDate)");
	System.out.println(m + " <-- m(scheduleListByDate)");
	System.out.println(d + " <-- d(scheduleListByDate)");
	
	// 1 ~ 9월일 경우 01 ~ 09월로 표기하기 위한 변수 strM
	String strM = m + ""; // int 형에 공백 붙여주면 String으로 자동 형변환
	if (m < 10) {
		strM = "0" + strM;
	}

	// 1 ~ 9일일 경우 01 ~ 09월일로 표기하기 위한 변수 strD
	String strD = d + "";
	if (d < 10) {
		strD = "0" + strD;
	}
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	String sql = "SELECT schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate, updatedate FROM schedule WHERE schedule_date=? ORDER BY schedule_time ASC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, y + "-" + strM + "-" + strD);
	System.out.println(stmt + " <-- stmt(scheduleListByDate)");
	
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + " <-- rs(scheduleListByDate)");
	
	// 자료구조 ResultSet 타입을 일반적인 자료구조 타입으로 변환
	// ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>(); // Schedule 클래스 사용
	while (rs.next()) { // 커서가 내려가는 동안 밖에서 만들어진 scheduleList에 값 저장
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate");
		s.scheduleTime= rs.getString("scheduleTime");
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		scheduleList.add(s);
	}
	
	System.out.println("==========================schduleListByDate==========================");
%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>scheduleListByDate</title>
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
			<h1>일정 입력</h1>
		</div>
		<form action="<%=request.getContextPath()%>/schedule/insertScheduleAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="text-bg-dark text-center">일정 날짜</th>
					<td><input type="date" name="scheduleDate" value="<%=y%>-<%=strM%>-<%=strD%>" readonly="readonly" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">일정 시간</th>
					<td><input type="time" name="scheduleTime" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">폰트 색상</th>
					<td><input type="color" name="scheduleColor" value="#000000" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">메모</th>
					<td><textarea cols="80" rows="3" name="scheduleMemo" class="form-control w-75"></textarea></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">비밀번호</th>
					<td><input type="password" name="schedulePw" class="form-control w-25"></td>
				</tr>
			</table>
			<button type="submit" class="btn btn-dark">입력</button>
		</form>
		
		<div class="text-center">
			<h1><%=y%>년 <%=m%>월 <%=d%>일 일정 목록</h1>
		</div>
		<%
			if (request.getParameter("msg") != null) {
		%>	
				<%=request.getParameter("msg")%>
		<%
			}
		%>
		<table class="table table-bordered">
			<tr>
				<th class="text-bg-dark text-center">일정 시간</th>
				<th class="text-bg-dark text-center">메모</th>
				<th class="text-bg-dark text-center">작성일자</th>
				<th class="text-bg-dark text-center">수정일자</th>
				<th class="text-bg-dark text-center">수정</th>
				<th class="text-bg-dark text-center">삭제</th>
			</tr>
		<%
			for (Schedule s : scheduleList) { // scheduleList 만큼 반복
		%>
				<tr class="text-center">
					<td><%=s.scheduleTime%></td>
					<td><%=s.scheduleMemo%></td>
					<td><%=s.createdate%></td>
					<td><%=s.updatedate%></td>
					<td>
						<a href="<%=request.getContextPath()%>/schedule/updateSchedule.jsp?scheduleNo=<%=s.scheduleNo%>" class="btn btn-dark">수정</a>
					</td>
					<td>
						<a href="<%=request.getContextPath()%>/schedule/deleteSchedule.jsp?scheduleNo=<%=s.scheduleNo%>" class="btn btn-dark">삭제</a>
					</td>
				</tr>
		<%
			}
		%>
		</table>
		</div>
	</body>
</html>