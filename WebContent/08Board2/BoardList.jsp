<%@page import="util.JavascriptUtil"%>
<%@page import="util.PagingUtil"%>
<%@page import="model.BbsDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model.BbsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <!-- Board2 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 필수파라미터 체크 로직 -->
<%@ include file="../common/isFlag.jsp" %>
<%
request.setCharacterEncoding("UTF-8");



//web.xml에서 마리아디비 관련정보로 수정한다.
String driver = application.getInitParameter("MariaJDBCDriver");
String url = application.getInitParameter("MariaConnectURL");

BbsDAO dao = new BbsDAO(driver, url);

Map<String, Object> param = new HashMap<String, Object>();

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//필수파라미터인 bname을 DAO로 전달하기 위해 Map컬렉션에 저장한다.
param.put("bname", bname);

//필수 파라미터에 대한 쿼리스트링 처리(원래는 ""값으로 선언만 해둔상태였음 검색어 저장용도엿던 변수에 게시판 구분용도도 추가)
String queryStr = "bname=" + bname + "&";
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


String searchColumn = request.getParameter("searchColumn");
String searchWord = request.getParameter("searchWord");
if(searchWord != null){
	param.put("Column", searchColumn);
	param.put("Word", searchWord);
	
	queryStr += "searchColumn=" + searchColumn + "&searchWord=" + searchWord + "&";
}

int totalRecordCount = dao.getTotalRecordCount(param);

int pageSize = Integer.parseInt(application.getInitParameter("PAGE_SIZE"));
int blockPage = Integer.parseInt(application.getInitParameter("BLOCK_PAGE"));

int totalPage = (int)Math.ceil((double)totalRecordCount/pageSize);
int nowPage = (request.getParameter("nowPage") == null || request.getParameter("nowPage").equals("")) 
	? 1 : Integer.parseInt(request.getParameter("nowPage"));
System.out.println("리스트에서 nowPage=" + nowPage);
//오라클과 다르게 limit를 사용하기때문에 수정해준다.
//limit의 첫번째 인자 : 시작인덱스
//오라클은 (nowPage-1)*pageSize + 1
int start = (nowPage-1)*pageSize;
//limit의 두번째 인자 : 가져올 레코드 갯수
//오라클은 nowPage * pageSize 이다. rownum을 between을 이용해서 만들기 때문이다.
int end = pageSize;

param.put("start", start);
param.put("end", end);

List<BbsDTO> bbs = dao.selectListPage(param);


