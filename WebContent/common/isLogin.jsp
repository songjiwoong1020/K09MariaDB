<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 파일명 : isLogin.jsp --%>
<%
if(session.getAttribute("USER_ID") == null){
%>	
	<script>
		alert("로그인 후 이용해주십시요.");
		location.href = "../06Session/Login.jsp";
	</script>
<%
	return;//jsp코드가 우선순위가 높기때문에 리턴을 걸어줘야함(아직까진 상관없으나 나중에 코드가 더 추가될시)
}
%>