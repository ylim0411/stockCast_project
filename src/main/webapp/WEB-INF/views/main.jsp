<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ page import="java.time.LocalDate" %> <%@ page
import="java.time.format.TextStyle" %> <%@ page import="java.util.Locale" %> <% LocalDate futureDate =
LocalDate.now().plusDays(3); String dayOfWeek = futureDate.getDayOfWeek().getDisplayName(TextStyle.SHORT,
Locale.KOREAN); String formattedDate = futureDate.getMonthValue() + "월 " + futureDate.getDayOfMonth() + "일 (" +
dayOfWeek + ")"; %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>StockCast</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css" />
    <%@ include file="/WEB-INF/views/header.jsp" %>
  </head>
  <body>
    <div id="main" class="container">
      <!-- <div class="title-box">
        <p class="sub-title">대시보드</p>
        <h2 class="title">대시보드</h2>
      </div> -->

      <div class="section-wrap100">
        <div class="section1">
          <div class="weather-box">
            <div class="weather-content">
              <div class="temperature">
                <p class="box-title"><%= formattedDate %> 예상 날씨</p>
                <strong>${weather.temperature != null ? weather.temperature : '정보 없음'}°C</strong>
                <span class="rain">강수확률 ${weather.pop}%</span>
              </div>
              <img src="/static/images/weather/${weather.icon}.png" alt="날씨 아이콘" class="weather-icon" />
            </div>
            <!-- weather-content -->

            <div class="recommend-banner">
              <p class="recommend-text"><span>${weather.recommendation}</span>의 판매량이 </br> 늘어날 것으로 예상됩니다.</p>
              <div class="banner-buttons">
                <button onclick="location.href='/order/orderSave'" class="btn btn-blue">발주서 작성</button>
                <button onclick="location.href='/product/list'" class="btn btn-blue">상품 목록 보기</button>
              </div>
            </div>
            <!-- recommend-banner -->
          </div>
          <!-- weather-box -->

          <!-- 유동인구 예측 박스 -->
          <div class="traffic-box">
            <div class="traffic-content">
              <div class="temperature">
                <strong>
                  <c:choose>
                    <c:when test="${traffic.maxGroup == '10대'}">
                      <strong>${traffic.age10}</strong>
                    </c:when>
                    <c:when test="${traffic.maxGroup == '20대'}">
                      <strong>${traffic.age20}</strong>
                    </c:when>
                    <c:when test="${traffic.maxGroup == '30대'}">
                      <strong>${traffic.age30}</strong>
                    </c:when>
                    <c:when test="${traffic.maxGroup == '40대'}">
                      <strong>${traffic.age40}</strong>
                    </c:when>
                    <c:when test="${traffic.maxGroup == '50대'}">
                      <strong>${traffic.age50}</strong>
                    </c:when>
                    <c:when test="${traffic.maxGroup == '60대'}">
                      <strong>${traffic.age60}</strong>
                    </c:when>
                    <c:when test="${traffic.maxGroup == '70대'}">
                      <strong>${traffic.age70}</strong>
                    </c:when>
                    <c:otherwise>
                      <strong>정보 없음</strong>
                    </c:otherwise>
                  </c:choose>
                </strong>
                <span class="rain">유동인구 최다 연령대: ${traffic.maxGroup}</span>
              </div>
              <img src="/static/images/weather/${traffic.icon}.png" alt="사람 아이콘" class="weather-icon" />
            </div>

            <div class="recommend-banner">
              <p class="recommend-text"><span>${traffic.recommendation}</span>의 판매량이 </br> 늘어날 것으로 예상됩니다.</p>
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

           </div>
          </div>
          <div class="ranking-box">
            <div class="temperature">
             <p class="box-title">판매실적 순위</p>
            </div>
            <div class="ranking">

            </div>
          </div>
        </div>
        <!-- section2 -->
      </div>
      <!-- section-wrap80 -->
    </div>
  </body>
</html>
