<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>index</title>
     <meta name="viewport" content="width=device-width, initial-scale=1">
     <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
     <%@ include file="/WEB-INF/views/header.jsp" %>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/style.css"/>
        <!-- Bootstrap CSS -->

</head>
<body>
    <div class="container">
        <div class="accounting-header">
          <h1>회계 관리</h1>
        </div>
        <div class="caption">
          <input type="date" name="startDate"> ~
          <input type="date" name="endDate">
          <input type="text" name="orderNumber" placeholder="발주번호">
          <button onclick="onSearch()">검색</button>
          <button class="btn btn-primary" type="submit">Button</button></br>
        </div>
         <table>
                <tr>
                    <th>발주번호</th>
                    <th>발주일자</th>
                    <th>거래처명</th>
                    <th>상품명</th>
                    <th>총금액</th>
                    <th>보고서</th>
                </tr>
                <c:forEach items="${accountList}" var="account">
                    <tr>
                        <td>${account.orderId}</td>
                        <td>
                            <a href="/account?id=${account.orderId}"> ${account.transactionDate}</a>
                        </td>
                        <td>${account.salesAmount}</td>
                        <td>${account.netProfit}</td>
                        <td>${account.cost}</td>
                        <td><button onclick="#">거래명세서</td>
                    </tr>
                </c:forEach>
            </table>
    </div>
</body>
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

</script>
</html>
