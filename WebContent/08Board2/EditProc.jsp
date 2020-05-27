<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%-- 파일명 : EditProc.jsp --%>
<%@ include file="../common/isLogin.jsp" %>
<!-- 해당 파일 내에서 bname에 대한 폼값을 받고있음 -->
<%@ include file = "../common/isFlag.jsp" %>
<%
request.setCharacterEncoding("UTF-8");

//String bname = request.getParameter("bname");
String num = request.getParameter("num");
String title = request.getParameter("title");
String content = request.getParameter("content");

BbsDTO dto = new BbsDTO();
dto.setNum(num);
dto.setTitle(title);
dto.setContent(content);

BbsDAO dao = new BbsDAO(application);

int affected = dao.updateEdit(dto);
if(affected == 1){
	//정상적으로 수정이 되었다면 수정된 내용의 확인을 위해 상세보기로 이동
	response.sendRedirect("BoardView.jsp?bname=" + bname + "&num=" + dto.getNum());
} else {
%>
	<script>
		alert("수정하기에 실패하였습니다.");
		history.go(-1);
	</script>
<%
}
%>
