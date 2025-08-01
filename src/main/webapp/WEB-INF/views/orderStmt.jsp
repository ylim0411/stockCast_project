<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
      <div class="title-box">
        <p class="sub-title">발주 관리</p>
        <h2 class="title">발주 현황</h2>
      </div>

    <!-- 날짜 조회 -->
      <form action="/order/orderStmt" method="get" class="form-container">
        <div class="dateForm">
            <input type="date" name="startDate" id="startDate" value="${param.startDate}">
            <input type="date" name="endDate" id="endDate" value="${param.endDate}">
            <button type="submit" class="btn btn-blue">조회</button>
        </div>
        <div class="searchForm">
            <input type="text" name="orderStmtId" placeholder="발주번호 검색" value="${param.orderStmtId}"/>
            <button type="submit" class="btn btn-blue">검색</button>
            <button type="button" class="btn btn-blue" onclick="goOrderSave()"> 발주서 작성</button>
          </div>
      </form>

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
            <td><fmt:formatDate value = "${order.orderDate}" pattern="yyyy-MM-dd"/></td>
            <td>${order.purchasePrice}</td>
            <td>${order.purchaseQty}</td>
            <td>${order.purchasePrice * order.purchaseQty}</td>
            <td><button type="button" class="btn btn-blue" onclick="goOrderDetail(${order.orderStmtId})" >발주서 보기</button></td>
        </tr>
    </c:forEach>
    </table>
    </div>
  </body>

  <script>
    const goOrderSave = () => {
        location.href = "/order/orderSave";
    }

    const goOrderDetail = (id) => {
            location.href = "/order/orderDetail?id=" + id;
        }
  </script>
</html>
