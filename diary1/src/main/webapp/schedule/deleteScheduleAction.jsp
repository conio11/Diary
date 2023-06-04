<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
	// 인코딩 설정
	request.setCharacterEncoding("UTF-8");
	
	// 번호, 비밀번호 중 null값 or 공백값 있을 경우 초기 화면으로 리다이렉트
	if (request.getParameter("scheduleNo") == null
	|| request.getParameter("schedulePw") == null
	|| request.getParameter("scheduleNo").equals("")
	|| request.getParameter("schedulePw").equals("")) {
		response.sendRedirect(request.getContextPath() + "/schedule/scheduleList.jsp");
		return; // 실행 종료
	}
	
	// 요청값 
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	
	// 디버깅
	System.out.println(scheduleNo + " <-- scheduleNo(deleteScheduleAction)");
	System.out.println(schedulePw + " <-- schedulePw(deleteScheduleAction)");
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	String sql = "DELETE FROM schedule WHERE schedule_no=? AND schedule_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);

	// ? 2개 (1 ~ 2)
	stmt.setInt(1, scheduleNo);
	stmt.setString(2, schedulePw);
	
	int row = stmt.executeUpdate(); // 0이면 입력 실패, 1이면 입력 성공
	System.out.println(row + " <-- row(deleteScheduleAction)");
	
	String msg = "";
	if (row == 1) {
		System.out.println("삭제 성공");
		msg = "delete completed";
	} else {
		System.out.println("삭제 실패");
		msg = "delete failed";
	}

	response.sendRedirect(request.getContextPath() + "/schedule/scheduleList.jsp?msg=" + msg); // 삭제 작업 후 해당 페이지로 리다이렉트

	System.out.println("==========================deleteScheduleAction==========================");
%>