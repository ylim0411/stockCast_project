<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>발주 현황</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>

  </head>
  <body>
    <div class="container">
      <div class="title">
        <p>발주 관리</p>
        <h2>발주 현황</h2>
      </div>

    <table>
       <tr>
        <th>발주번호</th>
        <th>발주일자</th>
        <th>구매단가</th>
        <th>수량</th>
        <th>총금액</th>
        <th>발주서</th>
    </tr>
    <c:forEach items="${orderStmt}" var="order">
        <tr>
            <td>${order.orderStmtId}</td>
            <td>${order.orderDate}</td>
            <td>${order.purchasePrice}</td>
            <td>${order.purchaseQty}</td>
            <td>${order.purchasePrice * order.purchaseQty}</td>
            <td><button class="btn btn-blue">발주서 보기</button></td>
        </tr>
    </c:forEach>
    </table>
    </div>
  </body>
</html>
