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
      <div class="section-wrap100">
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
           <div class="temperature">
             <p class="box-title">수익/비용 통계</p>
           </div>
           <div class="chart-box">
             <canvas id="moneyChart"></canvas>
           </div>
          </div>
          <div class="ranking-box">
            <div class="temperature">
             <table>
               <tr>
                <th colspan="2">판매실적 순위</th>
               </tr>
              <c:set var="number" value="1"/>
              <c:forEach var="top" items="${saleTop}">
                <tr>
                 <td>${number}</td>
                 <td>${top}</td>
                </tr>
               <c:set var="number" value="${number+1}"/>
              </c:forEach>
             </table>
            </div>
            <div class="ranking">

            </div>
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
     // JSP에서 JSTL을 사용하여 동적으로 데이터 생성
     var salesLabels = [];
     var salesData = [];
     var expensesData = []; // 비용 데이터를 위한 새로운 배열

     // 수익 데이터
     <c:forEach items="${monthPrice}" var="entry">
         salesLabels.push('${entry.key}');
         salesData.push(${entry.value});
     </c:forEach>

     // 비용 데이터를 가져오는 JSTL (예시)
     // Controller에서 비용 데이터를 monthExpenses 같은 이름으로 전달해야 합니다.
     <c:forEach items="${monthExpenses}" var="entry">
         expensesData.push(${entry.value});
     </c:forEach>

     var salesCtx = document.getElementById("moneyChart").getContext("2d");
     var salesChart = new Chart(salesCtx, {
       type: "line",
       data: {
         labels: salesLabels,
         datasets: [
           {
             label: "수익", // 첫 번째 데이터셋: 수익
             data: salesData,
             backgroundColor: "rgba(54, 162, 235, 0.2)", // 수익 라인 색상
             borderColor: "rgba(54, 162, 235, 1)",
             borderWidth: 2,
             fill: true,
             tension: 0.3,
             pointBackgroundColor: "rgba(54, 162, 235, 1)",
             pointBorderColor: "#fff",
             pointHoverBackgroundColor: "#fff",
             pointHoverBorderColor: "rgba(54, 162, 235, 1)",
           },
           {
             label: "비용", // 두 번째 데이터셋: 비용
             data: expensesData,
             backgroundColor: "rgba(255, 99, 132, 0.2)", // 비용 라인 색상
             borderColor: "rgba(255, 99, 132, 1)",
             borderWidth: 2,
             fill: true,
             tension: 0.3,
             pointBackgroundColor: "rgba(255, 99, 132, 1)",
             pointBorderColor: "#fff",
             pointHoverBackgroundColor: "#fff",
             pointHoverBorderColor: "rgba(255, 99, 132, 1)",
           }
         ],
       },
       options: {
         responsive: true,
         maintainAspectRatio: false,
         scales: {
           xAxes: [{
             scaleLabel: {
               display: false
             }
           }],
           yAxes: [{
             ticks: {
               beginAtZero: true
             },
             scaleLabel: {
               display: false
             }
           }]
         },
         legend: {
           display: true, // 범례를 다시 보이도록 설정하여 수익/비용 라인을 구분
           position: 'bottom',
         },
         title: {
           display: true,
           text: "수익/비용 통계",
         },
       },
     });
   </script>
</html>
