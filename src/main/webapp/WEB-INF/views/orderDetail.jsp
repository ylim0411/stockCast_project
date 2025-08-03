<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>발주서 작성</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
  </head>
  <body>
    <div class="container">
        <div class="title-box">
            <p class="sub-title">발주 관리</p>
            <h2 class="title">발주 상세 페이지</h2>
        </div>

       <!-- 주문상세 -->
       <div class="order-detail-box">
           <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
               <!-- 왼쪽: 발주 상태 -->
               <div>
                   <strong>현재 발주 상태 :</strong>
                   <c:choose>
                       <c:when test="${orderInfo.status == '진행중'}">
                           <span style="color: orange; font-weight: bold;">진행중</span>
                       </c:when>
                       <c:when test="${orderInfo.status == '완료'}">
                           <span style="color: blue; font-weight: bold;">완료</span>
                       </c:when>
                       <c:when test="${orderInfo.status == '취소'}">
                           <span style="color: red; font-weight: bold;">취소</span>
                       </c:when>
                   </c:choose>
               </div>

               <!-- 오른쪽: 버튼 -->
               <div>
                   <button type="button" class="btn btn-blue"
                       onclick="location.href='/order/orderEdit?id=${orderInfo.orderId}'">수정</button>
                   <button type="button" class="btn btn-red"
                       onclick="deleteOrder(${orderInfo.orderId})">삭제</button>
               </div>
           </div>

           <!-- 기존 상세 테이블 -->
           <table class="detail-table">
               <tr>
                   <th>발주번호</th>
                   <td>${orderInfo.orderId}</td>
                   <th>발주 등록일</th>
                   <td><fmt:formatDate value="${orderInfo.orderDate}" pattern="yyyy-MM-dd"/></td>
                   <th>거래처명</th>
                   <td>${orderInfo.clientName}</td>
               </tr>
               <tr>
                   <th>총 수량</th>
                   <td>${orderInfo.totalCount}</td>
                   <th>총 금액</th>
                   <td><fmt:formatNumber value="${orderInfo.totalPrice}" pattern="#,###"/></td>
               </tr>
           </table>
       </div>

        <!-- 발주 품목 테이블 -->
        <div class="order-items-box">
            <table class="list-table">
                <thead>
                    <tr>
                        <th>상품번호</th>
                        <th>상품명</th>
                        <th>구매단가</th>
                        <th>수량</th>
                        <th>청구비용</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${orderItems}" var="item">
                        <tr>
                            <td>${item.productId}</td>
                            <td>${item.productName}</td>
                            <td><fmt:formatNumber value="${item.purchasePrice}" pattern="#,###"/></td>
                            <td>${item.purchaseQty}</td>
                            <td><fmt:formatNumber value="${item.purchasePrice * item.purchaseQty}" pattern="#,###"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>  <!-- container -->

    <script>
    function deleteOrder(orderId) {
        if (confirm("정말 삭제하시겠습니까?")) {
            location.href = "/order/orderDelete?id=" + orderId;
        }
    }
    </script>
  </body>

</html>
