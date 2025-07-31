<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ include file="/WEB-INF/views/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Chart.js Example</title>
    <script src="${pageContext.request.contextPath}/webjars/chartjs/2.9.4/Chart.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/static/js/chart.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/chart.css"/>
</head>
<body>
    <div class="container">
        <div class="sale-header"></div>
            <h1>판매실적</h1>
        <div class="sale-header"></div>
        <div class="chart-container">
            <div class="doughnut-chart">
                <canvas id="itemsChart"></canvas>
            </div>
            <div class="line-chart">
                <canvas id="salesChart"></canvas>
            </div>
        </div>
    </div>

    <script>
        // 도넛 차트 (판매 항목별 비율)
        var itemCtx = document.getElementById('itemsChart').getContext('2d');
        var itemsChart = new Chart(itemCtx, {
            type: 'doughnut',  // 도넛 차트 유형
            data: {
                labels: ['전자제품', '의류', '식품', '도서', '가구', '기타'], // 라벨 예시
                datasets: [{
                    label: '판매 항목별 비율', // 데이터셋 라벨
                    data: [12, 19, 3, 5, 2, 3], // 실제 데이터 값
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.7)', // 색상 투명도 조정
                        'rgba(54, 162, 235, 0.7)',
                        'rgba(255, 206, 86, 0.7)',
                        'rgba(75, 192, 192, 0.7)',
                        'rgba(153, 102, 255, 0.7)',
                        'rgba(255, 159, 64, 0.7)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: { // options 객체가 data 객체와 같은 레벨에 있어야 합니다.
                responsive: true, // 컨테이너 크기에 맞춰 캔버스 크기 조절
                maintainAspectRatio: false, // 컨테이너 크기에 맞춰 종횡비 유지 안함
                plugins: {
                    legend: {
                        display: true,
                        position: 'right' // 범례 위치
                    },
                    title: {
                        display: true,
                        text: '판매 항목별 비율' // 차트 제목
                    }
                }
            }
        });

        // 꺾은선 차트 (월별 판매 추이)
        var salesCtx = document.getElementById('salesChart').getContext('2d');
        var salesChart = new Chart(salesCtx, {
            type: 'line',  // 꺾은선 차트 유형
            data: {
                labels: ['1월', '2월', '3월', '4월', '5월', '6월'], // 월별 라벨
                datasets: [{
                    label: '월별 판매량', // 데이터셋 라벨
                    data: [120, 190, 300, 250, 400, 350], // 실제 데이터 값
                    backgroundColor: 'rgba(54, 162, 235, 0.2)', // 선 아래 영역 배경색
                    borderColor: 'rgba(54, 162, 235, 1)', // 선 색상
                    borderWidth: 2, // 선 두께
                    fill: true, // 선 아래 영역 채우기
                    tension: 0.3, // 선의 부드러움 정도
                    pointBackgroundColor: 'rgba(54, 162, 235, 1)', // 데이터 포인트 배경색
                    pointBorderColor: '#fff', // 데이터 포인트 테두리 색상
                    pointHoverBackgroundColor: '#fff',
                    pointHoverBorderColor: 'rgba(54, 162, 235, 1)'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { // y축 설정
                        beginAtZero: true, // 0부터 시작
                        title: {
                            display: true,
                            text: '판매량' // y축 제목
                        }
                    },
                    x: { // x축 설정
                        title: {
                            display: true,
                            text: '월' // x축 제목
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
                        text: '월별 판매 추이' // 차트 제목
                    }
                }
            }
        });
          $(function () {
              // 메인 메뉴 클릭 시
              $("li.main-menu > a").on("click", function (e) {
                e.preventDefault();

                const $clickedMenu = $(this).parent(); // li.main-menu
                const $subMenu = $clickedMenu.find(".sub-menu");

                // 현재 열려있는 다른 메뉴 닫기
                $("li.main-menu")
                  .not($clickedMenu)
                  .removeClass("on")
                  .find(".sub-menu")
                  .slideUp()
                  .find("li")
                  .removeClass("on");

                // 현재 클릭한 메뉴 toggle
                const isOpen = $clickedMenu.hasClass("on");
                if (isOpen) {
                  // 열려 있으면 닫기
                  $clickedMenu.removeClass("on");
                  $subMenu.slideUp();
                } else {
                  // 닫혀 있으면 열기
                  $clickedMenu.addClass("on");
                  $subMenu.slideDown();

                  // 하위 첫 번째 서브 메뉴 항목을 활성화
                  const $firstSubItem = $subMenu.find("li").first();
                  $(".sub-menu li").removeClass("on"); // 전체 초기화
                  $firstSubItem.addClass("on");
                }
              });

              // 서브 메뉴 클릭 시 활성화
              $(".sub-menu li a").on("click", function (e) {
                e.preventDefault();

                $(".sub-menu li").removeClass("on"); // 전체 비활성화
                $(this).parent().addClass("on"); // 클릭된 항목 활성화
              });
            });
    </script>
</body>
</html>
