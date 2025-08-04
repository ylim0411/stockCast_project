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
          <p>${sessionScope.loginedAdminDTO.adminName} 님</p>
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
                <img src="${pageContext.request.contextPath}/static/images/sale.png" alt="saleIcon" />
                <span>매출관리</span>
              </a>

              <ul class="sub-menu" style="${fn:contains(uri, '/sale') ? 'display:block;' : ''}">
                <li class="${fn:contains(uri, '/sale/list') ? 'on' : ''}">
                  <a href="${pageContext.request.contextPath}/sale/list"> 판매 실적 </a>
                </li>

                <li class="${fn:contains(uri, '/sale/accounting') ? 'on' : ''}">
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
          <a href="/mypage/" class="on">마이페이지</a>
          <a href="/">로그아웃</a>
        </div>
      </header>

  <script>
$(function () {
  // 기존의 메인 메뉴 클릭 이벤트
  $("li.main-menu > a").on("click", function (e) {
    const href = $(this).attr("href");
    if (href === "#") {
      e.preventDefault();
    }

    const $clickedMenu = $(this).parent();
    const $subMenu = $clickedMenu.find(".sub-menu");

    // if (isAlreadyOpen) return;을 주석 해제하여 기존 기능 활성화
    // const isAlreadyOpen = $clickedMenu.hasClass("on");
    // if (isAlreadyOpen) return;

    $("li.main-menu").removeClass("on").find(".sub-menu").stop(true, true).slideUp(400, function() {
        $clickedMenu.addClass("on");
        $subMenu.stop(true, true).slideDown();

        $(".sub-menu li").removeClass("on");
        $subMenu.find("li").first().addClass("on");
    });
  });

  // 새로 추가할 서브 메뉴 클릭 이벤트
  // 서브 메뉴 안의 <a> 태그에 대한 이벤트를 별도로 정의
  $("li.sub-menu a").on("click", function(e) {
      // 상위 요소로의 이벤트 전파를 막습니다.
      // 이렇게 하면 메인 메뉴의 클릭 이벤트가 실행되지 않습니다.
      e.stopPropagation();

      // 현재 클릭된 서브 메뉴 항목에만 'on' 클래스 추가
      $(".sub-menu li").removeClass("on");
      $(this).parent().addClass("on");

      // 페이지 이동이 정상적으로 이루어지도록 합니다.
      // 여기서 e.preventDefault()를 사용하지 않으면 링크로 이동합니다.
  });
});
  </script>

