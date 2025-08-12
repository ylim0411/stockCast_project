<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ include file="/WEB-INF/views/header.jsp" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>거래명세서</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css" />
  </head>
  <body>
    <div class="container">
      <div class="title-box">
        <p class="sub-title">매출 관리</p>
        <h2 class="title">거래명세서</h2>
      </div>
      <div class="section-wrap85">
        <div class="section-box section-box1">
          <div class="section-header">공급자용</div>
          <div class="section-body">
            <div class="row">
              <div class="col">
                <p class="label">사업자등록번호</p>
                <p class="value">${client.businessNumber}</p>
              </div>
              <div class="col">
                <p class="label">TEL</p>
                <p class="value">${client.contact}</p>
              </div>
              <div class="col">
                <p class="label">상호</p>
                <p class="value">${client.clientName}</p>
              </div>
            </div>
            <div class="row">
              <div class="col">
                <p class="label">성명</p>
                <p class="value">${client.ceoName}</p>
              </div>
              <div class="col">
                <p class="label">주소</p>
                <p class="value">${client.address}</p>
              </div>
              <div class="col">
                 <p class="label">입금 계좌번호</p>
                 <p class="value">933502 - 00 - 541827 (국민-예금주 : ${client.ceoName})</p>
              </div>
            </div>
          </div>
        </div>

        <div class="section-box section-box2 items-section">
          <div class="section-header">거래 품목</div>
          <div class="sale-items">
            <div class="sale-item header">
              <div>일자</div>
              <div>품목명[규격]</div>
              <div>단가</div>
              <div>수량</div>
              <div>공급가액</div>
              <div>부가세</div>
            </div>
            <c:set var="totalQty" value="0" />
            <c:set var="totalAmount" value="0" />
            <c:forEach items="${accoList}" var="acco">
                 <div class="sale-item">
                    <div><fmt:formatDate value="${acco.orderDate}" pattern="MM/dd" /></div>
                    <div>${acco.productName}</div>
                    <div><fmt:formatNumber value="${acco.purchasePrice}" pattern="#,###" /></div>
                    <div>${acco.purchaseQty}</div>
                    <div><fmt:formatNumber value="${acco.purchasePrice*acco.purchaseQty}" pattern="#,###" /></div>
                    <div><fmt:formatNumber value="${(acco.purchasePrice*acco.purchaseQty)*0.1}" pattern="#,###" /></div>
                </div>
              <c:set var="totalQty" value="${totalQty+acco.purchaseQty}" />
              <c:set var="totalAmount" value="${totalAmount+(acco.purchasePrice*acco.purchaseQty)}" />
            </c:forEach>
          </div><!-- sale-items -->
        </div><!-- section-box  -->
      </div>
    </div>
  </body>
</html>
