<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>고객 분석</title>
    <script src="${pageContext.request.contextPath}/webjars/chartjs/2.9.4/Chart.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
</head>
<body>
<div class="container">
    <div class="title-box">
        <p class="sub-title">고객 분석</p>
        <h2 class="title">고객 분석</h2>
    </div>

    <div class="section-wrap80">
        <div class="chart-box">
            <div class="chart-card">
                <h3 class="chart-title">성별 분석 그래프</h3>
                <canvas id="genderChart"></canvas>
                <div class="chart-legend">
                    <span><span class="dot male"></span> 남성</span>
                    <span><span class="dot female"></span> 여성</span>
                </div>
            </div>

            <div class="chart-card">
                <h3 class="chart-title">나이 분석 그래프</h3>
                <canvas id="ageChart"></canvas>
                <div class="chart-legend">
                    <span><span class="dot age10"></span> 10대</span>
                    <span><span class="dot age20"></span> 20대</span>
                    <span><span class="dot age30"></span> 30대</span>
                    <span><span class="dot age40"></span> 40대</span>
                </div>
            </div>
         </div>
    </div> <!-- chart-wrap -->
</div> <!-- container -->

<script>
   // 성별 데이터 (JSP 출력 시 무조건 숫자로)
   var genderData = [
     parseInt("${customer.man != null ? customer.man : 0}", 10) || 0,
     parseInt("${customer.woman != null ? customer.woman : 0}", 10) || 0
   ];

   var genderCtx = document.getElementById('genderChart').getContext('2d');
   new Chart(genderCtx, {
       type: 'doughnut',
       data: {
           labels: ["남성", "여성"],
           datasets: [{
               data: genderData,
               backgroundColor: [
                   'rgba(25, 118, 210, 0.7)',
                   'rgba(240, 98, 146, 0.7)'
               ],
               borderColor: [
                   'rgba(25, 118, 210, 1)',
                   'rgba(240, 98, 146, 1)'
               ],
               borderWidth: 1
           }]
       },
       options: {
           responsive: true,
           maintainAspectRatio: false,
           legend: { display: false },
           tooltips: {
               bodyFontSize: 16,
               callbacks: {
                   label: function(tooltipItem, data) {
                       var idx = tooltipItem.index;
                       var label = data.labels[idx] || '';
                       var value = parseInt(data.datasets[0].data[idx], 10) || 0;
                       var total = data.datasets[0].data.reduce(function(a, b) {
                           return (parseInt(a, 10) || 0) + (parseInt(b, 10) || 0);
                       }, 0);
                       var percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                       return label + ' ' + '(' + percentage + '%)';
                   }
               }
           }
       }
   });

   // 연령별 데이터
   var ageData = [
     parseInt("${customer.age_10 != null ? customer.age_10 : 0}", 10) || 0,
     parseInt("${customer.age_20 != null ? customer.age_20 : 0}", 10) || 0,
     parseInt("${customer.age_30 != null ? customer.age_30 : 0}", 10) || 0,
     parseInt("${customer.age_40 != null ? customer.age_40 : 0}", 10) || 0
   ];

   var ageCtx = document.getElementById('ageChart').getContext('2d');
   new Chart(ageCtx, {
       type: 'doughnut',
       data: {
           labels: ["10대", "20대", "30대", "40대"],
           datasets: [{
               data: ageData,
               backgroundColor: [
                   'rgba(25, 118, 210, 0.8)',
                   'rgba(66, 165, 245, 0.8)',
                   'rgba(100, 181, 246, 0.8)',
                   'rgba(144, 202, 249, 0.8)'
               ],
               borderColor: [
                   'rgba(25, 118, 210, 1)',
                   'rgba(66, 165, 245, 1)',
                   'rgba(100, 181, 246, 1)',
                   'rgba(144, 202, 249, 1)'
               ],
               borderWidth: 1
           }]
       },
       options: {
           responsive: true,
           maintainAspectRatio: false,
           legend: { display: false },
           tooltips: {
               bodyFontSize: 16,
               callbacks: {
                   label: function(tooltipItem, data) {
                       var idx = tooltipItem.index;
                       var label = data.labels[idx] || '';
                       var value = parseInt(data.datasets[0].data[idx], 10) || 0;
                       var total = data.datasets[0].data.reduce(function(a, b) {
                           return (parseInt(a, 10) || 0) + (parseInt(b, 10) || 0);
                       }, 0);
                       var percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                       return label + ' '  + '(' + percentage + '%)';
                   }
               }
           }
       }
   });
</script>

</html>
