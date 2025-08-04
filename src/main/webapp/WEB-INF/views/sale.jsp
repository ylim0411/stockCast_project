<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chart.js Example</title>
    <script src="${pageContext.request.contextPath}/webjars/chartjs/2.9.4/Chart.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/chart.css"/>
</head>
<body>
    <div class="container">
        <div class="title-box">
            <p class="sub-title">매출 관리</p>
            <h2 class="title">판매실적</h2>
        </div>
        <form action="/sale/findDate" method="post" class="form-container">
                        <div class="dateForm">
                            <input type="date" name="startDate" id="startDate">
                            <input type="date" name="endDate" id="endDate">
                            <button type="submit" class="btn btn-blue">조회</button>
                        </div>
                        <div class="searchForm">
                            <input type="text" name="orderNumber" placeholder="발주번호 검색"/>
                            <button type="submit" class="btn btn-blue">검색</button>
                        </div>
                    </form>
        <div class="chart-container">
            <div class="doughnut-chart">
                <canvas id="salesCategoryChart"></canvas>
            </div>
            <div class="line-chart">
                <canvas id="salesChart"></canvas>
            </div>
        </div>
    </div>

    <!-- 1. 도넛 차트 (판매 품목에 따른 분류) -->
    <script>
        var salesLabels = [];
        var salesData = [];

        <c:forEach items="${saleCategory}" var="entry">
            salesLabels.push(JSON.stringify('${entry.key}'));
            salesData.push(${entry.value});
        </c:forEach>

        var itemCtx = document.getElementById('salesCategoryChart').getContext('2d');
        var itemsChart = new Chart(itemCtx, {
            type: 'doughnut',
            data: {
                labels: salesLabels,
                datasets: [{
                    label: '판매 품목에 따른 분류',
                    data: salesData,
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.7)',
                        'rgba(54, 162, 235, 0.7)',
                        'rgba(255, 206, 86, 0.7)',
                        'rgba(75, 192, 192, 0.7)',
                        'rgba(153, 102, 255, 0.7)',
                        'rgba(255, 159, 64, 0.7)',
                        'rgba(201, 203, 207, 0.7)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)',
                        'rgba(201, 203, 207, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'right'
                    },
                    title: {
                        display: true,
                        text: '판매 항목별 비율'
                    }
                }
            }
        });
    </script>

    <!-- 2. 꺾은선 차트 (월별 판매 추이) -->
    <script>
        var salesCtx = document.getElementById('salesChart').getContext('2d');
        var salesChart = new Chart(salesCtx, {
            type: 'line',
            data: {
                labels: ['1월', '2월', '3월', '4월', '5월', '6월'],
                datasets: [{
                    label: '월별 판매량',
                    data: [120, 190, 300, 250, 400, 350],
                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                    borderColor: 'rgba(54, 162, 235, 1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.3,
                    pointBackgroundColor: 'rgba(54, 162, 235, 1)',
                    pointBorderColor: '#fff',
                    pointHoverBackgroundColor: '#fff',
                    pointHoverBorderColor: 'rgba(54, 162, 235, 1)'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        title: {
                            display: true,
                            text: '판매량'
                        }
                    },
                    x: {
                        title: {
                            display: true,
                            text: '월'
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    },
                    title: {
                        display: true,
                        text: '월별 판매 추이'
                    }
                }
            }
        });
    </script>
</body>
</html>
