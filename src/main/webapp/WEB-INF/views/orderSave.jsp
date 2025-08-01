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
    <style>
        .orderSummary {
        border: 1px solid var(--color-border);
        }

        .orderItems{
        border: 1px solid var(--color-border);
        }
    </style>
  </head>
  <body>
    <div class="container">

      <div class="title-box">
        <p class="sub-title">발주 관리</p>
        <h2 class="title">발주서 작성</h2>
      </div>

     <!-- 발주 요약 -->
      <table class="orderSummary" aria-label="발주 요약">
        <tbody>
          <tr>
            <th class="vertical-label"><div>발주번호</div></td>
            <td >
              <input type="text" id="order-number">
            </td>
            <th class="vertical-label"><div>발주등록일</div></td>
            <td>
              <input type="text" id="order-date">
            </td>
          </tr>
          <tr>
            <th class="vertical-label"><div>수량</div></td>
            <td>
              <input type="text" id="sum-quantity" readonly value="0">
            </td>
            <th class="vertical-label"><div>총금액</div></td>
            <td>
              <input type="text" id="sum-total" readonly value="0">
            </td>
          </tr>
        </tbody>
      </table>

      <button type="button" class="add-row btn btn-blue">행 추가</button>

      <!-- 발주 상세 -->
      <table class="orderItems" aria-label="상세 상품 목록">
        <thead>
          <tr>
            <th><input type="checkbox" id="select-all" aria-label="전체 선택" /></th>
            <th>상품명</th>
            <th>구매단가</th>
            <th>수량</th>
            <th>총 금액</th>
            <th>액션</th>
          </tr>
        </thead>
        <tbody>
          <tr class="item-row">
            <td class="checkbox-center">
              <input type="checkbox" class="row-select" />
            </td>
            <td>
              <select name="item" class="item-select">
                <option value="${productName}">productName</option>
                <option value="${productName}">productName</option>
                <option  value="${productName}">productName</option>
              </select>
            </td>
            <td>
              <input
                type="number"
                name="price"
                class="price-input"
                min="0"
                value="${price}"
                aria-label="구매단가"
              />
            </td>
            <td>
              <input
                type="number"
                name="count"
                class="count-input"
                min="0"
                value="3"
                aria-label="수량"
              />
            </td>
            <td>
              <input
                type="text"
                name="total"
                class="total-display"
                readonly
                aria-label="총 금액"
                value="4,500"
              />
            </td>
            <td>
              <button type="button" class="delete btn btn-red">삭제</button>
            </td>
          </tr>
        </tbody>
      </table>

    </div>  <!-- container -->
  </body>

</html>
