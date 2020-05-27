<%@page import="model.BbsDAO"%>
<%@page import="model.BbsDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../common/isLogin.jsp" %>
<%@ include file="../common/isFlag.jsp" %>
<%
//out.println("제목:" + request.getParameter("title"));
//out.println("내용:" + request.getParameter("content"));
request.setCharacterEncoding("UTF-8");

String title = request.getParameter("title");
String content = request.getParameter("content");

BbsDTO dto = new BbsDTO();
dto.setTitle(title);
dto.setContent(content);

dto.setId(session.getAttribute("USER_ID").toString());

//게시판 필수파라미터를 DTO에 추가
dto.setBname(bname);


BbsDAO dao = new BbsDAO(application);

int affected = dao.insertWrite(dto);

if(affected == 1){
	response.sendRedirect("BoardList.jsp?bname=" + bname);
} else {
%>
	<script>
		alert("글쓰기에 실패하였습니다.");
		history.go(-1);
	</script>
<%
}
%>
