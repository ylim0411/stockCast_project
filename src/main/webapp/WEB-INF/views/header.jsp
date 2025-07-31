<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

 <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
 <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>

   <header>
        <div class="logo">
          <img
            src="${pageContext.request.contextPath}/static/images/logo.png"
            alt="logo"
          />
        </div>
        <div class="admin">
          <p>홍길동 님</p> <!-- 아이디 or 이름 넣어야 함 -->
        </div>
        <nav>
          <ul>
            <li class="main-menu on">
              <a href="#">
                <img
                  src="${pageContext.request.contextPath}/static/images/home.png"
                  alt="homeIcon"
                />
                <span>대시보드</span>
              </a>
            </li>
            <li class="main-menu">
              <a href="#">
                <img
                  src="${pageContext.request.contextPath}/static/images/product.png"
                  alt="productIcon"
                />
                <span>상품관리</span>
              </a>
              <ul class="sub-menu">
                <li class="on">
                  <a href="#"> 상품 카테고리 </a>
                </li>
                <li>
                  <a href="#"> 전체 상품 목록 </a>
                </li>
                <li>
                  <a href="#"> 재고 현황 </a>
                </li>
              </ul>
            </li>
            <li class="main-menu">
              <a href="/order/orderStmt">
                <img
                  src="${pageContext.request.contextPath}/static/images/order.png"
                  alt="orderIcon"
                />
                <span>발주관리</span>
              </a>
              <ul class="sub-menu">
                <li>
                  <a href="/order/orderStmt" class="on"> 발주 현황 </a>
                </li>
                <li>
                  <a href="/order/orderForm"> 발주서 작성 </a>
                </li>
              </ul>
            </li>
            <li class="main-menu">
              <a href="#">
                <img
                  src="${pageContext.request.contextPath}/static/images/sale.png"
                  alt="saleIcon"
                />
                <span>매출관리</span>
              </a>
              <ul class="sub-menu">
                <li>
                  <a href="#" onclick="onSale()" class="on"> 판매 실적 </a>
                </li>
                <li>
                  <a href="#" onclick="onAccounting()"> 회계 관리 </a>
                </li>
              </ul>
            </li>
            <li class="main-menu">
              <a href="#">
                <img
                  src="${pageContext.request.contextPath}/static/images/customer.png"
                  alt="customerIcon"
                />
                <span>고객분석</span>
              </a>
            </li>
            <li class="main-menu">
              <a href="#">
                <img
                  src="${pageContext.request.contextPath}/static/images/client.png"
                  alt="clientIcon"
                />
                <span>거래처관리</span>
              </a>
            </li>
          </ul>
        </nav>
        <div class="userContext">
          <a href="#" class="on">마이페이지</a>
          <a href="#">로그아웃</a>
        </div>
      </header>

  <script>
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
    const onSale = () => {
          const mainDiv = $("#main");
          $.ajax({
              type: "get",
              url: "/sale/hello",
              // 요청이 성공했을 때 실행되는 부분
              success: function (res) {

                  console.log("성공", res);
                  mainDiv.html(res);

              },
              // 요청이 실패했을 때 실행되는 부분
              error: function (err) {
                  console.log("실패", err);
              },
          })
      };
        const onAccounting = () => {
            const mainDiv = $("#main");
            $.ajax({
                type: "get",
                url: "/accounting/hello",
                // 요청이 성공했을 때 실행되는 부분
                success: function (res) {
                    console.log("성공", res);
                    mainDiv.html(res);

                },
                // 요청이 실패했을 때 실행되는 부분
                error: function (err) {
                    console.log("실패", err);
                },
            })
        };
  </script>

