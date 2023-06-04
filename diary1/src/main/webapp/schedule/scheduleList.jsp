<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="vo.*"%>

<% 
	request.setCharacterEncoding("UTF-8");	

	int targetYear = 0;
	int targetMonth = 0; // 0 ~ 11 값으로 들어옴 // 출력 단계에서 값 변경

	// 연도 또는 월 요청값이 넘어오지 않으면 오늘 날짜의 연도, 월 사용 (링크 클릭 시 값 입력)
	// 최초 실행 시 값 없으므로 오늘 날짜로 진행
	if (request.getParameter("targetYear") == null
	|| request.getParameter("targetMonth") == null) {
		Calendar c = Calendar.getInstance();
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH);
	} else { // 넘어온 request 값 사용
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	
	// 디버깅
	System.out.println(targetYear + " <-- targetYear(schduleList)");
	System.out.println(targetMonth + " <-- targetMonth(schduleList)");
	System.out.println(targetMonth + 1 + "월 <-- targetMonthReal(schduleList)");
	
	// 오늘 날짜
	Calendar today = Calendar.getInstance(); // today - 오늘 날짜 정보 
	int todayDate = today.get(Calendar.DATE);
	
	// targetMonth의 1일의 요일을 구하기 위한 준비
	Calendar firstDay = Calendar.getInstance(); // firstDay - 시스템 상 오늘 날짜 정보
	firstDay.set(Calendar.YEAR, targetYear); // firstDay의 연도 -> targetYear
	firstDay.set(Calendar.MONTH, targetMonth); // firstDay의 월 -> targetMonth // Calendar API에서 -1, 12값 들어올 시 이전 연도 12월, 다음 연도 1월로 자동 변경
	firstDay.set(Calendar.DATE, 1); // firstDay의 일 -> 1일로 설정
	
	// targetYear, targtMonth를 API 내부 값으로 다시 받아옴
	// 연: 23 월: 12 -> Calendar API에서 24년 1월로 변경
	// 연: 23 월: 1 ->  Calendar API에서 22년 12월로 변경
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	System.out.println(targetYear + " <-- API 실행 후 targetYear(scheduleList)");
	System.out.println(targetMonth + " <-- API 실행 후 targetMonth(scheduleList)");
	 
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); // 1일의 요일 -> 일요일 1, 월요일 2, ...  토요일 7
	
	// 1일 앞의 공백칸 수
	// 1일이 일요일(1) 이면 공백칸 0, 월요일(2)이면 공백칸 1, ... 토요일(7)이면 공백칸 6
	int startBlank = firstYoil - 1;
	System.out.println(startBlank + " <--startBlank(scheduleList)");
	
	// targetMonth의 마지막 일
	int lastDate = firstDay.getActualMaximum(Calendar.DATE); // firstDay의 월의 날짜 중 가장 큰 값 (마지막 일) 반환
	System.out.println(lastDate + " <-- lastDate(scheduleList)");
	
	// lastDate 날짜 뒤 공백칸 수
	// 1일 이전 공백 + 해당 월의 마지막 날짜
	int endBlank = 0;	
	int totalTd = 0;
	if ((startBlank + lastDate) % 7 != 0) { // 1일 이전 공백칸과 해당 월의 마지막 날짜까지 더한 값이 7로 나누어 떨어지지 않을 때
		endBlank = 7 - ((startBlank + lastDate) % 7);
	}
	System.out.println(endBlank + " < -- endBlank(scheduleList)");
	
	// 이전 달 연도, 월
	int preTargetYear = targetYear;
	int preTargetMonth = targetMonth - 1;
	
	Calendar preMonth = Calendar.getInstance(); // preMonth - 오늘 날짜 정보
	preMonth.set(Calendar.YEAR, preTargetYear); // preMonth의 연도 변경
	preMonth.set(Calendar.MONTH, preTargetMonth); // preMonth의 월 변경
	int preLastDate = preMonth.getActualMaximum(Calendar.DATE); // 이전 달의 마지막 날짜
	
	// 전체 td 개수
	totalTd = startBlank + lastDate + endBlank;
	System.out.println(totalTd + " <-- totalTd(scheduleList)");
	
	// 이전 달 날짜 -> dateNum + preLastDate // dateNum -> 0 이하
	// 다음 달 날짜 -> dateNum - lastDate // dateNum -> 30 ~ 31 이상
	
	// DB data를 가져오는 알고리즘
	// YEAR() MONTH() DAY()
	// SUBSTR(1, 5) : 1 ~ 5번째 문자열 (인덱스 주의)
	// select schedule_no scheduleNo, substr(schedule_memo, 1, 5) scheduleMemo
	// from schedule where year(schedule_date)=? and month(schedule_date)=?
	// order by month(schedule_date) asc;
	
	// DB 연결
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	String sql = "SELECT schedule_no scheduleNo, DAY(schedule_date) scheduleDate, SUBSTR(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor FROM schedule WHERE YEAR(schedule_date)=? AND MONTH(schedule_date)=? ORDER BY MONTH(schedule_date) ASC";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth + 1); // targetMonth + 1: (mariadb 들어갈 때 1 ~ 12로 표현)
	System.out.println(stmt + " <-- stmt(scheduleList)");
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + " <-- rs(scheduleList)");
	
	// ResultSet -> ArrayList<Schedule>
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while (rs.next()) { // rs 개수만큼 스케줄 생성, 행의 모든 정보 저장 가능, s는 while문 안에서 사라짐 -> 바깥 ArrayList에 저장
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); // 실제 데이터: 날짜(day)값만 해당
		s.scheduleMemo = rs.getString("scheduleMemo"); // 실제 데이터: memo의 1 ~ 5번째 문자열만 출력
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}	
	
	System.out.println("==========================schduleList==========================");
