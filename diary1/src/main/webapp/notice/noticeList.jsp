<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%> 

<%
	// 전체 데이터(공지사항) 10개씩 출력
	
	// 현재 페이지
	int currentPage = 1;
	if (request.getParameter("currentPage") != null
	&& !request.getParameter("currentPage").equals("")) { // 현재 페이지가 null값이 아니면서 공백값도 아닌 경우
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	// 디버깅
	System.out.println(currentPage + " <-- currentPage(noticeList)");

	// 페이지 당 출력할 행의 수
	int rowPerPage = 10;
	
	// 시작 행 번호 (LIMIT a, b)의 a -> 0, 10, 20, ...
	int startRow = (currentPage - 1) * rowPerPage;
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	String sql = "SELECT notice_no noticeNo, notice_title noticeTitle, createdate FROM notice ORDER BY createdate DESC LIMIT ?, ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, startRow);
	stmt.setInt(2, rowPerPage);
	System.out.println(stmt + " <-- stmt(noticeList)");
	ResultSet rs = stmt.executeQuery();
	
	// 자료구조 ResultSet 타입을 일반적인 자료구조 타입(자바 배열 or 기본 API 타입 - List, Set, Map)으로 변경
	// ResultSet(List가 아닌 Set) -> ArrayList<Notice>
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while (rs.next()) { // 커서가 내려가는 동안 밖에서 만들어진 noticeList에 값 저장(10개)
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n);
	}
	
	// 마지막 페이지
	// 쿼리문을 사용하기 위해 sql2, stmt2 변수 생성
	String sql2 = "SELECT COUNT(*) FROM notice";
	PreparedStatement stmt2 = conn.prepareStatement(sql2); 
	ResultSet rs2 = stmt2.executeQuery();
	int totalRow = 0;
	if (rs2.next()) {
		totalRow = rs2.getInt("COUNT(*)");
	}
	int lastPage = totalRow / rowPerPage;
	if (totalRow % rowPerPage != 0) {
		lastPage = lastPage + 1;
	}
	
	// 디버깅
	System.out.println(totalRow + " <-- totalRow(noticeList)");
	System.out.println(lastPage + " <-- lastPage(noticeList)");
	
	System.out.println("==========================noticeList==========================");
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>noticeList</title>
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
			<h1>공지사항 목록</h1>
		</div>
		<a href="<%=request.getContextPath()%>/notice/insertNotice.jsp" class="btn btn-dark">공지 입력</a>
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
						<a href="<%=request.getContextPath()%>/notice/noticeOne.jsp?noticeNo=<%=n.noticeNo%>" class="btn"><%=n.noticeTitle%></a>
					</td>
					<td><%=n.createdate.substring(0, 10)%></td>
				</tr>
		<%
			}		
		%>
		</table>
			<div class="text-center">
		<%
			if (currentPage > 1) { // 현재 페이지가 1보다 클 때(2페이지부터) 이전 버튼 생성
		%>
				<a href="<%=request.getContextPath()%>/notice/noticeList.jsp?currentPage=<%=currentPage - 1%>" class="btn btn-outline-dark">이전</a>
		<%
			}
		%>
				현재 페이지: <%=currentPage%>
		<%
			if (currentPage < lastPage) { // 현재 페이지가 마지막 페이지보다 작을 때 다음 버튼 생성 (마지막 페이지에는 다음 버튼 X)
		%>
				<a href="<%=request.getContextPath()%>/notice/noticeList.jsp?currentPage=<%=currentPage + 1%>" class="btn btn-outline-dark">다음</a>
		<%
			}
		%>
			</div>
		</div>
	</body>
</html>