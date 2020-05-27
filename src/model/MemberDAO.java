package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

public class MemberDAO {
	
	//멤버변수(클래스 전체 멤버메서드에서 접근 가능)
	Connection con;
	Statement stmt;
	PreparedStatement psmt;
	ResultSet rs;

	//기본생덩자
	public MemberDAO() {
		System.out.println("MemberDAO생성자 호출");
	}
	public MemberDAO(String driver, String url){
		try {
			Class.forName(driver);
			String id = "kosmo61_user";
			String pw = "1234";
			con = DriverManager.getConnection(url, id, pw);
			System.out.println("DB연결 성공");
		}
		catch(Exception e) {
			System.out.println("DB연결 실패");
			e.printStackTrace();
		}
	}
	//방법1 : 회원의 존재 유무만 판단한다.
	public boolean isMember(String id, String pass) {
		
		String sql = "SELECT COUNT(*) FROM member WHERE id=? AND pass=?";
		int isMember = 0;
		boolean isFlag = false;
		
		try {
			//prepare객체로 쿼리문 전송
			psmt = con.prepareStatement(sql);
			//인파라미타 설정
			psmt.setString(1, id);
			psmt.setString(2, pass);
			//쿼리 실행
			rs = psmt.executeQuery();
			//실행결과를 가져오기 위해 next()호출
			rs.next();
			
			isMember = rs.getInt(1);/* => ResultSet이 무조건 하나이상은 나오므로 if나 while없어도됨
			 								count(*)이기때문임. 또, id는 pk이므로 중복이 안되서 하나만나옴*/
			System.out.println("affected:" + isMember);
			if(isMember == 0){
				isFlag = false;
			} else {
				isFlag = true;
			}
			
		}
		catch(Exception e) {
			isFlag = false;
			e.printStackTrace();
		}
		return isFlag;
	}
	
	//방법2 : 회원인증 후 MemberDTO객체로 회원정보를 반환한다.
	public MemberDTO getMemberDTO(String uid, String upass){
		//DTO객체를 생덩한다.
		MemberDTO memberDTO = new MemberDTO();
		//내가 만든거. PreparedStatement로 get이 되는지 몰라서 statement썻음
/*
		if(isMember(uid, upass)) {
			memberDTO.setId(uid);
			memberDTO.setPass(upass);
			String query = "SELECT name, regidate FROM member WHERE id='" + uid + "'AND pass='" + upass + "'";
			try {
				stmt = con.createStatement();
				rs = stmt.executeQuery(query);
				while(rs.next()) {
					String name = rs.getString(1);
					String regi = rs.getString(2);
					memberDTO.setName(name);
				}
			}
			catch(Exception e) {
				e.printStackTrace();
			}
		} else {
			System.out.println("ㅠ.ㅠ");
		}
*/
		//쿼리문작성
		String sql = "SELECT id, pass, name FROM member WHERE id=? AND pass=?";
		try {
			//prepared객체 생성
			psmt = con.prepareStatement(sql);
			//쿼리문의 인파라메타 설정
			psmt.setString(1, uid);
			psmt.setString(2, upass);
			//오라클로 쿼리문 전송 및 결과셋(ResultSet) 반환받음
			rs = psmt.executeQuery();
			//오라클이 반환해준 ResultSet이 있는지 확인
			if(rs.next()) {// => 결과값이 하나만 나오므로 if 사용 여러개일경우 while를 사용함.
				//true를 반환했다면 ResultSet있음
				//DTO객체에 회원 레코드의 값을 저장한다.
				memberDTO.setId(rs.getString(1));
				memberDTO.setPass(rs.getString(2));
				memberDTO.setName(rs.getString(3));
			} else {
				//false를 반환했다면 ResultSet없음
				System.out.println("결과셋이 없습니다.");
			}
		}
		catch(Exception e) {
			System.out.println("getMembrtDTO오류");
			e.printStackTrace();
		}
		
		//DTO객체를 반환한다.
		return memberDTO;
	}
	
	//방법 3 : Map 컬렉션에 회원정보 저장 후 반환받기 
	public Map<String, String> getMemberMap(String id, String pwd){
		
		Map<String, String> maps = new HashMap<String, String>();
		
		String query = "SELECT id, pass, name FROM member WHERE id=? AND pass=?";
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, id);
			psmt.setString(2, pwd);
			rs = psmt.executeQuery();
			if(rs.next()) {
				maps.put("id", rs.getString(1));
				maps.put("pass", rs.getString(2));
				maps.put("name", rs.getString(3));
			} else {
				System.out.println("결과셋이 없습니다.");
			}
		}
		catch(Exception e) {
			System.out.println("getMemberMap오류");
			//e.printStackTrace();
		}
		
		return maps;
		
	}
}















