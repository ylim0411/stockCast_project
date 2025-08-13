<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>발주서 상세보기</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
</head>
<body>
<div class="container">
    <div class="title-box">
        <p class="sub-title">발주 관리</p>
        <h2 class="title">발주서</h2>
    </div>

 <div class="section-wrap85">
    <div class="section-actions">
       <div style="display:flex; gap:10px; width:50%;">
           <strong>발주 상태 변경 :</strong>
        <form action="/order/orderDetail" method="get">
            <c:set var="currentStatus" value="${orderStatus}" />
            <input type="hidden" name="id" value="${orderInfo.orderId}">
            <input type="hidden" name="approach" value="approach">
            <select style="width:100px; padding-right:20px" name="status" onchange="this.form.submit()" class="saleYear-select"
                <c:if test="${currentStatus eq '완료'}">disabled</c:if>>
                <c:forEach var="statusOption" items="${['진행중', '완료', '취소']}">
                    <option value="${statusOption}" <c:if test="${statusOption == currentStatus}">selected</c:if>>
                        ${statusOption}
                    </option>
                </c:forEach>
            </select>
        </form>
        </div>
        <div class="btn-box">
            <c:if test="${orderInfo.status ne '완료'}">
                   <button type="button" class="btn btn-blue" onclick="location.href='/order/orderUpdate?id=${orderInfo.orderId}'">수정</button>
                   <button type="button" class="btn btn-red" onclick="deleteOrder(${orderInfo.orderId})">삭제</button>
               </c:if>
        </div>
    </div>

    <!-- 주문 상세 -->
    <div class="section-box section-box1">
        <div class="section-header">주문 상세</div>
        <div class="section-body">
            <div class="row">
                <div class="col">
                    <p class="label">발주번호</p>
                    <p class="value">${orderInfo.orderSubnum}</p>
                </div>
                <div class="col">
                    <p class="label">발주 등록일</p>
                    <p class="value"><fmt:formatDate value="${orderInfo.orderDate}" pattern="yyyy-MM-dd"/></p>
                </div>
                <div class="col">
                    <p class="label">거래처명</p>
                    <p class="value">${orderInfo.clientName}</p>
                </div>
            </div>
            <div class="row">
                <div class="col">
                    <p class="label">총 수량</p>
                    <p class="value">${orderInfo.totalCount}</p>
                </div>
                <div class="col">
                    <p class="label">총 금액</p>
                    <p class="value"><fmt:formatNumber value="${orderInfo.totalPrice}" pattern="#,###"/></p>
                </div>
                 <div class="col">
                    <p></p>
                    <p></p>
                 </div>
            </div>
        </div>
    </div>

    <!-- 발주 품목 -->
    <div class="section-box section-box2 items-section">
        <div class="section-header">발주 품목</div>
        <div class="order-items">
            <div class="order-item header">
                <div>상품번호</div>
                <div>상품명</div>
                <div>구매단가</div>
                <div>수량</div>
                <div>청구비용</div>
            </div>
            <c:forEach items="${orderItems}" var="item">
                <div class="order-item">
                    <div>${item.productId}</div>
                    <div>${item.productName}</div>
                    <div><fmt:formatNumber value="${item.purchasePrice}" pattern="#,###"/></div>
                    <div>${item.purchaseQty}</div>
                    <div><fmt:formatNumber value="${item.purchasePrice * item.purchaseQty}" pattern="#,###"/></div>
                </div>
            </c:forEach>
        </div> <!-- order-items -->
    </div> <!-- section-box  -->
  </div> <!-- section-wrap -->
</div> <!-- container -->

<script>
    function deleteOrder(orderId) {
        if (confirm("정말 삭제하시겠습니까?")) {
            location.href = "/order/orderDelete?id=" + orderId;
        }
    }
</script>
</body>
</html>
