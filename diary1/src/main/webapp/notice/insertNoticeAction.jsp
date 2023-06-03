<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
	// MVC 형태로 작성
	
	// validation (요청 파라미터값 유효성 검사)
	
	// post 방식 인코딩 처리
	request.setCharacterEncoding("UTF-8"); 

	// 한 개의 값이라도 공백이거나 null이 입력되면 매시지와 함께 insertNotice.jsp로 이동
	String msg = null;
	if (request.getParameter("noticeTitle") == null
	|| request.getParameter("noticeContent") == null
	|| request.getParameter("noticeWriter") == null 
	|| request.getParameter("noticePw") == null 
	|| request.getParameter("noticeTitle").equals("")
	|| request.getParameter("noticeContent").equals("")
	|| request.getParameter("noticeWriter").equals("")
	|| request.getParameter("noticePw").equals("")) {
		msg = "All values are required";
		response.sendRedirect(request.getContextPath() + "/notice/insertNotice.jsp?msg=" + msg);
		return; // 실행 종료
	}
	
	// 입력값 설정 및 디버깅
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");
	
	System.out.println(noticeTitle + " <-- noticeTitle(insertNoticeAction)");
	System.out.println(noticeContent + " <-- noticeContent(insertNoticeAction)");
	System.out.println(noticeWriter + " <-- noticeWriter(insertNoticeAction)");
	System.out.println(noticePw + " <-- noticePw(insertNoticeAction)");
	
	// 입력된 값들을 DB 테이블에 입력
	/*
	    insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate)
	    values(?, ?, ?, ?, now(), now()) // ? 는 값(values)에 대해서만 사용 가능
	*/
			
	// 드라이버 설정
	Class.forName("org.mariadb.jdbc.Driver");
	// db, 로그인 정보 입력
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");

	String sql = "INSERT INTO notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) VALUES(?, ?, ?, ?, NOW(), NOW())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ? 4개 (1 ~ 4)
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
	int row = stmt.executeUpdate(); // 0이면 입력된 행 X, 1이면 성공
	System.out.println(row + " <-- row(insertNoticeAction)"); // row 값을 이용한 디버깅 코드
			
	conn.setAutoCommit(true); // 디폴트 값이 true이므로 executeUpdate(); 후 커밋 자동실행 
	// conn.commit(); // 커밋 자동실행 설정되어 있으므로 생략 가능
	
	response.sendRedirect(request.getContextPath() + "/notice/noticeList.jsp"); // 데이터 입력 후 noticeList.jsp로 이동
	
	System.out.println("==========================insertNoticeAction==========================");
%>