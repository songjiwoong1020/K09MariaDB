package util;

public class PagingUtil {

	public static String pagingImg(int totalRecordCount,
			int pageSize, int blockPage, int nowPage, String pageName) {
		
		String pagingStr = "";
		
		int totalPage = (int)(Math.ceil(((double)totalRecordCount/pageSize)));
		
		int intTemp = ((nowPage-1)/blockPage) * blockPage + 1;
		
		if(intTemp != 1) {
			pagingStr += "<a href='" + pageName + "nowPage=1'>"
					+ "<img src='../images/paging1.gif'></a>";
			pagingStr += "&nbsp;";
			pagingStr += "<a href='" + pageName + "nowPage=" + (intTemp-blockPage)
					+ "'> <img src='../images/paging2.gif'></a>";
		}
		
		int blockCount = 1;
		
		while(blockCount <= blockPage && intTemp <= totalPage) {
			if(intTemp == nowPage) {
				pagingStr += "&nbsp;" + intTemp + "&nbsp;";
			} else {
				pagingStr += "&nbsp; <a href='" + pageName + "nowPage="
							 + intTemp + "'>" + intTemp + "</a>&nbsp;";
			}
			intTemp++;
			blockCount++;
		}
		
		if(intTemp <= totalPage) {
			pagingStr += "<a href='" + pageName + "nowPage=" + intTemp + "'>"
					+ "<img src='../images/paging3.gif'></a>";
			pagingStr += "&nbsp;";
			pagingStr += "<a href='" + pageName + "nowPage=" + totalPage
					+ "'> <img src='../images/paging4.gif'></a>";
		}
		System.out.println("pagingStr=" + pagingStr);
		
		return pagingStr;
	}
	
	public static String pagingBS4(int totalRecordCount,
			int pageSize, int blockPage, int nowPage, String pageName) {
		
		String pagingStr = "<ul class=\"pagination justify-content-center\">";
		
		int totalPage = (int)(Math.ceil(((double)totalRecordCount/pageSize)));
		
		int intTemp = ((nowPage-1)/blockPage) * blockPage + 1;
		
		//왼쪽 버튼부분
		if(intTemp != 1) {
			pagingStr += "<li class=\"page-item\"><a class=\"page-link\" href='" + pageName + "nowPage=1'>"
					+ "<i class=\"fas fa-angle-double-left\"></i></a></li>";
			pagingStr += "&nbsp;";
			pagingStr += "<li class=\"page-item\"><a href='" + pageName + "nowPage=" + (intTemp-blockPage) + "' class=\"page-link\"><i class=\"fas fa-angle-left\"></i></a></li>";
		}
		
		int blockCount = 1;
		
		//1~5 버튼 부분
		while(blockCount <= blockPage && intTemp <= totalPage) {
			if(intTemp == nowPage) {
				pagingStr += "<li class=\"page-item active\"><a href=\"#\" class=\"page-link\">" + intTemp +"</a></li>";
			} else {
				pagingStr += "<li class=\"page-item\"><a href='" + pageName + "nowPage=" + intTemp + "' class=\"page-link\">" + intTemp +"</a></li>";
				
			}
			intTemp++;
			blockCount++;
		}
		
		//오른쪽 버튼 부분
		if(intTemp <= totalPage) {
			pagingStr += "<li class=\"page-item\"><a href='" + pageName + "nowPage=" + intTemp + "' class=\"page-link\"><i class=\"fas fa-angle-right\"></i></a></li>";
			pagingStr += "&nbsp;";
			pagingStr += "<li class=\"page-item\"><a href='" + pageName + "nowPage=" + totalPage + "' class=\"page-link\"><i class=\"fas fa-angle-double-right\"></i></a></li>";
		}
		pagingStr += "</ul>";
		
		//System.out.println("pagingStr=" + pagingStr);
		
		return pagingStr;
	}
	
}
