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
           <p class="alert-count"></p>
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
               <ul class="sub-menu">
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
             <ul class="sub-menu">
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
             <ul class="sub-menu">
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
          <a href="/sales/saleOrder">모의판매</a>
        </div>
      </header>

      <div id="customModal" class="modal">
    <div class="modal-content">
      <button onclick="closeModal()" class="closeBtn" >&times;</button>
      <div class="modal-title">
        <h2> 재고 부족 알림 </h2>
      </div>
      <div class="lowStockList-box">
      <ul id="lowStockList" class="stock-card-list">

        <!-- 재고 부족 상품 카드들이 여기 들어감
         <li>
          <p>아이스크림</p>
          <p>현재 2개 / <span>필요 5개</span></p>
        </li>
        -->
      </ul>
      </div>
    </div>
  </div>

   <script>
/*       function openModal() {
        const today = new Date().toISOString().slice(0, 10);
         $('#customModal').fadeIn();
      }

      function closeModal() {
        $('#customModal').fadeOut();
      }
 */

    </script>


    <script>
    $(function () {
        // 현재 URI를 기반으로 메뉴 활성화 상태를 결정하는 함수
        function setActiveMenuByUri() {
            const currentUri = window.location.pathname;
            $("li.main-menu").removeClass("on").find(".sub-menu").hide();
            $("li.sub-menu li").removeClass("on");

            let isMainMenuFound = false;

            $("li.main-menu ul.sub-menu a").each(function () {
                const linkUri = $(this).attr('href');
                if (linkUri && currentUri.includes(linkUri)) {
                    const $clickedSubMenuLi = $(this).parent();
                    const $clickedMainMenu = $(this).closest("li.main-menu");

                    $clickedMainMenu.addClass("on");
                    $clickedSubMenuLi.addClass("on");
                    $clickedMainMenu.find(".sub-menu").show();
                    isMainMenuFound = true;
                    return false;
                }
            });

            if (!isMainMenuFound) {
                $("li.main-menu > a").each(function () {
                    const linkUri = $(this).attr('href');
                    if (linkUri && currentUri.includes(linkUri) && $(this).closest("li.main-menu").find(".sub-menu").length === 0) {
                        $(this).closest("li.main-menu").addClass("on");
                        return false;
                    }
                });
            }
        }

        setActiveMenuByUri();

        let hoverTimer;
        let closeTimer;
        const delayTime = 100;

        $("li.main-menu").on("mouseenter", function () {
            const $this = $(this);
            clearTimeout(closeTimer); // 닫기 타이머 취소

            hoverTimer = setTimeout(function() {
                // 현재 메뉴가 이미 열려있는 상태면 동작하지 않음
                if ($this.hasClass('hover-on')) return;

                // 다른 모든 메뉴의 서브메뉴 닫기
                $('li.main-menu.hover-on, li.main-menu.on').not($this).each(function() {
                     $(this).removeClass('hover-on');
                     $(this).find('.sub-menu').stop(true, true).slideUp(200);
                });

                // 현재 메뉴 열기
                $this.addClass("hover-on");
                $this.find(".sub-menu").stop(true, true).slideDown(200);

            }, delayTime);
        });

        $("li.main-menu").on("mouseleave", function () {
            const $this = $(this);
            clearTimeout(hoverTimer); // 열기 타이머 취소

            closeTimer = setTimeout(function() {
                if (!$this.hasClass('on')) {
                    $this.removeClass('hover-on');
                    $this.find(".sub-menu").stop(true, true).slideUp(200);
                } else {
                    $this.removeClass('hover-on');
                }
            }, delayTime);
        });
    });
   </script>

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

    <!-- 재고 모달 -->
    <script>
      function normItem(row) {
        return {
          id:   row.productId ?? row.product_id ?? row.PRODUCTID,
          name: row.productName ?? row.product_name ?? row.PRODUCTNAME,
          qty:  row.stockQuantity ?? row.stock_quantity ?? row.STOCKQUANTITY
        };
      }

      function updateAlertCount(n){
        const $b = $('.alert-count');
        if(n>0){ $b.text(n).show(); } else { $b.hide(); }
      }

      function loadLowStockList() {
        $.getJSON("${pageContext.request.contextPath}/product/lowStock", function(data){
          console.log("[lowStock] raw:", data);
          const items = (data || []).map(normItem);
          const $list = $("#lowStockList").empty();

          if(items.length === 0){
            $list.append('<li><p>재고 부족 상품이 없습니다.</p></li>');
          }else{
            items.forEach(function(it){
              var name = it.name || '(상품명 없음)';
              var qty  = (it.qty ?? 0);
              var html =
                '<li class="low-stock-item" data-product-id="' + it.id + '">' +
                  '<p class="low-stock-name">' + name + '</p>' +
                  '<p>현재 ' + qty + '개 / <span>기준 20개</span></p>' +
                '</li>';
              $list.append(html);
            });
          }
          updateAlertCount(items.length);
        });
      }

      function openModal(){ loadLowStockList(); $('#customModal').fadeIn(); }
      function closeModal(){ $('#customModal').fadeOut(); }

      $(function(){
        $.getJSON("${pageContext.request.contextPath}/product/lowStock", function(d){
          updateAlertCount((d||[]).length);
        });
      });

      $(document).on('click','.low-stock-item', function(){
        window.location.href = "${pageContext.request.contextPath}/order/orderSave";
      });
    </script>


