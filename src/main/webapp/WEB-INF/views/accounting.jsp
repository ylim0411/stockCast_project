<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
            <form action="/accounting/accountingList" method="get" class="form-container" name="accountingForm">
                <div class="dateForm">
                    <input type="date" name="startDate" id="startDate"/>
                    <span>~<span>
                    <input type="date" name="endDate" id="endDate"/>
                    <button type="submit" class="btn btn-blue">조회</button>
                    <button type="submit" class="btn btn-blue" name="action" value="load">불러오기</button>
                    <button type="submit" class="btn btn-blue" name="action" value="store">점포매출</button>
                </div>
                <div class="searchForm">
                    <select style="width:120px;" name="year" class="saleYear-select" onchange="this.form.submit()">
                            <option value="" selected>${selectedYear}</option>
                            <c:forEach var="yearOption" items="${accountYear}">
                                <c:if test="${yearOption != selectedYear}">
                                    <option value="${yearOption}">${yearOption}</option>
                                </c:if>
                            </c:forEach>
                        </select>
                    <div>
                        <button name="btn" value="cMonth" class="btn btn-blue">당월</button>
                        <button name="btn" value="1q" class="btn btn-blue">1분기</button>
                        <button name="btn" value="2q" class="btn btn-blue">2분기</button>
                        <button name="btn" value="3q" class="btn btn-blue">3분기</button>
                        <button name="btn" value="4q" class="btn btn-blue">4분기</button>
                        <button name="btn" value="first" class="btn btn-blue">상반기</button>
                        <button name="btn" value="second" class="btn btn-blue">하반기</button>
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
                            <td style="width : 15%;">계정과목</td>
                            <td style="width : 15%;">금액</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th colspan="2"><b>자산</b></td>
                        </tr>
                        <c:set var="totalAssets" value="0"/>
                        <c:forEach var="account" items="${pageData.assetsList}">
                            <tr>
                                <td>${account.name}</td>
                                <td><p><fmt:formatNumber value="${accountValues[account.name]}" pattern="#,###"/></p></td>
                            </tr>
                        <c:set var="totalAssets" value="${totalAssets + accountValues[account.name]}"/>
                        </c:forEach>
                        <tr>
                            <td>자산 총계</td>
                            <td><p><fmt:formatNumber value="${totalAssets}" pattern="#,###"/></p></td>
                        </tr>
                        <tr>
                            <th colspan="2"><b>비용</b></td>
                        </tr>
                        <c:set var="totalExpenses" value="0"/>
                        <c:forEach var="account" items="${pageData.expenseList}">
                            <tr>
                                <td>${account.name}</td>
                                <td><p><fmt:formatNumber value="${accountValues[account.name]}" pattern="#,###"/></p></td>
                            </tr>
                            <c:set var="totalExpenses" value="${totalExpenses + accountValues[account.name]}"/>
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
                            <td>비용 총계</td>
                            <td><p><fmt:formatNumber value="${totalExpenses}" pattern="#,###"/></p></td>
                        </tr>

                        <!-- <tr>
                            <td>총 차변</td>
                            <td><p><fmt:formatNumber value="${totalAssets+totalExpenses}" pattern="#,###"/></p></td>
                        </tr> -->
                    </tbody>
                </table>

                <table>
                    <thead>
                        <tr>
                            <th colspan="2">대변 (부채, 자본 및 수익)</th>
                        </tr>
                        <tr>
                            <td style="width : 15%;">계정과목</td>
                            <td style="width : 15%;">금액</td>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <th colspan="2"><b>부채</b></td>
                        </tr>
                        <c:set var="totalLiabilities" value="0"/>
                        <c:forEach var="account" items="${pageData.liabilitiesList}">
                            <tr>
                                <td>${account.name}</td>
                                <td><p><fmt:formatNumber value="${accountValues[account.name]}" pattern="#,###"/></p></td>
                            </tr>
                            <c:set var="totalLiabilities" value="${totalLiabilities + accountValues[account.name]}"/>
                        </c:forEach>
                        <tr>
                            <th colspan="2"><b>자본</b></th>
                        </tr>
                        <c:set var="totalCapital" value="0"/>
                        <c:forEach var="account" items="${pageData.capitalList}">
                            <tr>
                                <td>${account.name}</td>
                                <td><p><fmt:formatNumber value="${accountValues[account.name]}" pattern="#,###"/></p></td>
                            </tr>
                            <c:set var="totalCapital" value="${totalCapital + accountValues[account.name]}"/>
                        </c:forEach>
                        <tr>
                                                    <td></td>
                                                    <td></td>
                                                </tr>
                        <tr>
                            <td>자본 총계</td>
                            <td><p><fmt:formatNumber value="${totalCapital}" pattern="#,###"/></p></td>
                        </tr>
                        <tr>
                        <c:set var="totalIncome" value="0"/>
                            <th colspan="2"><b>수익</b></td>
                        </tr>
                        <c:forEach var="account" items="${pageData.revenueList}">
                            <tr>
                                <td>${account.name}</td>
                                <td><p><fmt:formatNumber value="${accountValues[account.name]}" pattern="#,###"/></p></td>
                            </tr>
                            <c:set var="totalIncome" value="${totalIncome + accountValues[account.name]}"/>
                        </c:forEach>

                        <c:set var="debitRowCount" value="${fn:length(pageData.assetsList) + fn:length(pageData.expenseList) + 1}"/>
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
                            <td>수익 총계</td>
                            <td><p><fmt:formatNumber value="${totalIncome}" pattern="#,###"/></p></td>
                        </tr>
                        <!-- <tr>
                            <td>총 대변</td>
                            <td><p><fmt:formatNumber value="${totalLiabilities+totalCapital+totalIncome}" pattern="#,###"/></p></td>
                        </tr> -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>