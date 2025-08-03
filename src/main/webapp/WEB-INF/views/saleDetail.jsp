<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>거래명세서</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/static/css/style.css"
    />
  </head>
  <body>
    <div class="title-box">
      <p class="sub-title">매출 관리</p>
      <h2 class="title">거래명세서</h2>
    </div>
    <div class="container">
      <!DOCTYPE html>
      <html lang="ko">
        <head>
          <meta charset="UTF-8" />
          <meta
            name="viewport"
            content="width=device-width, initial-scale=1.0"
          />
          <title>거래명세서</title>
          <link rel="stylesheet" href="style.css" />
        </head>
        <body>
          <div>
            <div class="dateil-header">
              <table class="deteil-table">
                <tr>
                  <th colspan="5">거래명세서</th>
                </tr>
                <tr>
                  <th rowspan="3">공급자용</th>
                  <td>사업자등록번호</td>
                  <td>00-000-0000</td>
                  <td>TEL</td>
                  <td>000-0000-0000</td>
                </tr>
                <tr>
                  <td>상호</td>
                  <td>나뚜루</td>
                  <td>성명</td>
                  <td>홍길동</td>
                </tr>
                <tr>
                  <td>주소</td>
                  <td colspan="3">서울시 관악구</td>
                </tr>
              </table>
            </div></br>
            <div>
              입금 계좌번호 : 933502 - 00 - 541827 (국민-예금주 : 이카플레이스)
            </div></br>
            <table>
              <thead>
                <tr>
                  <th>일자</th>
                  <th>품목명[규격]</th>
                  <th>수량</th>
                  <th>단가</th>
                  <th>공급가액</th>
                  <th>부가세</th>
                  <th>적요</th>
                </tr>
              </thead>
              <tbody>
              <c:set var="totalQty" value="0" />
              <c:set var="totalAmount" value="0" />
                <c:forEach items="${accoList}" var="acco">
                  <tr>
                    <td><fmt:formatDate value = "${acco.orderDate}" pattern="MM/dd"/></td>
                    <td>${acco.productName}</td>
                    <td>${acco.purchaseQty}</td>
                    <td>${acco.purchasePrice}</td>
                    <td><fmt:formatNumber value="${acco.purchasePrice*acco.purchaseQty}" pattern="#,###"/></td>
                    <td><fmt:formatNumber value="${(acco.purchasePrice*acco.purchaseQty)*0.1}" pattern="#,###"/></td>
                  </tr>
                  <c:set var="totalQty" value="${totalQty+acco.purchaseQty}"/>
                  <c:set var="totalAmount" value="${totalAmount+(acco.purchasePrice*acco.purchaseQty)}" />
                </c:forEach>
              </tbody>
            </table></br>
            <table>
              <tfoot>
                <tr>
                  <th>수량</th>
                  <td>${totalQty}</td>
                  <th>공급가액</th>
                  <td><fmt:formatNumber value="${totalAmount}" pattern="#,###"/></td>
                  <th>VAT</th>
                  <td><fmt:formatNumber value="${totalAmount * 0.1}" pattern="#,###"/></td>
                  <th>합계</th>
                  <td><fmt:formatNumber value="${totalAmount * 1.1}" pattern="#,###"/></td>
                  <th>인수</th>
                  <td>회사명</td>
                </tr>
              </tfoot>
            </table>
          </div>
        </body>
      </html>
    </div>
  </body>
</html>
