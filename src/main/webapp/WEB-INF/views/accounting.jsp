<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>회계 관리</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
    <style>
        /* Flexbox 컨테이너 스타일 */
        .account-tables-container {
            display: flex;
            justify-content: space-between;
            gap: 1px;
        }
    </style>
</head>
<body>
    <div class="containerAuto">
        <div class="title-box">
            <p class="sub-title">매출 관리</p>
            <h2 class="title">회계 관리</h2>
        </div>
        <div class="section-wrap">
        <div class="search-period-info">
                <c:if test="${not empty findDate}">
                  <p>${findDate} 회계 내역 입니다.</p>
                </c:if>
              </div>
            <form action="/accounting/list" method="post" class="form-container">
                <div class="dateForm">
                    <input type="date" name="startDate" id="startDate"/>
                    <span>~<span>
                    <input type="date" name="endDate" id="endDate"/>
                    <button type="submit" class="btn btn-blue">조회</button>
                </div>
                <div class="searchForm">
                    <select name="year" class="saleYear-select">
                        <option value="">조회년도</option>
                        <c:forEach var="year" items="${accountYear}">
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

            <div class="account-tables-container">
                <table>
                    <thead>
                        <tr>
                            <th colspan="2">차변 (자산 및 비용)</th>
                        </tr>
                        <tr>
                            <td>계정과목</td>
                            <td>금액</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th colspan="2"><b>자산</b></td>
                        </tr>
                        <c:forEach var="account" items="${pageData.assetsList}">
                            <tr>
                                <td>${account.name}</td>
                                <td>0</td>
                            </tr>
                        </c:forEach>

                        <tr>
                            <th colspan="2"><b>비용</b></td>
                        </tr>
                        <c:forEach var="account" items="${pageData.expenseList}">
                            <tr>
                                <td>${account.name}</td>
                                <td>0</td>
                            </tr>
                        </c:forEach>

                        <c:set var="debitRowCount" value="${fn:length(pageData.assetsList) + fn:length(pageData.expenseList) + 2}"/>
                        <c:set var="creditRowCount" value="${fn:length(pageData.liabilitiesList) + fn:length(pageData.capitalList) + fn:length(pageData.revenueList) + 3}"/>
                        <c:if test="${creditRowCount > debitRowCount}">
                            <c:set var="emptyRowCount" value="${creditRowCount - debitRowCount}"/>
                            <c:forEach begin="1" end="${emptyRowCount}">
                                <tr>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </c:forEach>
                        </c:if>

                        <tr>
                            <td>총 차변</td>
                            <td>${pageData.totalDebit}</td>
                        </tr>
                    </tbody>
                </table>

                <table>
                    <thead>
                        <tr>
                            <th colspan="2">대변 (부채, 자본 및 수익)</th>
                        </tr>
                        <tr>
                            <td>계정과목</td>
                            <td>금액</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th colspan="2"><b>부채</b></td>
                        </tr>
                        <c:forEach var="account" items="${pageData.liabilitiesList}">
                            <tr>
                                <td>${account.name}</td>
                                <td>0</td>
                            </tr>
                        </c:forEach>

                        <tr>
                            <th colspan="2"><b>자본</b></td>
                        </tr>
                        <c:forEach var="account" items="${pageData.capitalList}">
                            <tr>
                                <td>${account.name}</td>
                                <td>0</td>
                            </tr>
                        </c:forEach>

                        <tr>
                            <th colspan="2"><b>수익</b></td>
                        </tr>
                        <c:forEach var="account" items="${pageData.revenueList}">
                            <tr>
                                <td>${account.name}</td>
                                <td>0</td>
                            </tr>
                        </c:forEach>

                        <c:set var="debitRowCount" value="${fn:length(pageData.assetsList) + fn:length(pageData.expenseList) + 2}"/>
                        <c:set var="creditRowCount" value="${fn:length(pageData.liabilitiesList) + fn:length(pageData.capitalList) + fn:length(pageData.revenueList) + 3}"/>
                        <c:if test="${debitRowCount > creditRowCount}">
                            <c:set var="emptyRowCount" value="${debitRowCount - creditRowCount}"/>
                            <c:forEach begin="1" end="${emptyRowCount}">
                                <tr>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </c:forEach>
                        </c:if>

                        <tr>
                            <td>총 대변</td>
                            <td>${pageData.totalCredit}</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>