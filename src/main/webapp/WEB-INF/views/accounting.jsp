<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>회계 관리</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/accounting.css"/>
</head>
<body>
    <div class="containerAuto">
        <div class="title-box">
            <p class="sub-title">매출 관리</p>
            <h2 class="title">회계 관리</h2>
        </div>
        <div class="section-wrap">
        <form action="/accounting/list" method="post" class="form-container">
          <div class="dateForm">
            <input type="date" name="startDate" id="startDate" />
            <span>~<span>
            <input type="date" name="endDate" id="endDate" />
            <button type="submit" class="btn btn-blue">조회</button>
          </div>
          <div class="searchForm">
            <select name="year" class="saleYear-select">
              <option value="">조회년도</option>
              <c:forEach var="year" items="${saleYear}">
                <option value="${year}">${year}</option>
              </c:forEach>
            </select>
            <div>
                <button class="btn btn-blue">당월</button>
                <button class="btn btn-blue">1분기</button>
                <button class="btn btn-blue">2분기</button>
                <button class="btn btn-blue">3분기</button>
                <button class="btn btn-blue">4분기</button>
                <button class="btn btn-blue">상반기</button>
                <button class="btn btn-blue">하반기</button>
            </div>
          </div>
        </form>
        <div>
            <table>
                <thead>
                    <tr>
                        <th style="width: 15%; border-right: 1px solid black;" colspan="2">자산</th>
                        <th style="width: 15%;" colspan="2">부채</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>계정과목</td>
                        <td style="border-right: 1px solid black;">잔액</td>
                        <td>계정과목</td>
                        <td>잔액</td>
                    </tr>
                    <c:set var="maxLength" value="${fn:length(assetList) > fn:length(liabilityList) ? fn:length(assetList) : fn:length(liabilityList)}"/>
                    <c:if test="${maxLength > 0}">
                        <c:forEach var="i" begin="0" end="${maxLength - 1}">
                            <tr>
                                <td>
                                    <c:if test="${i < fn:length(assetList)}">
                                        ${assetList[i].name}
                                    </c:if>
                                </td>
                                <td style="border-right: 1px solid black;">
                                    <c:if test="${i < fn:length(assetList)}">
                                        ${assetList[i].value}
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${i < fn:length(liabilityList)}">
                                        ${liabilityList[i].name}
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${i < fn:length(liabilityList)}">
                                        ${liabilityList[i].value}
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    <c:if test="${maxLength == 0}">
                        <tr>
                            <td colspan="2" style="border-right: 1px solid black;">데이터가 없습니다.</td>
                            <td colspan="2">데이터가 없습니다.</td>
                        </tr>
                    </c:if>
                    <tr>
                        <td colspan="1" class="total-label">총 자산</td>
                        <td style="border-right: 1px solid black;">${totalAsset}</td>
                        <td colspan="1" class="total-label">총 부채</td>
                        <td>${totalLiability}</td>
                    </tr>
                </tbody>
            </table>
            <table>
                <thead>
                    <tr>
                        <th colspan="2">자본</th>
                        <th colspan="2">수익</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>계정과목</td>
                        <td>잔액</td>
                        <td>계정과목</td>
                        <td>잔액</td>
                    </tr>
                    <c:set var="maxLength" value="${fn:length(capitalList) > fn:length(revenueList) ? fn:length(capitalList) : fn:length(revenueList)}"/>
                    <c:if test="${maxLength > 0}">
                        <c:forEach var="i" begin="0" end="${maxLength - 1}">
                            <tr>
                                <td>
                                    <c:if test="${i < fn:length(capitalList)}">
                                        ${capitalList[i].name}
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${i < fn:length(capitalList)}">
                                        ${capitalList[i].totalPrice}
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${i < fn:length(revenueList)}">
                                        ${revenueList[i].name}
                                    </c:if>
                                </td>
                                <td>
                                    <c:if test="${i < fn:length(revenueList)}">
                                        ${revenueList[i].totalPrice}
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    <c:if test="${maxLength == 0}">
                        <tr>
                            <td colspan="2">데이터가 없습니다.</td>
                            <td colspan="2">데이터가 없습니다.</td>
                        </tr>
                    </c:if>
                    <tr>
                        <td colspan="1" >총 자본</td>
                        <td>${totalCapital}</td>
                        <td colspan="1">총 수익</td>
                        <td>${totalRevenue}</td>
                    </tr>
                </tbody>
            </table>
            <table>
                <thead>
                    <tr>
                        <th colspan="2">비용</th>
                        <th colspan="2"></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>계정과목</td>
                        <td>잔액</td>
                        <td colspan="2"></td>
                    </tr>
                    <c:if test="${not empty expenseList}">
                        <c:forEach var="account" items="${expenseList}">
                            <tr>
                                <td>${account.name}</td>
                                <td>${account.totalPrice}</td>
                                <td colspan="2"></td>
                            </tr>
                        </c:forEach>
                    </c:if>
                    <c:if test="${empty expenseList}">
                         <tr>
                            <td colspan="2">데이터가 없습니다.</td>
                            <td colspan="2"></td>
                        </tr>
                    </c:if>
                    <tr>
                        <td colspan="1">총 비용</td>
                        <td>${totalExpense}</td>
                        <td colspan="2"></td>
                    </tr>
                </tbody>
            </table>
            </div>
        </div>
    </div>
</body>
</html>
