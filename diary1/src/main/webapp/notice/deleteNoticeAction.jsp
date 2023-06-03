<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
	// post 방식 인코딩 설정
	request.setCharacterEncoding("UTF-8");

	// 넘어온 noticePw값 확인
	System.out.println(request.getParameter("noticePw") + " <-- noticePw(deleteNoticeAction)");
	
	// 유효성 검사 - noticeNo가 null이면 noticeList.jsp로 이동
	if (request.getParameter("noticeNo") == null) {
		response.sendRedirect(request.getContextPath() + "/notice/noticeList.jsp");
		return;
	}
	
	// 비밀번호가 입력되지 않았을 경우 출력할 메시지 설정
	String msg = null;
	if (request.getParameter("noticePw") == null
	|| request.getParameter("noticePw").equals("")) {
		msg = "noticePw is required";
	}
	
	// 위 if문에 해당할 경우 메시지와 함께 deleteNotice.jsp로 이동
	if (msg != null) {
		response.sendRedirect(request.getContextPath() + "/notice/deleteNotice.jsp?noticeNo=" + request.getParameter("noticeNo") + "&msg=" + msg);
		return;
	}
	
	// 요청값 변수에 할당
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	
	// 디버깅
	System.out.println(noticeNo + " <-- noticeNo(deleteNoticeAction)");
	System.out.println(noticePw + " <-- noticePw(deleteNoticeAction)");
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	String sql = "DELETE FROM notice WHERE notice_no=? AND notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	
	// ? 2개 (1, 2)
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	System.out.println(stmt + " <-- stmt(deleteNoticeAction)"); // 쿼리 출력
	
	int row = stmt.executeUpdate(); // 완료된 행 수 
	System.out.println(row + " <-- row(deleteNoticeAction)");
	
	if (row == 1) { // 삭제 성공 시 noticeList.jsp로 이동
		System.out.println("삭제 성공");
		response.sendRedirect(request.getContextPath() + "/notice/noticeList.jsp");
	} else { // 삭제 실패 시 메시지와 함께 입력폼으로 리다이렉트
		System.out.println("삭제 실패");
		msg = "incorrect noticePw";
		response.sendRedirect(request.getContextPath() + "/notice/deleteNotice.jsp?noticeNo=" + noticeNo + "&msg=" + msg);
	}

	System.out.println("==========================deleteNoticeAction==========================");
%>