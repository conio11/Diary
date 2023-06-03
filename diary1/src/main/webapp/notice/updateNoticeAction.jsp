<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%
	// post 방식 인코딩 설정
	request.setCharacterEncoding("UTF-8");

	// 4개의 값을 확인(디버깅)
	System.out.println(request.getParameter("noticeNo") + " <-- noticeNo(updateNoticeAction)");
 	System.out.println(request.getParameter("noticeTitle") + " <-- updateNoticeAction2.jsp param noticeTitle(updateNoticeAction)");
 	System.out.println(request.getParameter("noticeContent") + " <-- updateNoticeAction2.jsp param noticeContent(updateNoticeAction)");
 	System.out.println(request.getParameter("noticePw") + " <-- updateNoticeAction2.jsp param noticePw(updateNoticeAction)");

	// 유효성 검사 - noticeNo가 null이면 noticeList.jsp로 이동
	if (request.getParameter("noticeNo") == null) {
		response.sendRedirect(request.getContextPath() + "/notice/noticeList.jsp");
		return;
	}
	
	// 제목, 내용, 비밀번호 중 입력되지 않은 항목이 있을 경우 출력할 메시지 설정
	String msg = null;
	if (request.getParameter("noticeTitle") == null
	|| request.getParameter("noticeTitle").equals("")) {
		msg = "noticeTitle is required.";
	} else if (request.getParameter("noticeContent") == null 
	|| request.getParameter("noticeContent").equals("")) {
		msg = "noticeContent is required.";
	} else if (request.getParameter("noticePw") == null 
	|| request.getParameter("noticePw").equals("")) {
		msg = "noticePw is required";
	}
	
	// 위 if-else 문에 하나라도 해당될 경우 메시지와 함께 updateNotice.jsp로 이동
	if (msg != null) {
		response.sendRedirect(request.getContextPath() + "/notice/updateNotice.jsp?noticeNo=" + request.getParameter("noticeNo") + "&msg=" + msg);
		return;
	}
	
	// 요청값 변수에 할당
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticePw = request.getParameter("noticePw");
	
	// 디버깅
	System.out.println(noticeNo + " <-- noticeNo(updateNoticeAction)");
	System.out.println(noticeTitle + " <-- noticeTitle(updateNoticeAction)");
	System.out.println(noticeContent + " <-- noticeContent(updateNoticeAction)");
	System.out.println(noticePw + " <-- noticePw(updateNoticeAction)");
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	// SQL 구문 작성 및 변환
	String sql = "UPDATE notice SET notice_title=?, notice_content=?, updatedate=now() WHERE notice_no=? AND notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setInt(3, noticeNo);
	stmt.setString(4, noticePw);
	System.out.println(stmt + " <-- stmt(updateNoticeAction)");
	
	int row = stmt.executeUpdate();
	if (row == 0) { // 0일 경우 수정 실패 -> 비밀번호가 틀림
		System.out.println("수정 실패");
		response.sendRedirect(request.getContextPath() + "/notice/updateNotice.jsp?noticeNo=" + noticeNo + "&msg=incorrect noticePw");
	} else if (row == 1) {
		System.out.println("수정 성공");
		response.sendRedirect(request.getContextPath() + "/notice/noticeOne.jsp?noticeNo=" + noticeNo);
		
	} else {
		System.out.println("error row값:(updateNoticeAction)" + row);
	}
	
	System.out.println("==========================updateNoticeAction==========================");
%>