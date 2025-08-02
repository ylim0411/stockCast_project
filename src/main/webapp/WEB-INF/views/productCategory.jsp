<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>index</title>
     <meta name="viewport" content="width=device-width, initial-scale=1">
     <script src="${pageContext.request.contextPath}/webjars/chartjs/2.9.4/Chart.min.js"></script>
     <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
     <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/chart.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/chart.css"/>

</head>
<style>
    .hidden{
        display: none;
    }
</style>
<body>
	<div id="productCategory" class="container">
		<div>
			<h1>상품 카테고리 목록</h1>
			<button id="middle">중분류 모두 접기</button>
			<button id="child">소분류 모두 접기</button>
			<table>
				<thead>
					<tr>
						<th>카테고리 레벨</th>
						<th>카테고리 이름</th>
						<th>카테고리 등록일시</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach items="${categoryList}" var="parent">
						<c:if test="${parent.categoryLevel == 1}">
							<tr class="parentLevel" data-id="${parent.categoryId }">
								<td>대분류</td>
								<td>${parent.categoryName }</td>
								<td>${parent.createdAt }</td>
							</tr>
                            <c:forEach items="${categoryList}" var="middle">
                                <c:if test="${middle.parentId == parent.categoryId}">
                                    <tr class="middleLevel" data-id="${middle.categoryId }" data-parent="${parent.categoryId }">
                                        <td>중분류</td>
                                        <td>${middle.categoryName }</td>
                                        <td>${middle.createdAt }</td>
                                    </tr>
                                    <c:forEach items="${categoryList}" var="child">
                                        <c:if test="${child.parentId == middle.categoryId}">
                                            <tr class="childLevel" data-id="${child.categoryId }" data-parent="${middle.categoryId }">
                                                <td>중분류</td>
                                                <td>${child.categoryName }</td>
                                                <td>${child.createdAt }</td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                            </c:forEach>
						</c:if>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
<script>
    $(document).ready(function () {
        $(".parentLevel").click(function () {
            const parentId = $(this).data("id"); // 기존: categoryId → id
            $(`tr.middleLevel[data-parent='${parentId}']`).toggleClass("hidden");
        });

        $(".middleLevel").click(function () {
            const middleId = $(this).data("id");
            $(`tr.childLevel[data-parent='${middleId}']`).toggleClass("hidden");
        });

        $("#middle").click(function () {
            $(".middleLevel").addClass("hidden");
            $(".childLevel").addClass("hidden");
        });
        $("#child").click(function () {
            $(".childLevel").addClass("hidden");
        });
    });


</script>
</html>
