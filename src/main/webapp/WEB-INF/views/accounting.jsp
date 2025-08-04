<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>index</title>
     <meta name="viewport" content="width=device-width, initial-scale=1">
     <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>

</head>
<body>
    <div class="container">
        <div class="title-box">
            <p class="sub-title">매출 관리</p>
            <h2 class="title">회계 관리</h2>
        </div>
             <form action="/sale/find" method="post" class="form-container">
                  <div class="dateForm">
                      <input type="date" name="startDate" id="startDate">
                      <input type="date" name="endDate" id="endDate">
                      <button type="submit" class="btn btn-blue">조회</button>
                  </div>
                  <div class="searchForm">
                      <input type="text" name="orderNumber" placeholder="발주번호 검색"/>
                      <button type="submit" class="btn btn-blue">검색</button>
                    </div>
                </form>
         <table>
                <tr>
                    <th>발주번호</th>
                    <th>발주일자</th>
                    <th>거래처명</th>
                    <th>카테고리</th>
                    <th>총금액</th>
                    <th>보고서</th>
                </tr>
                <c:forEach items="${saleList}" var="sale">
                    <tr>
                        <td>${sale.orderId}</td>
                        <td><fmt:formatDate value = "${sale.orderdate}" pattern="yyyy-MM-dd"/></td>
                        <td>${sale.clientName}</td>
                        <td>${sale.productName}</td>
                        <td>${sale.price}</td>
                        <td><button type="button" class="btn btn-blue" onclick="onSaleStmt(${sale.orderId})">거래명세서</td>
                    </tr>
                </c:forEach>
            </table>
    </div>
</body>
<script>
  const onSaleStmt = (id) => {
        location.href = "/sale/detail?o_id="+id;
    }
</script>
</html>
