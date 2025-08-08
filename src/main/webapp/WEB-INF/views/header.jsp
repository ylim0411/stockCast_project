<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link rel="icon" href="${pageContext.request.contextPath}/static/images/favicon.png" type="image/png">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
<c:set var="uri" value="${pageContext.request.requestURI}" />
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<c:if test="${empty sessionScope.loginedAdminDTO}">
    <c:redirect url="/admin/login"/>
</c:if>

   <header>
        <div class="logo">
         <a href="${pageContext.request.contextPath}/main">
          <img
            src="${pageContext.request.contextPath}/static/images/logo.png"
            alt="logo"
          />
          </a>
        </div>
        <div class="admin">
          <h2>${sessionScope.loginedAdminDTO.adminName} 님</h2>
         <button class="alert" onclick="openModal()">
           <img src="${pageContext.request.contextPath}/static/images/alertIcon.png" alt="alert" />
           <p class="alert-count">1</p>
         </button>
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

           <li class="main-menu ${fn:contains(uri, '/product') || fn:contains(uri, '/productCategory') ? 'on' : ''}">
               <a href="javascript:void(0);">
                   <img src="${pageContext.request.contextPath}/static/images/product.png" alt="productIcon"/>
                   <span>상품관리</span>
               </a>
               <ul class="sub-menu" style="${fn:contains(uri, '/product') || fn:contains(uri, '/productCategory') ? 'display:block;' : ''}">
                   <li class="${fn:contains(uri, '/productCategory') ? 'on' : ''}">
                       <a href="${pageContext.request.contextPath}/productCategory/list">상품 카테고리</a>
                   </li>
                   <li class="${fn:contains(uri, '/list') ? 'on' : ''}">
                       <a href="${pageContext.request.contextPath}/product/list/">전체 상품 목록</a>
                   </li>
                   <li class="${fn:contains(uri, '/stockQuantity') ? 'on' : ''}">
                       <a href="${pageContext.request.contextPath}/product/stockQuantity/">재고 현황</a>
                   </li>
               </ul>
           </li>

           <li class="main-menu ${fn:contains(uri, '/order') ? 'on' : ''}">
             <a href="javascript:void(0);">
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

         <li class="main-menu ${fn:contains(uri, '/sales') || fn:contains(uri, '/saleStmt') || fn:contains(uri, '/accounting') ? 'on' : ''}">
             <a href="javascript:void(0);">
                 <img src="${pageContext.request.contextPath}/static/images/sale.png" alt="saleIcon"/>
                 <span>매출관리</span>
             </a>
             <ul class="sub-menu" style="${fn:contains(uri, '/sales') || fn:contains(uri, '/saleStmt') || fn:contains(uri, '/accounting') ? 'display:block;' : ''}">
                 <li class="${fn:contains(uri, '/sales') ? 'on' : ''}">
                     <a href="${pageContext.request.contextPath}/sales/saleList">판매 실적</a>
                 </li>
                 <li class="${fn:contains(uri, '/saleStmt') ? 'on' : ''}">
                     <a href="${pageContext.request.contextPath}/saleStmt/saleStmtList">거래명세서</a>
                 </li>
                 <li class="${fn:contains(uri, '/accounting') ? 'on' : ''}">
                     <a href="${pageContext.request.contextPath}/accounting/accountingList">회계 관리</a>
                 </li>
             </ul>
         </li>

            <li class="main-menu  ${fn:contains(uri, '/customer') ? 'on' : ''}">
              <a href="${pageContext.request.contextPath}/customer">
                <img
                  src="${pageContext.request.contextPath}/static/images/customer.png"
                  alt="customerIcon"
                />
                <span>고객분석</span>
              </a>
            </li>

            <li class="main-menu  ${fn:contains(uri, '/client') ? 'on' : ''}">
              <a href="${pageContext.request.contextPath}/client/">
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
          <a href="/admin/logout">로그아웃</a>
        </div>
      </header>

      <!-- 모달 -->
    <div id="customModal" class="modal">
    <div class="modal-content">
      <button onclick="closeModal()" class="closeBtn" >&times;</button>
      <div class="modal-title">
        <h2> 재고 부족 알림 </h2>
      </div>
      <div class="lowStockList-box">   
      <ul id="lowStockList" class="stock-card-list">
        <!-- 재고 부족 상품 카드들이 여기 들어감 -->
         <li>
          <p>아이스크림</p>
          <p>현재 2개 / <span>필요 5개</span></p>
        </li>
      </ul>
      </div>
    </div>
  </div>

   <!-- 모달 기능 -->
    <script>
      function openModal() {
        const today = new Date().toISOString().slice(0, 10);
         $('#customModal').fadeIn();
      }

      function closeModal() {
        $('#customModal').fadeOut();
      }

      
    </script>


    <!-- 헤더 기능  -->
   <script>
       $(function () {
           // 현재 URI를 기반으로 메뉴 활성화 상태를 결정하는 함수
           function setActiveMenuByUri() {
               const currentUri = window.location.pathname;

               // 모든 'on' 클래스와 서브메뉴를 초기화합니다.
               $("li.main-menu").removeClass("on").find(".sub-menu").hide();
               $("li.sub-menu li").removeClass("on");

               // 서브메뉴가 있는 메인 메뉴를 먼저 활성화합니다.
               $("li.main-menu ul.sub-menu a").each(function () {
                   const linkUri = $(this).attr('href');
                   if (linkUri && currentUri.includes(linkUri)) {
                       const $clickedSubMenuLi = $(this).parent();
                       const $clickedMainMenu = $(this).closest("li.main-menu");

                       $clickedMainMenu.addClass("on");
                       $clickedSubMenuLi.addClass("on");
                       $clickedMainMenu.find(".sub-menu").show();
                       return false; // each 루프 중단
                   }
               });

               // 서브메뉴가 없는 메인 메뉴를 활성화합니다.
               if ($("li.main-menu.on").length === 0) { // 이미 활성화된 메뉴가 없으면
                   $("li.main-menu > a").each(function () {
                       const linkUri = $(this).attr('href');
                       if (linkUri && currentUri.includes(linkUri) && $(this).closest("li.main-menu").find(".sub-menu").length === 0) {
                           $(this).closest("li.main-menu").addClass("on");
                           return false; // each 루프 중단
                       }
                   });
               }
           }

           // 페이지 로드 시 함수 실행
           setActiveMenuByUri();

           // --- 이 부분이 수정되었습니다 ---
           // 메인 메뉴 hover 시 서브메뉴 열기
           $("li.main-menu").hover(
               function () {
                   // 마우스를 올리면 다른 모든 서브메뉴를 닫고 현재 서브메뉴를 엽니다.
                   $("li.main-menu").removeClass("hover-on");
                   $("li.main-menu .sub-menu").stop(true, true).slideUp(200);

                   $(this).addClass("hover-on");
                   $(this).find(".sub-menu").stop(true, true).slideDown(200);
               },
               function () {
                   // 마우스를 떼면
                   $(this).removeClass("hover-on");

                   // on 클래스가 적용된 메인 메뉴를 제외한 모든 서브메뉴를 닫습니다.
                   if (!$(this).hasClass('on')) {
                       $(this).find(".sub-menu").stop(true, true).slideUp(200);
                   }
               }
           );

           // 서브메뉴 클릭 시 상태를 정확하게 저장
           $("li.sub-menu a").on("click", function () {
               const $clickedMainMenu = $(this).closest("li.main-menu");
               const $clickedSubMenuLi = $(this).parent();

               // localStorage에 상태 저장 (페이지 로드 시 사용될 정보)
               localStorage.setItem("activeMainMenu", $clickedMainMenu.index());
               localStorage.setItem("activeSubMenu", $clickedSubMenuLi.index());
           });

           // 서브메뉴가 없는 메인 메뉴 클릭 시 상태 저장
           $("li.main-menu:not(:has(ul.sub-menu)) > a").on("click", function () {
               const $clickedMainMenu = $(this).closest("li.main-menu");

               // localStorage에 상태 저장
               localStorage.setItem("activeMainMenu", $clickedMainMenu.index());
               localStorage.removeItem("activeSubMenu");
           });
       });
   </script>

    <!-- 날짜 제한  -->
    <script>
      document.addEventListener('DOMContentLoaded', () => {
        const endDateInput = document.getElementById('endDate');
        const startDateInput = document.getElementById('startDate');
        const getFormattedDate = function () {
          const today = new Date();
          const year = today.getFullYear();
          const month = ('0' + (today.getMonth() + 1)).slice(-2);
          const day = ('0' + today.getDate()).slice(-2);
          const formattedDate = year + '-' + month + '-' + day;
          return formattedDate;
        };

        if (endDateInput) {
          const maxDate = getFormattedDate();
          endDateInput.setAttribute('max', maxDate);
        }
        if (startDateInput) {
          const maxDate = getFormattedDate();
          startDateInput.setAttribute('max', maxDate);
        }
      });
    </script>

