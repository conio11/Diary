<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
	// 인코딩 처리
	request.setCharacterEncoding("UTF-8");

	// 유효성 검사
	// no, pw, date, time, color, memo 에 null값 또는 공백이면 초기 화면으로 리다이렉트
	if (request.getParameter("scheduleNo") == null
	|| request.getParameter("schedulePw") == null
	|| request.getParameter("scheduleDate") == null
	|| request.getParameter("scheduleTime") == null
	|| request.getParameter("scheduleColor") == null
	|| request.getParameter("scheduleMemo") == null
	|| request.getParameter("scheduleNo").equals("")
	|| request.getParameter("schedulePw").equals("")
	|| request.getParameter("scheduleDate").equals("")
	|| request.getParameter("scheduleTime").equals("")
	|| request.getParameter("scheduleColor").equals("")
	|| request.getParameter("scheduleMemo").equals("")) {
		response.sendRedirect(request.getContextPath() + "/schedule/scheduleList.jsp");
		return; // 실행 종료
	} 
	
	// 요청값
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	
	// sehedule 테이블의 열 번호, 비밀번호, 날짜, 시간, 색, 메모 확인하는 디버깅 코드
	System.out.println(scheduleNo + " <-- scheduleNo(updateScheduleAction)");
	System.out.println(schedulePw + " <-- schedulePw(updateScheduleAction)");
	System.out.println(scheduleDate + " <-- scheduleDate(updateScheduleAction)");
	System.out.println(scheduleTime + " <-- scheduleTime(updateScheduleAction)");
	System.out.println(scheduleColor + " <-- scheduleColor(updateScheduleAction)");
	System.out.println(scheduleMemo + " <-- scheduleMemo(updateScheduleAction)");
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	String sql = "UPDATE schedule SET schedule_date=?, schedule_time=?, schedule_color=?, schedule_memo=? WHERE schedule_no=? AND schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);

	// ? 6개 (1, 6)
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleColor);
	stmt.setString(4, scheduleMemo);
	stmt.setInt(5, scheduleNo);
	stmt.setString(6, schedulePw);
	System.out.println(stmt + " <-- stmt(updateScheduleAction)");
	
	int row = stmt.executeUpdate(); // 0이면 입력 실패, 1이면 입력 성공
	System.out.println(row + " <-- row(updateScheduleAction)");
	
	// 수정 성공 후 확인 페이지로 가기 위해 Date(날짜) 값 슬라이스
	String y = scheduleDate.substring(0,4);
	int m = Integer.parseInt(scheduleDate.substring(5,7)) - 1 ;
	String d = scheduleDate.substring(8);
	
	System.out.println(y + " <-- y(updateScheduleAction)");
	System.out.println(m + " <-- m(updateScheduleAction)");
	System.out.println(d + " <-- d(updateScheduleAction)");	
	
	String msg = "";
	if (row == 1) {
		// 수정 성공 시 상세 화면으로 이동
		System.out.println("수정 성공");
		msg = "update completed";
		response.sendRedirect(request.getContextPath() + "/schedule/scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d + "&msg=" + msg);
		
	} else {
		// 수정 실패 시 다시 입력폼
		System.out.println("수정 실패");
		msg = "update failed";
		response.sendRedirect("./updateSchedule.jsp?scheduleNo=" + scheduleNo + "&msg=" + msg);
	}
	
	System.out.println("==========================updateScheduleAction==========================");
%>