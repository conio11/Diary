<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>   

<%
	// 공지 상세 페이지 출력 코드
	
	// 넘어온 noticeNo 정보가 없을 경우 home.jsp로 이동
	if (request.getParameter("noticeNo") == null) {
		response.sendRedirect(request.getContextPath() + "/home.jsp");
		return; // 실행 종료
	}

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println(noticeNo + " <-- noticeNo(noticeOne)");
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate FROM notice WHERE notice_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	System.out.println(stmt + " <-- stmt");
	ResultSet rs = stmt.executeQuery();
	
	// 모델 데이터
	// rs를 사용하는 것은 모델 데이터 생성까지
	// Notice notice = new Notice(); // 사용 가능하나 초기값 설정되기 때문에 오류검사와 맞지 않을 가능성
	Notice notice = null;
	if (rs.next()) {
		notice = new Notice();
		notice.noticeNo = rs.getInt("noticeNo");
		notice.noticeTitle = rs.getString("noticeTitle");
		notice.noticeContent = rs.getString("noticeContent");
		notice.noticeWriter = rs.getString("noticeWriter");
		notice.createdate = rs.getString("createdate");
		notice.updatedate = rs.getString("updatedate");
	}

	System.out.println("==========================noticeOne==========================");
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>noticeOne</title>
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
			<h1>공지 상세</h1>
		</div>
		
		<table class="table table-bordered">
			<tr>
				<th class="text-bg-dark text-center">공지 번호</th>
				<td><%=notice.noticeNo%></td>
			</tr>
			<tr>
				<th class="text-bg-dark text-center">공지 제목</th>
				<td><%=notice.noticeTitle%></td>
			</tr>
			<tr>
				<th class="text-bg-dark text-center">내용</th>
				<td><%=notice.noticeContent%></td>
			</tr>
			<tr>
				<th class="text-bg-dark text-center">작성자</th>
				<td><%=notice.noticeWriter%></td>
			</tr>
			<tr>
				<th class="text-bg-dark text-center">작성일자</th>
				<td><%=notice.createdate.substring(0, 10)%></td>
			</tr>
			<tr>
				<th class="text-bg-dark text-center">수정일자</th>
				<td><%=notice.updatedate.substring(0, 10)%></td>
			</tr>
		</table>
		<div>
			<a href="<%=request.getContextPath()%>/notice/updateNotice.jsp?noticeNo=<%=noticeNo%>" class="btn btn-dark">수정</a>
			<a href="<%=request.getContextPath()%>/notice/deleteNotice.jsp?noticeNo=<%=noticeNo%>" class="btn btn-dark">삭제</a>
		</div>
		
		</div>
	</body>
</html>