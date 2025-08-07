<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>index</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <script src="${pageContext.request.contextPath}/webjars/chartjs/2.9.4/Chart.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/static/js/chart.js"></script>

    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/style.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/chart.css"
    />

    <script></script>
  </head>
  <body>
    <div id="stockQuantity" class="container">
      <h1>재고 현황</h1>
      <input type="text" name="productName" placeholder="상품명 검색" />
      <button type="submit" class="btn btn-blue">검색</button>

      <div>
        <table>
          <thead>
            <tr>
              <th rowspan="2">대분류</th>
              <th rowspan="2">중분류</th>
              <th rowspan="2">상품코드</th>
              <th rowspan="2">상품명</th>
              <th colspan="3">기초재고</th>
              <th colspan="3">입고</th>
              <th colspan="3">출고</th>
              <th colspan="3">기말재고</th>
            </tr>
            <tr>
              <th>재고수량</th>
              <th>재고단가</th>
              <th>재고금액</th>
              <th>입고수량</th>
              <th>입고단가</th>
              <th>입고금액</th>
              <th>출고수량</th>
              <th>출고단가</th>
              <th>출고금액</th>
              <th>재고수량</th>
              <th>재고단가</th>
              <th>재고금액</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach items="${stockQuantityList}" var="stockQuantity">
              <tr>
                <td>${stockQuantity.topLevelCategoryName}</td>
                <td>${stockQuantity.categoryName}</td>
                <td>${stockQuantity.productId}</td>
                <td>${stockQuantity.productName}</td>
                <td>${stockQuantity.stockQuantity}</td>
                <td><fmt:formatNumber value="${stockQuantity.price}" pattern="#,###"/></td>
                <td><fmt:formatNumber value="${stockQuantity.totalStockAmount}" pattern="#,###"/></td>
                <td>${stockQuantity.purchaseQty}</td>
                <td><fmt:formatNumber value="${stockQuantity.purchasePrice}" pattern="#,###"/></td>
                <td><fmt:formatNumber value="${stockQuantity.totalPurchase}" pattern="#,###"/></td>
                <td>${stockQuantity.saleQty}</td>
                <td><fmt:formatNumber value="${stockQuantity.salePrice}" pattern="#,###"/></td>
                <td><fmt:formatNumber value="${stockQuantity.totalSale}" pattern="#,###"/></td>
                <td>${stockQuantity.stockQuantity}</td>
                <td><fmt:formatNumber value="${stockQuantity.price}" pattern="#,###"/></td>
                <td><fmt:formatNumber value="${stockQuantity.totalStockAmount}" pattern="#,###"/></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
  </body>
</html>