%>

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>scheduleList</title>
		<meta name="viewport" content="width=device-width, initial-scale=1">
 		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
  		<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- 		<style>	
			/* 링크 요소를 화면 우측에 출력하는 클래스 */
			.link-element {
			  position: absolute;
			  top: -50;
			  right: 0;
			}
		</style> -->
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
			<h1><%=targetYear%>년 <%=targetMonth + 1%>월</h1>
		</div>
		<%
			if (request.getParameter("msg") != null) {
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
		<div>
			<a href="<%=request.getContextPath()%>/schedule/scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth - 1%>" class="btn btn-dark">이전 달</a>
			<a href="<%=request.getContextPath()%>/schedule/scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth + 1%>" class="float-end btn btn-dark">다음 달</a>
		</div>
		<table class="table table-bordered">
			<tr>
				<th class="text-bg-dark text-center">일</th>
				<th class="text-bg-dark text-center">월</th>
				<th class="text-bg-dark text-center">화</th>
				<th class="text-bg-dark text-center">수</th>
				<th class="text-bg-dark text-center">목</th>
				<th class="text-bg-dark text-center">금</th>
				<th class="text-bg-dark text-center">토</th>
			</tr>
			<tr>
		<%
			// 전체 칸 수만큼 반복
			for (int i = 0; i < totalTd; i++) {
				if (i != 0 && i % 7 == 0) { // i가 0이어도 i % 7 == 0이므로 i != 0 // 일 ~ 토 7칸마다 줄바꿈
		%>				
			 		</tr><tr>
		<%
				}
				String tdStyle = ""; // <td> 속성에 적용할 스타일 속성
				int dateNum = i - startBlank + 1; // 해당 날짜를 표현하는 변수 -> 마지막 startBlank의 바로 다음 칸의 날짜가 1로 시작해야 하므로 1을 더함
				
				if (dateNum > 0 && dateNum <= lastDate) { // 해당 월에 해당하는 날짜일 때
					if (today.get(Calendar.YEAR) == targetYear // 오늘 날짜이면 배경색 변경 + 일정 있을 경우 출력
					&& today.get(Calendar.MONTH) == targetMonth
					&& today.get(Calendar.DATE) == dateNum) {
						tdStyle = "background-color: orange";			
		%>				
						<td style="<%=tdStyle%>">
							<div> <!-- 날짜 숫자  -->
								<a href="<%=request.getContextPath()%>/schedule/scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=dateNum%>">
										<%=dateNum%>
								</a>
							</div>
							<div> <!--일정 memo(5글자) -->
								<%
									for (Schedule s : scheduleList) {
										if (dateNum == Integer.parseInt(s.scheduleDate)) { // 해당하는 날짜에 일정이 있다면 설정된 색상으로 5글자만 출력
								%>
											<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
								<%
										}
									}
								%>
							</div>
						</td>
		<%
					} else { // 오늘 날짜가 아닌 경우 + 일정 있을 경우 출력
		%>
						<td>
							<div> <!-- 날짜 숫자  -->
								<a href="<%=request.getContextPath()%>/schedule/scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=dateNum%>" class="btn">
									<%=dateNum%>
								</a>
							</div>
							<div> <!--일정 memo(5글자) -->
								<%
									for (Schedule s : scheduleList) {
										if (dateNum == Integer.parseInt(s.scheduleDate)) {
								%>
											<div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
								<%
										}
									}
								%>
							</div>		
						</td>
		<% 					
						}	
				} else if (dateNum < lastDate){	// dateNum이 0 이하인 경우 -> dateNum과 지난 달의 마지막 날짜값 더함 (dateNum은 왼쪽으로 갈 수록 1씩 작아지므로)
		%>
						<td style="color:gray">
							<%=dateNum + preLastDate%>
						</td>	
		<%	
				} else { // dateNum이 현재 달 마지막 날짜보다 큰 경우 -> 그 숫자에서 마지막 날짜를 뺌
		%>	
						<td style="color:gray">
							<%=dateNum - lastDate%>
						</td>				
		<% 	
				}
			}
		%>
			</tr>
		</table>
		</div>
	</body>
</html>