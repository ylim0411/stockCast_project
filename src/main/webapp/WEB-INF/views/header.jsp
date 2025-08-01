<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="uri" value="${pageContext.request.requestURI}" />

 <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
  <link rel="icon" href="${pageContext.request.contextPath}/static/images/favicon.png" type="image/png">
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

            <li class="main-menu ${fn:contains(uri, '/main') ? 'on' : ''}">

              <a href="${pageContext.request.contextPath}/main">
                <img
                  src="${pageContext.request.contextPath}/static/images/home.png"
                  alt="homeIcon"
                />
                <span>대시보드</span>
              </a>
            </li>
            <li class="main-menu ${fn:contains(uri, '/product') ? 'on' : ''}">
              <a href="${pageContext.request.contextPath}/order/orderSave">
                <img
                  src="${pageContext.request.contextPath}/static/images/product.png"
                  alt="productIcon"
                />
                <span>상품관리</span>
              </a>
              <ul class="sub-menu">
                <li class="on">
                  <a href="${pageContext.request.contextPath}/order/orderSave"> 상품 카테고리 </a>
                </li>
                <li>
                  <a href="${pageContext.request.contextPath}/order/orderSave"> 전체 상품 목록 </a>
                </li>
                <li>
                  <a href="${pageContext.request.contextPath}/order/orderSave"> 재고 현황 </a>
                </li>
              </ul>
            </li>
           <li class="main-menu ${fn:contains(uri, '/order') ? 'on' : ''}">
             <a href="${pageContext.request.contextPath}/order/orderStmt">
               <img src="${pageContext.request.contextPath}/static/images/order.png" alt="orderIcon" />
               <span>발주관리</span>
             </a>
             <ul class="sub-menu" style="${fn:contains(uri, '/order') ? 'display:block;' : ''}">
               <li class="${fn:contains(uri, '/orderStmt') ? 'on' : ''}">
                 <a href="${pageContext.request.contextPath}/order/orderStmt"> 발주 현황 </a>
               </li>
               <li class="${fn:contains(uri, '/orderSave') ? 'on' : ''}">
                 <a href="${pageContext.request.contextPath}/order/orderSave"> 발주서 작성 </a>
               </li>
             </ul>
           </li>

            <li class="main-menu  ${fn:contains(uri, '/sale') ? 'on' : ''}">
              <a href="${pageContext.request.contextPath}/sale/list">
                <img
                  src="${pageContext.request.contextPath}/static/images/sale.png"
                  alt="saleIcon"
                />
                <span>매출관리</span>
              </a>

              <ul class="sub-menu">
                <li class="${fn:contains(uri, '/sale') ? 'on' : ''}">
                  <a href="${pageContext.request.contextPath}/sale/list"> 판매 실적 </a>
                </li>
                <li class="${fn:contains(uri, '/sale') ? 'on' : ''}">
                  <a href="${pageContext.request.contextPath}/sale/accounting"> 회계 관리 </a>
                </li>
              </ul>
            </li>

            <li class="main-menu  ${fn:contains(uri, '/customer') ? 'on' : ''}">
              <a href="${pageContext.request.contextPath}/order/orderSave"">
                <img
                  src="${pageContext.request.contextPath}/static/images/customer.png"
                  alt="customerIcon"
                />
                <span>고객분석</span>
              </a>
            </li>
            <li class="main-menu  ${fn:contains(uri, '/client') ? 'on' : ''}">
              <a href="${pageContext.request.contextPath}/order/orderSave">
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
          <a href="/">로그아웃</a>
        </div>
      </header>

  <script>
   $(function () {
     // 메인 메뉴 클릭 시
     $("li.main-menu > a").on("click", function (e) {
         const href = $(this).attr("href");
         console.log("main-menu clicked:", $(this).attr("href"));

         // href가 "#"인 경우에만 기본 클릭 막음
         if (href === "#") {
           e.preventDefault();
         }

       const $clickedMenu = $(this).parent(); // li.main-menu
       const $subMenu = $clickedMenu.find(".sub-menu");

       const isAlreadyOpen = $clickedMenu.hasClass("on");

       // 이미 열려있다면 아무것도 하지 않음 (닫히지 않도록)
       if (isAlreadyOpen) return;

       // 다른 메뉴 닫기
       $("li.main-menu").removeClass("on").find(".sub-menu").slideUp();

       // 클릭한 메뉴 열기
       $clickedMenu.addClass("on");
       $subMenu.stop(true, true).slideDown();

       // 서브 메뉴 중 첫 번째 항목을 기본 활성화
       const $firstSubItem = $subMenu.find("li").first();
       $(".sub-menu li").removeClass("on");
       $firstSubItem.addClass("on");
     });


      // 서브 메뉴 클릭 시 활성화
      $(".sub-menu li a").on("click", function (e) {
        e.preventDefault();

        $(".sub-menu li").removeClass("on"); // 전체 비활성화
        $(this).parent().addClass("on"); // 클릭된 항목 활성화
      });
    });


  </script>

