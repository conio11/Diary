<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>

<%
	// 유효성 코드 추가 -> 분기 -> response.sendRedirect(); return;

	// 요청값 없을 시 noticeList.jsp로 이동
	if (request.getParameter("noticeNo") == null) {
		response.sendRedirect(request.getContextPath() + "/notice/noticeList.jsp"); 
		return; // 코드 진행 종료
	}
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println(noticeNo + " <-- noticeNo(updateNotice)");
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate FROM notice WHERE notice_no=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	System.out.println(stmt + " <-- stmt(updateNotice)");
	
	// stmt를 ResultSet 타입으로 변환
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + " <-- rs(updateNotice)");
	
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
	
	System.out.println("==========================updateNotice==========================");
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>updateNotice</title>
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
			<h1>공지 수정</h1>
		</div>
		
		<!-- action에서 받아온 msg 값이 null이 아닐 경우 (오류가 있을 경우) 출력  -->
		<div class="text-danger">
			<%
				if (request.getParameter("msg") != null) {
			%>
					<%=request.getParameter("msg")%>
			<%
				}
			%>
		</div>
		<a href="<%=request.getContextPath()%>/notice/noticeOne.jsp?noticeNo=<%=noticeNo%>" class="btn btn-outline-dark">뒤로 가기</a>
		<br>
		
		<form action="<%=request.getContextPath()%>/notice/updateNoticeAction.jsp" method="post">
			<table class="table table-bordered">
				<tr>
					<th class="text-bg-dark text-center">공지 번호</th>
					<td><input type="number" name="noticeNo" value="<%=notice.noticeNo%>" readonly="readonly" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">비밀번호</th>
					<td><input type="password" name="noticePw" class="form-control w-25"></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">공지 제목</th>
					<td><input type="text" name="noticeTitle" value="<%=notice.noticeTitle%>" class="form-control w-75"></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">내용</th>
					<td><textarea rows="5" cols="80" name="noticeContent" class="form-control w-75"><%=notice.noticeContent%></textarea></td>
				</tr>
				<tr>
					<th class="text-bg-dark text-center">작성자</th>
					<td><%=notice.noticeWriter%></td> <!-- 넘길 값 없으므로 값만 출력해도 됨 -->
				</tr>
				<tr>
					<th class="text-bg-dark text-center">작성일자</th>
					<td><%=notice.createdate.substring(0, 10)%></td> <!-- 넘길 값 없으므로 값만 출력해도 됨 -->
				</tr>
				<tr>
					<th class="text-bg-dark text-center">수정일자</th>
					<td><%=notice.updatedate.substring(0, 10)%></td> <!-- 넘길 값 없으므로 값만 출력해도 됨 -->
				</tr>
			</table>
			<button type="submit" class="btn btn-dark">수정</button>
		</form>
		</div>
	</body>
</html>