dao.close();
%>
<html lang="en">
<jsp:include page="../common/boardHead.jsp" /> <!-- HTML head부분 -->
<body>
<div class="container">
	<jsp:include page="../common/boardTop.jsp" /> <!-- 게시판 상단 -->
	<div class="row">		
		<jsp:include page="../common/boardLeft.jsp" /> <!-- 게시판 좌측 -->
		<div class="col-9 pt-3">
			<h3><%=boardTitle %>게시판 - <small>이런저런 기능이 있는 게시판입니다.</small></h3>
			
			<div class="row">
				<!-- 검색부분 -->
				<form class="form-inline ml-auto" name="searchFrm" method="get">
				<!-- 검색시 필수 파라미터인 bname이 전달되야 한다. -->
				<input type="hi dden"  name="bname" value=<%=bname %> />
					<div class="form-group">
						<select name="searchColumn" class="form-control">
							<option value="title">제목</option>
							<option value="content">내용</option>
						</select>
					</div>
					<div class="input-group">
						<input type="text" name="searchWord"  class="form-control"/>
						<div class="input-group-btn">
							<button type="submit" class="btn btn-warning">
								<i class='fa fa-search' style='font-size:20px'></i>
							</button>
						</div>
					</div>
				</form>	
			</div>
			<div class="row mt-3">
				<!-- 게시판리스트부분 -->
				<table class="table table-bordered table-hover table-striped">
				<colgroup>
					<col width="60px"/>
					<col width="*"/>
					<col width="120px"/>
					<col width="120px"/>
					<col width="80px"/>
					<col width="60px"/>
				</colgroup>				
				<thead>
				<tr style="background-color: rgb(133, 133, 133); " class="text-center text-white">
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>작성일</th>
					<th>조회수</th>
					<!-- <th>첨부</th> -->
				</tr>
				</thead>				
				<tbody>
				<%
				//List컬렉션에 입력된 데이터가 없을때 true를 반환.
				if(bbs.isEmpty()){
				%>
				<tr>
					<td colspan="5" align="center" height="100">
						등록된 게시물이 없습니다.
					</td>
				</tr>
				<%
				} else {
					//게시물의 가상번호로 사용 할 변수
					int vNum = 0;
					int countNum = 0;
					
					/*
					컬렉션에 입력된 데이터가 있다면 저장된 BbsDTO의 갯수만큼
					즉, DB가 반환해준 레코드의 갯수만큼 반복하면서 출력한다.
					*/
					for(BbsDTO dto : bbs){
						//전체 레코드 수를 이용하여 하나씩 차감하면서 가상번호 부여
						vNum = totalRecordCount - (((nowPage-1) * pageSize) + countNum++);
						/*
						전체 게시물 수 : 107개라 가정
						페이지 사이즈 : 10(web.xml에서 설정)
						
						현재페이지1
							첫번째 게시물 : 107 - (((1-1) * 10) + 0) = 107
							두번째 게시물 : 107 - (((1-1) * 10) + 1) = 106
						현재페이지2
							첫번째 게시물 : 107 - (((2-1) * 10) + 0) = 97
							두번째 게시물 : 107 - (((2-1) * 10) + 1) = 96
						*/
				%>
				<!-- 리스트반복 start-->
				<tr>
					<td class="text-center"><%=vNum %></td>
					<td class="text-left">
						<a href="BoardView.jsp?num=<%=dto.getNum() %>
						&nowPage=<%=nowPage%>&<%=queryStr%>"><%=dto.getTitle() %></a>
					</td>
					<td class="text-center"><%=dto.getId() %></td>
					<td class="text-center"><%=dto.getPostDate() %></td>
					<td class="text-center"><%=dto.getVisitcount() %></td>
					<!-- <td class="text-center"><i class="material-icons" style="font-size:20px">attach_file</i></td> -->
				</tr>
				<!-- 리스트반복 end -->
				<% 
					}//for-each문 끝
				}//if문 끝
				%>
				</tbody>
				</table>
			</div>
			<div class="row">
				<div class="col text-right">
					<% if(bname.equals("freeboard") || bname.equals("qna")){ %>
					<button type="button" class="btn btn-primary"
						onclick="location.href='BoardWrite.jsp?bname=<%=bname %>';">글쓰기</button>
					<% } %>
				</div>
			</div>
			<div class="row mt-3">
				<div class="col">
					<!-- 페이지번호 부분 -->
				<!--<ul class='pagination justify-content-center'>
						<li class='page-item'><a href='#' class='page-link'><i class='fas fa-angle-double-left'></i></a></li>
						<li class='page-item'><a href='#' class='page-link'><i class='fas fa-angle-left'></i></a></li>
						
						<li class="page-item"><a href="#" class="page-link">1</a></li>		
						<li class="page-item active"><a href="#" class="page-link">2</a></li>
						<li class="page-item"><a href="#" class="page-link">3</a></li>
						<li class="page-item"><a href="#" class="page-link">4</a></li>		
						<li class="page-item"><a href="#" class="page-link">5</a></li>
						
						<li class="page-item"><a href="#" class="page-link"><i class="fas fa-angle-right"></i></a></li>
						<li class="page-item"><a href="#" class="page-link"><i class="fas fa-angle-double-right"></i></a></li>
					</ul> -->
					<%=PagingUtil.pagingBS4(totalRecordCount, pageSize, blockPage, nowPage, "BoardList.jsp?" + queryStr) %>
				</div>				
			</div>		
		</div>
	</div> 
	<jsp:include page="../common/boardBottom.jsp" /> <!-- 게시판 아래 -->
</div> <!-- 컨테이너 -->
</body>
</html>

<!-- 
	<i class='fas fa-edit' style='font-size:20px'></i>
	<i class='fa fa-cogs' style='font-size:20px'></i>
	<i class='fas fa-sign-in-alt' style='font-size:20px'></i>
	<i class='fas fa-sign-out-alt' style='font-size:20px'></i>
	<i class='far fa-edit' style='font-size:20px'></i>
	<i class='fas fa-id-card-alt' style='font-size:20px'></i>
	<i class='fas fa-id-card' style='font-size:20px'></i>
	<i class='fas fa-id-card' style='font-size:20px'></i>
	<i class='fas fa-pen' style='font-size:20px'></i>
	<i class='fas fa-pen-alt' style='font-size:20px'></i>
	<i class='fas fa-pen-fancy' style='font-size:20px'></i>
	<i class='fas fa-pen-nib' style='font-size:20px'></i>
	<i class='fas fa-pen-square' style='font-size:20px'></i>
	<i class='fas fa-pencil-alt' style='font-size:20px'></i>
	<i class='fas fa-pencil-ruler' style='font-size:20px'></i>
	<i class='fa fa-cog' style='font-size:20px'></i>

	아~~~~힘들다...ㅋ
 -->