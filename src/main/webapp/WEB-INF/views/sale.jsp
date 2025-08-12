<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib prefix="spring"
uri="http://www.springframework.org/tags" %> <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib
prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%@ include file="/WEB-INF/views/header.jsp" %>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <title>판매실적</title>
    <script src="${pageContext.request.contextPath}/webjars/chartjs/2.9.4/Chart.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css" />
  </head>
  <body>
    <div class="container">
      <div class="title-box">
        <p class="sub-title">매출 관리</p>
        <h2 class="title">판매실적</h2>
      </div>

      <div class="section-wrap80">
        <div class="search-period-info">
          <c:if test="${not empty findDate}">
            <p>${findDate} 판매 실적입니다.</p>
          </c:if>
        </div>

        <form action="/sales/saleList" method="get" class="form-container">
          <div class="dateForm">
            <input type="date" name="startDate" id="startDate" />
            <span>~</span>
            <input type="date" name="endDate" id="endDate" />
            <button type="submit" class="btn btn-blue">조회</button>
          </div>
          <div class="searchForm">
            <select style="width: 120px" name="year" class="saleYear-select">
              <option value="">조회년도</option>
              <c:forEach var="year" items="${saleYear}">
                <option value="${year}">${year}</option>
              </c:forEach>
            </select>
            <button type="submit" class="btn btn-blue">검색</button>
          </div>
        </form>

        <div class="chart-container">
          <!-- 파이 차트 카드 -->
          <div class="chart-card">
            <h3 class="chart-title" style="height: 10%">판매 항목별 비율</h3>
            <canvas id="salesCategoryChart"></canvas>
            <div class="chart-legend">
              <c:forEach var="entry" items="${saleCategory}" varStatus="st">
                <c:if test="${st.index < 5}">
                  <span>
                    <span class="dot dot-${st.index}"></span>
                    ${entry.key}
                  </span>
                </c:if>
              </c:forEach>
            </div>
          </div>

          <!-- 라인 차트 카드 -->
          <div class="chart-card">
            <h3 class="chart-title">월별 판매 추이</h3>
            <canvas id="salesChart"></canvas>
            <div class="chart-legend">
              <span></span>
            </div>
          </div>
        </div>
      </div>
      <!-- section-wrap80 -->
    </div>
    <!-- container -->

    <!-- 1) 파이 차트 (제품별 판매 비율) -->
    <script>
      (function(){
        var rawSalesData = [];
        <c:forEach items="${saleCategory}" var="entry">
          rawSalesData.push({ label: '${entry.key}', value: ${entry.value} });
        </c:forEach>;

        rawSalesData.sort(function(a,b){ return b.value - a.value; });

        var salesLabels = rawSalesData.map(function(i){ return i.label; });
        var salesData   = rawSalesData.map(function(i){ return i.value; });

        var colors = [
          "rgba(25,118,210,0.85)","rgba(40,126,216,0.85)",
          "rgba(66,165,245,0.85)","rgba(100,181,246,0.85)",
          "rgba(144,202,249,0.85)","rgba(179,229,252,0.85)",
          "rgba(2,136,209,0.85)","rgba(3,155,229,0.85)",
          "rgba(21,101,192,0.85)"
        ];

        var pieCtx = document.getElementById("salesCategoryChart").getContext("2d");
        new Chart(pieCtx, {
          type: "doughnut",
          data: {
            labels: salesLabels,
            datasets: [{
              data: salesData,
              backgroundColor: colors.slice(0, salesData.length),
              borderColor: "rgba(255,255,255,1)",
              borderWidth: 2
            }]
          },
          options: {
            responsive:true,
            maintainAspectRatio:false,
            legend:{ display:false },
            title:{ display:false },
            tooltips:{
               bodyFontSize: 14,
              callbacks:{
                label:function(tooltipItem, data){
              var idx   = tooltipItem.index;
              var label = data.labels[idx] || "";
              var ds    = data.datasets[tooltipItem.datasetIndex];
              var val   = Number(ds.data[idx] || 0);
              var total = ds.data.reduce(function(a,b){ return Number(a||0)+Number(b||0); },0);
              var pct   = total>0 ? (val/total*100).toFixed(1) : 0;

              return pct + '% (' + label + ')';
            }
              }
            }
          }
        });
      })();
    </script>

    <!-- 2) 라인 차트 (월별 판매 추이) -->
    <script>
      (function () {
        var labels = [],
          values = [];
        <c:forEach items="${monthPrice}" var="entry">
          labels.push('${entry.key}'); values.push(${entry.value});
        </c:forEach>;

        var ctx = document.getElementById('salesChart').getContext('2d');
        var grad = ctx.createLinearGradient(0, 0, 0, 240);
        grad.addColorStop(0, 'rgba(25,118,210,0.25)');
        grad.addColorStop(1, 'rgba(25,118,210,0.02)');

        new Chart(ctx, {
          type: 'line',
          data: {
            labels: labels,
            datasets: [
              {
                data: values,
                backgroundColor: grad,
                borderColor: 'rgba(25,118,210,1)',
                borderWidth: 2,
                pointBackgroundColor: 'rgba(25,118,210,1)',
                pointBorderColor: '#fff',
                pointRadius: 3,
                lineTension: 0.3,
                fill: true,
              },
            ],
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            legend: { display: false }, // 커스텀 도트 범례만 사용
            title: { display: false },
            tooltips: {
              bodyFontSize: 14,
              callbacks: {
                label: function (tooltipItem) {
                  var v = Number(tooltipItem.yLabel || 0);
                  return v.toLocaleString('ko-KR') + '원';
                },
              },
            },
            scales: {
              xAxes: [
                {
                  gridLines: { color: 'rgba(0,0,0,0.05)' },
                  ticks: { maxRotation: 0 },
                },
              ],
              yAxes: [
                {
                  gridLines: { color: 'rgba(0,0,0,0.06)' },
                  ticks: {
                    beginAtZero: true,
                    callback: function (v) {
                      return Number(v).toLocaleString('ko-KR');
                    },
                  },
                },
              ],
            },
          },
        });
      })();
    </script>
  </body>
</html>
