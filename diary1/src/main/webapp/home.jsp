<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>

<%
	// 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩 성공(home)");
	
	// MariaDB 로그인 후 접속정보 반환
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	System.out.println("DB 접속 성공(home)");
	
	// 최근 공지사항 5개 출력
	String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, createdate FROM notice ORDER BY createdate DESC limit 0, 5";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println(stmt + " <--stmt(home)");
	ResultSet rs = stmt.executeQuery();
	
	// 자료구조 ResultSet 타입을 일반적인 자료구조 타입으로 변경
	// ResultSet -> ArrayList<Notice>
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while (rs.next()) { // 커서가 내려가는 동안 밖에서 만들어진 noticeList에 값 저장 -> 5개
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n); // 리스트에 값 저장
	}
	
	// 오늘 일정
	String sql2 = "SELECT schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo, 1, 10) scheduleMemo FROM schedule WHERE schedule_date = curdate() ORDER BY schedule_time ASC";
	PreparedStatement stmt2 = conn.prepareStatement(sql2);
	System.out.println(stmt2 + " <-- stmt2(home)");
	ResultSet rs2 = stmt2.executeQuery();
	
	// 자료구조 ResultSet 타입을 일반적인 자료구조 타입으로 변환
	// ResultSet -> ArrayList<Schedule>
	
	// ArrayList의 각 배열값에 Schedule 클래스 객체 대입
	// 동일한 컬럼값을 가진 여러 행이 필요하기 때문에 ArrayList<> 사용
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>(); 
	while (rs2.next()) { // 커서가 내려가는 동안 밖에서 만들어진 scheduleList에 값 저장 -> 오늘 날짜에 해당되는 값만큼 저장
		Schedule s = new Schedule();
		s.scheduleNo = rs2.getInt("scheduleNo");
		s.scheduleDate = rs2.getString("scheduleDate");
		s.scheduleTime = rs2.getString("scheduleTime");
		s.scheduleMemo = rs2.getString("scheduleMemo");
		scheduleList.add(s); // s값(한 행)을 scheduleList에 저장
	}

	System.out.println("==========================home==========================");
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>home</title>
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
		
		<!-- 최근 공지사항 5개 출력  -->
		
		<div class="text-center">
			<h1>공지사항</h1>
		</div>
		<table class="table table-bordered text-center">
			<tr>
				<th class="text-bg-dark">공지 제목</th>
				<th class="text-bg-dark">작성일자</th>
			</tr>
			
		<%
			for (Notice n : noticeList) {
		%>
				<tr>
					<td>
						<a href="<%=request.getContextPath()%>/notice/noticeOne.jsp?noticeNo=<%=n.noticeNo%>" class="btn">
							<%=n.noticeTitle%>
						</a>
					</td>
					<td><%=n.createdate.substring(0, 10)%></td>
				</tr>
		<%
			}
		%>
		</table>
		<br>
		
		<!-- 오늘 일정 전체 출력 -->
		<div class="text-center">
			<h1>오늘 일정</h1>
		</div>
		<table class="table table-bordered text-center">
			<tr>
				<th class="text-bg-dark">오늘 날짜</th>
				<th class="text-bg-dark">일정 시간</th>
				<th class="text-bg-dark">메모</th>
			</tr>
		<%
			for (Schedule s : scheduleList) {
		%>
				<tr>
					<td><%=s.scheduleDate%></td>
					<td><%=s.scheduleTime%></td>
					<td><%=s.scheduleMemo%></td>
				</tr>
		<%
			}
		%>
		</table>
	
		</div>
	</body>
</html>