<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
	// post 방식 인코딩
	request.setCharacterEncoding("UTF-8");

	// 한 개의 값이라도 공백이거나 null일 경우 scheduleListByDate.jsp로 이동 
	if (request.getParameter("scheduleDate") == null
	|| request.getParameter("scheduleTime") == null
	|| request.getParameter("scheduleColor") == null
	|| request.getParameter("scheduleMemo") == null
	|| request.getParameter("schedulePw") == null
	|| request.getParameter("scheduleDate").equals("")
	|| request.getParameter("scheduleTime").equals("")
	|| request.getParameter("scheduleColor").equals("")
	|| request.getParameter("scheduleMemo").equals("")
	|| request.getParameter("schedulePw").equals("")) {
		response.sendRedirect(request.getContextPath() + "/schedule/scheduleListByDate.jsp"); 
		return; // 실행 종료
	}
	
	// 요청값
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	
	// 디버깅
	System.out.println(scheduleDate + " <-- scheduleDate(insertScheduleAction)");
	System.out.println(scheduleTime + " <-- scheduleTime(insertScheduleAction)");
	System.out.println(scheduleColor + " <-- scheduleColor(insertScheduleAction)");
	System.out.println(scheduleMemo + " <-- scheduleMemo(insertScheduleAction)");
	System.out.println(schedulePw + " <-- schedulePw(insertScheduleAction)");
	
	// 날짜의 연도, 월, 일
	String y = scheduleDate.substring(0, 4); // 0 ~ 3번째 인덱스값 출력
	int m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1; // 5, 6번째 인덱스값 - 1 // Java API로 돌아가야 하므로 더해졌던 1 다시 마이너스
	String d = scheduleDate.substring(8); // 8번째부터 마지막 인덱스값까지 출력
	
	// 디버깅
	System.out.println(y + " <-- y(insertScheduleAction)");
	System.out.println(m + " <-- m(insertScheduleAction)");
	System.out.println(d + " <-- d(insertScheduleAction)");
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	String sql = "INSERT INTO schedule(schedule_date, schedule_time, schedule_color, schedule_memo, schedule_pw, createdate, updatedate) VALUES(?, ?, ?, ?, ?, NOW(), NOW())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// ? 5개(1 ~ 5)
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, scheduleMemo);
	stmt.setString(5, schedulePw);
	
	System.out.println(stmt + " <-- stmt(insertScheduleAction)");
	
	int row = stmt.executeUpdate(); // 0이면 입력 실패, 1이면 입력 성공
	System.out.println(row + " <-- row(insertScheduleAction)");
	
	String msg = "";
	if (row == 1) {
		System.out.println("입력 성공");
		msg = "insert completed";
	} else {
		System.out.println("입력 실패");
		msg = "insert failed";
	}
	
	conn.setAutoCommit(true); // 디폴트 값이 true이므로 executeUpdate(); 후 커밋 자동실행 
	
	response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d + "&msg=" + msg); // 데이터 입력 후 페이지 이동
	
	System.out.println("==========================insertScheduleAction==========================");
%>