<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>
<%
    LocalDate futureDate = LocalDate.now().plusDays(3);
    String dayOfWeek = futureDate.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.KOREAN);
    String formattedDate = futureDate.getMonthValue() + "월 " + futureDate.getDayOfMonth() + "일 (" + dayOfWeek + ")";
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>StockCast</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/webjars/chartjs/2.9.4/Chart.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css" />
    <%@ include file="/WEB-INF/views/header.jsp" %>
  </head>
  <body>
    <div id="main" class="container">
      <div class="section-wrap100" style="gap: 32px;">
        <div class="section1">
         <!-- 날씨 API -->
          <div class="weather-box">
            <div class="weather-content">
              <div class="temperature">
                <p class="box-title"><%= formattedDate %> 예상 날씨</p>
                <strong>${weather.temperature != null ? weather.temperature : '정보 없음'}°C</strong>
                <span class="rain">강수확률 ${weather.pop}%</span>
              </div>
               <img src="/static/images/weather/${not empty weather.icon ? weather.icon : 'default'}.png" alt="날씨 아이콘" class="weather-icon" />
            </div>
            <!-- weather-content -->

            <div class="recommend-banner">
            <p class="recommend-text">
                <span class="weather-recommendation">${weather.recommendation != null ? weather.recommendation : '추천 문구 없음'}</span>의 판매량이 <br>
                늘어날 것으로 예상됩니다.
            </p>
              <div class="banner-buttons">
                <button onclick="location.href='/order/orderSave'" class="btn btn-blue">발주서 작성</button>
                <button onclick="location.href='/product/list'" class="btn btn-blue">상품 목록 보기</button>
              </div>
            </div>
            <!-- recommend-banner -->
          </div>
          <!-- weather-box -->

          <!-- 유동인구 API -->
          <div class="traffic-box">
            <div class="traffic-content">
              <div class="temperature">
                <strong>${traffic.temperature != null ? traffic.temperature : '정보 없음'}</strong>
                <span class="rain">유동인구 최다 연령대: ${traffic.maxGroup != null ? traffic.maxGroup : '정보 없음'}</span>
              </div>
              <img src="/static/images/age/${not empty traffic.icon ? traffic.icon : 'age20'}.png" alt="사람 아이콘" class="age-icon" />
            </div>

            <div class="recommend-banner">
              <p class="recommend-text">
                  <span class="traffic-recommendation">${traffic.recommendation != null ? traffic.recommendation : '추천 문구 없음'}</span>의 판매량이 </br> 늘어날 것으로 예상됩니다.
              </p>
              <div class="banner-buttons">
                <button onclick="location.href='/order/orderSave'" class="btn btn-blue">발주서 작성</button>
                <button onclick="location.href='/product/list'" class="btn btn-blue">상품 목록 보기</button>
              </div>
            </div>
          </div>
        </div>
        <!-- section1 -->

        <div class="section2">
        <div class="sales-chart-box">
          <p class="title">수익/비용 통계</p>
          <div class="chart-box">
            <canvas id="moneyChart"></canvas>
          </div>
          <div class="chart-legend">
            <span><span class="dot revenue"></span> 수익</span>
            <span><span class="dot expense"></span> 비용</span>
          </div>
        </div>
          <div class="ranking-box">
             <p class="title">판매실적 순위</p>
            <ul class="ranking">
              <c:forEach var="top" items="${saleTop}" varStatus="st">
                <li>
                  <span>${st.index + 1}</span>
                  <p>${top}</p>
                </li>
              </c:forEach>
            </ul>
          </div>
        </div>
        <!-- section2 -->
      </div>
      <!-- section-wrap100 -->
    </div>
  </body>

  <script>
    $(document).ready(function () {
      // 날씨
      $.ajax({
        url: '/api/weather',
        type: 'GET',
        success: function (data) {
          $('.temperature strong').first().text(data.temperature + '°C');
          $('.temperature .rain').first().text('강수확률 ' + data.pop + '%');
          $('.weather-icon').first().attr('src', '/static/images/weather/' + (data.icon || 'default') + '.png');
          $('.weather-recommendation').text(data.recommendation);
          console.log('날씨 데이터:', data);
        },
        error: function (xhr, status, error) {
          console.log('[날씨] 데이터 로드 실패:', error);
        }
      });

     // 유동인구
    $.ajax({
       url: '/api/traffic',
       type: 'GET',
       success: function (data) {
         $('.traffic-content strong').text(data.temperature || '정보 없음');
         $('.traffic-content .rain').text('유동인구 최다 연령대: ' + (data.maxGroup || '정보 없음'));
         $('.traffic-content .age-icon').attr('src', '/static/images/age/' + (data.icon || 'age20') + '.png');
         $('.traffic-recommendation').text(data.recommendation || '추천 문구 없음');
         console.log('유동인구 데이터:', data);
       },
       error: function (xhr, status, error) {
         console.log('[유동인구] 데이터 로드 실패:', error);
       }
     });
   });
  </script>
   <script>
   (function(){
     var salesLabels = [];
     var salesData = [];
     var expensesData = [];

     <c:forEach items="${monthPrice}" var="entry">
       salesLabels.push('${entry.key}');
       salesData.push(${entry.value});
     </c:forEach>

     <c:forEach items="${monthExpenses}" var="entry">
       expensesData.push(${entry.value});
     </c:forEach>

     var ctx = document.getElementById("moneyChart").getContext("2d");

     // 파랑 그라디언트 (수익)
     var gradRevenue = ctx.createLinearGradient(0,0,0,260);
     gradRevenue.addColorStop(0, "rgba(25,118,210,0.25)"); // #1976d2
     gradRevenue.addColorStop(1, "rgba(25,118,210,0.02)");

     // 빨강 그라디언트 (비용)
     var gradExpense = ctx.createLinearGradient(0,0,0,260);
     gradExpense.addColorStop(0, "rgba(216,40,40,0.25)"); // #d82828
     gradExpense.addColorStop(1, "rgba(216,40,40,0.02)");

     new Chart(ctx, {
       type: "line",
       data: {
         labels: salesLabels,
         datasets: [
           {
             label: "수익",
             data: salesData,
             backgroundColor: gradRevenue,
             borderColor: "#1976d2", /* 파랑 */
             borderWidth: 2,
             pointBackgroundColor: "#1976d2",
             pointBorderColor: "#fff",
             pointRadius: 3,
             lineTension: 0.3,
             fill: true
           },
           {
             label: "비용",
             data: expensesData,
             backgroundColor: gradExpense,
             borderColor: "#d82828", /* 빨강 */
             borderWidth: 2,
             pointBackgroundColor: "#d82828",
             pointBorderColor: "#fff",
             pointRadius: 3,
             lineTension: 0.3,
             fill: true
           }
         ]
       },
       options: {
         responsive: true,
           maintainAspectRatio: false,
           legend: { display: false },
         tooltips: {
           bodyFontSize: 14,
           callbacks: {
             label: function(tooltipItem, data){
               var ds = data.datasets[tooltipItem.datasetIndex];
               var v  = Number(tooltipItem.yLabel || 0);
               return ds.label + ": " + v.toLocaleString('ko-KR') + "원";
             }
           }
         },
         scales: {
           xAxes: [{ gridLines: { color: "rgba(0,0,0,0.05)" } }],
           yAxes: [{
             gridLines: { color: "rgba(0,0,0,0.06)" },
             ticks: {
               beginAtZero: true,
               callback: function(v){ return Number(v).toLocaleString('ko-KR'); }
             }
           }]
         }
       }
     });
   })();
   </script>


</html>
