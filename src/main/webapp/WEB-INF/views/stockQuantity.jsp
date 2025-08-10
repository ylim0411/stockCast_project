<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>재고 현황</title>
  <meta name="viewport" content="width=device-width, initial-scale=1" />

  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css" />
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/chart.css" />
</head>
<body>
  <div id="stockQuantity" class="containerAuto">
    <div class="title-box">
        <p class="sub-title">상품 관리</p>
        <h2 class="title">재고현황</h2>
    </div>
    <div class="section-wrap">
      <div class="form-container">
        <div class="btn-box">
          <form id="searchForm" method="get" action="${pageContext.request.contextPath}/product/stockQuantity">
              <input
                type="text"
                name="keyword"
                placeholder="상품명 검색"
                value="${param.keyword != null ? param.keyword : ''}"
              />
        
              <select name="month" style="width: 150px;">
                <option value="">월간 전체</option>
                <c:forEach var="m" begin="1" end="12">
                  <option value="${m}" <c:if test="${param.month != null && param.month == m}">selected</c:if>>
                    ${m}월
                  </option>
                </c:forEach>
              </select>
              <button type="submit" class="btn btn-blue">검색</button>
          </form>
        </div>
        <button type="button" id="btnCloseMonth" class="btn btn-red">마감</button>
      </div>
      <div>
        <table class="stock-table">
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

                <td>${stockQuantity.initialStockQuantity}</td>
                <td><fmt:formatNumber value="${stockQuantity.initialUnitPrice}" pattern="#,###" /></td>
                <td><fmt:formatNumber value="${stockQuantity.totalInitialStockAmount}" pattern="#,###" /></td>

                <td>${stockQuantity.purchaseQty}</td>
                <td><fmt:formatNumber value="${stockQuantity.purchasePrice}" pattern="#,###" /></td>
                <td><fmt:formatNumber value="${stockQuantity.totalPurchase}" pattern="#,###" /></td>

                <td>${stockQuantity.saleQty}</td>
                <td><fmt:formatNumber value="${stockQuantity.salePrice}" pattern="#,###" /></td>
                <td><fmt:formatNumber value="${stockQuantity.totalSale}" pattern="#,###" /></td>

                <td>${stockQuantity.stockQuantity}</td>
                <td><fmt:formatNumber value="${stockQuantity.price}" pattern="#,###" /></td>
                <td><fmt:formatNumber value="${stockQuantity.totalStockAmount}" pattern="#,###" /></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </div>
   
  </div>

  <script>
    $(function () {
      $("#btnCloseMonth").click(function () {
        const selectedMonth = $("select[name='month']").val();

        if (!selectedMonth) {
          alert("마감할 월을 선택하세요.");
          return;
        }

        // 서버에 마감 요청 전송 (POST)
        $.ajax({
          url: "${pageContext.request.contextPath}/stock/close",
          method: "POST",
          contentType: "application/json",
          data: JSON.stringify({ month: selectedMonth }),
          success: function (response) {
            alert("마감 처리 완료되었습니다.");
            // 마감 후 새로고침 또는 목록 다시 불러오기
            location.reload();
          },
          error: function () {
            alert("마감 처리 중 오류가 발생했습니다.");
          },
        });
      });
    });
  </script>
</body>
</html>