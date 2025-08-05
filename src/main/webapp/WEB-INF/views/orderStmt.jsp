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

    <div class="section-wrap">
    <!-- 날짜 + 검색 조회 -->
      <form action="/order/orderStmt" method="get" class="form-container">
        <div class="dateForm">
            <input type="date" name="startDate" id="startDate" value="${param.startDate}">
            <span>~</span>
            <input type="date" name="endDate" id="endDate" value="${param.endDate}">
            <button type="submit" class="btn btn-blue">조회</button>
        </div>

        <div class="searchForm">
            <input type="text" name="orderStmtId" placeholder="발주번호 검색" value="${param.orderStmtId}"/>
            <button type="submit" class="btn btn-blue">검색</button>
            <button type="button" class="btn btn-blue" onclick="goOrderSave()"> 발주서 작성</button>
          </div>
      </form>

   <!-- 발주 리스트 -->
  <div class="table-container">
      <table class="orderStmt-table">
          <tr>
              <th>발주번호</th>
              <th>발주일자</th>
              <th>거래처명</th>
              <th>수량</th>
              <th>총금액</th>
              <th>상태</th>
              <th>발주서</th>
          </tr>

          <c:forEach items="${orderStmt}" var="order">
              <tr>
                  <td>${order.orderId}</td>
                  <td><fmt:formatDate value="${order.orderDate}" pattern="yy/MM/dd"/></td>
                  <td>${order.clientName}</td>
                  <td>${order.totalCount}</td>
                  <td><fmt:formatNumber value="${order.totalPrice}" pattern="#,###"/></td>
                  <td>
                      <c:choose>
                          <c:when test="${order.status.name() == '진행중'}">
                              <span class="btn-orange-b statusBtn">진행중</span>
                          </c:when>
                          <c:when test="${order.status.name() == '완료'}">
                              <span class="btn-blue-b statusBtn">완료</span>
                          </c:when>
                          <c:when test="${order.status.name() == '취소'}">
                              <span class="btn-red-b statusBtn">취소</span>
                          </c:when>
                      </c:choose>
                  </td>
                  <td>
                      <button type="button" class="btn btn-blue"
                          onclick="goOrderDetail(${order.orderId})">발주서 보기</button>
                  </td>
              </tr>
          </c:forEach>
      </table>
  </div> <!-- orderStmt-table -->

   <!-- 발주 페이징 -->
   <div class="paging">
       <c:choose>
           <c:when test="${paging.page <= 1}">
               <span>&lt;</span>
           </c:when>
           <c:otherwise>
               <a href="?page=${paging.page - 1}">&lt;</a>
           </c:otherwise>
       </c:choose>

       <c:forEach var="i" begin="${paging.startPage}" end="${paging.endPage}">
           <c:choose>
               <c:when test="${i == paging.page}">
                   <span class="page">${i}</span>
               </c:when>
               <c:otherwise>
                   <a href="?page=${i}">${i}</a>
               </c:otherwise>
           </c:choose>
       </c:forEach>

       <c:choose>
           <c:when test="${paging.page >= paging.maxPage}">
               <span>&gt;</span>
           </c:when>
           <c:otherwise>
               <a href="?page=${paging.page + 1}">&gt;</a>
           </c:otherwise>
       </c:choose>
    </div> <!-- paging -->
    </div>
    </div> <!-- container -->
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
