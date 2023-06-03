package vo;
//notice 테이블의 한 행(레코드)을 저장하기 위한 목적
//* 여러 레코드의 모음: 레코드셋
//VO - Value Object (값 객체)
//DTO - Data Transfer object or Domain (데이터 전송 객체)
public class Notice {
	public int noticeNo;
	public String noticeTitle;
	public String noticeContent;
	public String noticeWriter;
	public String createdate;
	public String updatedate;
	public String noticePw;
}